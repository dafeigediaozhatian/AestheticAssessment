function s = symmetry2(f)
% SYMMETRY computes the symmetry feature of the original RGB image.
% Symmetry feature is generated from the origin left half of the image and
% the flipped right half of the image, calculate the difference of the hog
% value and apply euclidean norm on this vector

% flip image
ncols = size(f,2);
im_l = f(:,1:floor(ncols/2),:);
im_r = fliplr(f(:,(floor(ncols/2)+1):(floor(ncols/2)+floor(ncols/2)),:));

% HOG operation on both left half and flipped right half
hog_l = vl_hog(im2single(im_l),8,'variant','dalaltriggs');
hog_r = vl_hog(im2single(im_r),8,'variant','dalaltriggs');

% reshape histograms into a vactor
hog_l = reshape(hog_l,size(hog_l,1)*size(hog_l,2)*size(hog_l,3),1);
hog_r = reshape(hog_r,size(hog_r,1)*size(hog_r,2)*size(hog_r,3),1);

hog_diff = hog_l-hog_r;

% Euclidean norm
s = norm(hog_diff);