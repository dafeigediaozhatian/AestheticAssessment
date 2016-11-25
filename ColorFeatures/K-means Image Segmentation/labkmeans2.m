function s = labkmeans2(f,n)
% HSVKMEANS2 applies kmeans to divide image into n segments using L*a*b 
% color space.
% s is a cell containing all the image segments, f is the original RGB
% image, n is the number of segments (i.e. k's value)

if nargin<2
    error('not enough argumets.')
end

cform = makecform('srgb2lab');
lab_f = applycform(f,cform);
ab = double(lab_f(:,:,2:3));
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
% n can be changed according to situations
nColors=n;
% 'sqEuclidean' can be replaced by 'cityblock','cosine', 'correlation',
% 'hamming'; 
%repeat the clustering 3 times to avoid local minima
[cluster_idx,~] = kmeans(ab,nColors,'distance','sqEuclidean',...
    'maxIter',50);
pixel_labels = reshape(cluster_idx,nrows,ncols);
segmented_images = cell(1,n);
rgb_label = repmat(pixel_labels,[1 1 3]);
for k = 1:nColors
    color = f;
    color(rgb_label~=k) = 0;
    segmented_images{k} = color;
end

s = segmented_images;