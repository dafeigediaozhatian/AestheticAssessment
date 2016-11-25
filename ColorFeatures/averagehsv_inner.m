function  hsv_avg = averagehsv_inner(f)
% INNERAVGHSV is a function calculates the average hue, saturation and value
% of an image's inner quadrant. hsv_avg(1) is hue avg, hsv_avg(2) is 
% saturation avg, hsv_avg(3) is value avg


fhsv = rgb2hsv(f);
nrows = size(fhsv,1);
ncols = size(fhsv,2);
innerq = fhsv(round(nrows/3+1):round(nrows*2/3),round(ncols/3+1):round(ncols*2/3),:);
nrowsq = size(innerq,1);
ncolsq = size(innerq,2);

innerqr = reshape(innerq,nrowsq*ncolsq,3);

hsv_avg = mean(innerqr);
% hsv_avg = [h_avg,s_avg,v_avg]