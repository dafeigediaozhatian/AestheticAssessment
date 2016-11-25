function avg = averagehsv(f)
% AVERAGEHSV calculate the average hue, saturation and brightness of the 
% whole original RGB image.

fhsv = double(rgb2hsv(f));
nrows = size(fhsv,1);
ncols = size(fhsv,2);

fhsvr = reshape(fhsv,nrows*ncols,3);
avg = mean(fhsvr);
% avg = [fh_avg, fs_avg, fv_avg]