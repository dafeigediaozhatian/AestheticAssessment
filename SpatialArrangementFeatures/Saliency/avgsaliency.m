function avgsals = avgsaliency(im,num)
% AVG_SALIENCY computes average saliency values for each
% subregion.
% im is the original RGB image; num is the parameter (image is divided into 
% num-by-num subregions)

% saliency matrix of image
salmap = saliencymap(im);
[nrows,ncols] = size(salmap);

% resize salmap
mrow = mod(nrows,num);
if mrow == 1
    salmap = salmap(1:end-1,:);
elseif mod(mrow,2) == 0
    salmap = salmap(1+mrow/2:end-mrow/2,:);
else
    salmap = salmap(1+floor(mrow/2):end-(mrow-floor(mrow/2)),:);
end

mcol = mod(ncols,num);
if mcol == 1 
    salmap = salmap(:,1:end-1);
elseif mod(mcol,2) == 0
    salmap = salmap(:,1+mcol/2:end-mcol/2);
else
    salmap = salmap(:,1+floor(mcol/2):end-(mcol-floor(mcol/2)));
end

[nrows,ncols] = size(salmap);
% divide img into num-by-num subregions
imcells = mat2cell(salmap,(nrows/num)*ones(1,num),(ncols/num)*ones(1,num));

% compute average saliency value and put the result into a vector
avgsals = zeros(1,num*num);
for i = 1:num*num
    sumc = sum(imcells{i});
    allsum = sum(sumc);
    avgsals(i) = allsum/numel(imcells{i});
end