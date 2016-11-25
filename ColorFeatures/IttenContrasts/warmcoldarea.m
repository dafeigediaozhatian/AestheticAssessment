function [w,c] = warmcoldarea(f)
% WARMCOLDAREA calculate the total amount of warm and cold area
% respectively according to the warm-cold membership function, which is:
% warm (hue 0~140 & 320~360) and cold (hue 320~360)

flch=double(colorspace('->lch',f));
fh = flch(:,:,3);

w = (length(find(fh<140))+length(find((fh>=320) & (fh<=360))))/numel(fh);
c = length(find((fh>=140) & (fh<320)))/numel(fh);

