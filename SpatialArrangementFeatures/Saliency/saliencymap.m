function map = saliencymap(imname)
% Demo for paper "Saliency Detection via Graph-Based Manifold Ranking"
% by Chuan Yang, Lihe Zhang, Huchuan Lu, Ming-Hsuan Yang, and Xiang Ruan
% To appear in Proceedings of IEEE Conference on Computer Vision and Pattern Recognition (CVPR 2013), Portland, June, 2013.
%%------------------------set parameters---------------------%%
theta=10; % control the edge weight
alpha=0.99;% control the balance of two items in manifold ranking cost function
spnumber=200;% superpixel number

[input_im,w]=removeframe(imname);% run a pre-processing to remove the image frame
[m,n,k] = size(input_im);

%%----------------------generate superpixels--------------------%%
% superpixels label matrix
% spnum is the actural superpixel number
[superpixels,spnum] = slicmex(im2uint8(input_im),spnumber,20);
superpixels = superpixels+1;
spnum = double(spnum);
%%----------------------design the graph model--------------------------%%
% compute the feature (mean color in lab color space)
% for each node (superpixels)
input_vals=reshape(input_im, m*n, k);
rgb_vals=zeros(spnum,1,3);
inds=cell(spnum,1);
for i=1:spnum
    inds{i}=find(superpixels==i); % indeces of pixels equal to i (i = 1~189)
    rgb_vals(i,1,:)=mean(input_vals(inds{i},:),1);
end
lab_vals = colorspace('Lab<-', rgb_vals);
seg_vals=reshape(lab_vals,spnum,3);% feature for each superpixel

% get edges
adjloop=AdjcProcloop(superpixels,spnum);    %compute the adjacent matrix
edges=[];
for i=1:spnum
    indext=[];
    ind=find(adjloop(i,:)==1); 
    for j=1:length(ind)
        indj=find(adjloop(ind(j),:)==1);
        indext=[indext,indj];
    end
    indext=[indext,ind];
    indext=indext((indext>i));
    indext=unique(indext);
    if(~isempty(indext))
        ed=ones(length(indext),2);
        ed(:,2)=i*ed(:,2);
        ed(:,1)=indext;
        edges=[edges;ed];
    end
end

% compute affinity matrix
weights = makeweights(edges,seg_vals,theta);
W = adjacency(edges,weights,spnum);

% learn the optimal affinity matrix (eq. 3 in paper)
dd = sum(W); D = sparse(1:spnum,1:spnum,dd); clear dd; % D is dd in diagonal matirx
optAff =(D-alpha*W)\eye(spnum);
mz=diag(ones(spnum,1));
mz=~mz;
optAff=optAff.*mz;

%%-----------------------------stage 1--------------------------%%
% compute the saliency value for each superpixel
% with the top boundary as the query
Yt=zeros(spnum,1);
bst=unique(superpixels(1,1:n)); % label of each side
Yt(bst)=1;
bsalt=optAff*Yt;
bsalt=(bsalt-min(bsalt(:)))/(max(bsalt(:))-min(bsalt(:))); % normalize
bsalt=1-bsalt; % complement, the saliency measure

% down
Yd=zeros(spnum,1);
bsd=unique(superpixels(m,1:n));
Yd(bsd)=1;
bsald=optAff*Yd;
bsald=(bsald-min(bsald(:)))/(max(bsald(:))-min(bsald(:)));
bsald=1-bsald;

% right
Yr=zeros(spnum,1);
bsr=unique(superpixels(1:m,1));
Yr(bsr)=1;
bsalr=optAff*Yr;
bsalr=(bsalr-min(bsalr(:)))/(max(bsalr(:))-min(bsalr(:)));
bsalr=1-bsalr;

% left
Yl=zeros(spnum,1);
bsl=unique(superpixels(1:m,n));
Yl(bsl)=1;
bsall=optAff*Yl;
bsall=(bsall-min(bsall(:)))/(max(bsall(:))-min(bsall(:)));
bsall=1-bsall;

% combine
bsalc=(bsalt.*bsald.*bsall.*bsalr);
bsalc=(bsalc-min(bsalc(:)))/(max(bsalc(:))-min(bsalc(:))); % normalize

%%----------------------stage2-------------------------%%
% binary with an adaptive threshold (i.e. mean of the saliency map)
th=mean(bsalc);
bsalc(bsalc<th)=0;
bsalc(bsalc>=th)=1;

% compute the saliency value for each superpixel
fsal=optAff*bsalc;

% assign the saliency value to each pixel
tmapstage2=zeros(m,n);
for i=1:spnum
    tmapstage2(inds{i})=fsal(i);
end
tmapstage2=(tmapstage2-min(tmapstage2(:)))/(max(tmapstage2(:))-min(tmapstage2(:)));

mapstage2=zeros(w(1),w(2));
mapstage2(w(3):w(4),w(5):w(6))=tmapstage2;
mapstage2=uint8(mapstage2*255);
map = mapstage2;