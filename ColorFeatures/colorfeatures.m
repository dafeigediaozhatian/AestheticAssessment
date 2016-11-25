function features = colorfeatures(f)
% COLORFEATURES presents all color features extracted from original RGB
% image f, including: contrast (luminance); average hue, saturation,
% brightness of the whole image; average hue, saturation, brightness of 
% inner quadrant; emotional dimensions (pleasure, arousal, dominance); 
% the occurrance of 11 color names  and itten color contrasts (light&dark, 
% saturation, hue, complements, warm-cold, area of warm and cold regions).

% functions involved: lumicontrast(1), averagehsv(3), averagehsv_inner(3),
% emotion(3), colornamequant(11), ittencontrasts(7) 28 features in total

contrast = lumicontrast(f);
avghsv_whole = averagehsv(f);
avghsv_inner = averagehsv_inner(f);
emotiondim = emotion(f);
colornames = colornamequant(f);
itten = ittencontrasts(f);

features = [contrast,avghsv_whole,avghsv_inner,emotiondim,colornames,itten];