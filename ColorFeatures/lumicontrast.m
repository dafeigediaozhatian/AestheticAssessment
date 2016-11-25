function c = lumicontrast(f)
% LUMICONTRAST calculates the luminance contrast of a RGB image acording to
% the formular Contrast = Ymax-Ymin/Yavg.
% f is the original RGB image.

fycbcr = double(rgb2ycbcr(f));
luma = fycbcr(:,:,1);
lumimax = max(luma(:));
lumimin = min(luma(:));
lumiavg = mean2(luma);

c = (lumimax-lumimin)/lumiavg; 
