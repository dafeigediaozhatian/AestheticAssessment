function cn = colornamequant(f)
% COLORNAMEQUANT quantizes the original RGB image f into 11 color name
% bins. The colors are black, blue, brown, grey, orange, pink, purple, red,
% white and yellow (corresponding to 1~11).

% this function implements im2c().

load('w2c.mat');
fd = double(f);

out = im2c(fd,w2c,0);
nrows = size(out,1);
ncols = size(out,2);

outr = reshape(out,nrows*ncols,1);

cn = hist(outr,1:11)/(nrows*ncols);


