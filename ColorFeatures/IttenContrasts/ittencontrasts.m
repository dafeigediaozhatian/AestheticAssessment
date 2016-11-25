function contrasts = ittencontrasts(f)
% ITTENCONTRASTS computes the itten contrasts (light&dark contrast, 
% saturation contrast, hue contrast, complements contrast, warm&cold 
% contrast and the total amount of warm and cold area) in the RGB image f.

% Firstly, segment image f (labkmeans2); 
% secondly, calculate average hsv (reducecolor); 
% thirdly, obtain brightness fuzzy membership value, saturation fuzzy 
% membership value and warm-cold fuzzy membership value of each region 
% (fuzzylfs&fuzzycfs&fuzzytfs); 
% next compute contrasts and warm-cold area

% segment image into 8 regions
segs = labkmeans2(f,8);

% average l,c,h
s_reduce = cell(1,8);
for i=1:8
    s_reduce{i} = reducecolor(segs{i});
end
luminance = zeros(1,8);
chroma = zeros(1,8);
hue = zeros(1,8);
area = zeros(1,8);

for i=1:8
    luminance(i) = s_reduce{i}{1}(1);
    chroma(i) = s_reduce{i}{1}(2);
    hue(i) = s_reduce{i}{1}(3);
    area(i) = s_reduce{i}{2};
end

% membership function values (luminance, chroma, warm-cold)
lumi_mf = zeros(8,6);
ch_mf = zeros(8,4);
wc_mf = zeros(8,4);
% the first 5 values of each row of lumi_mf are membership values for each 
% membership function while the last value is the general mf value used for
% std calculation. Same as ch_mf and wc_mf
for i=1:8
    lumi_mf(i,:) = fuzzylfs(luminance(i));
    ch_mf(i,:) = fuzzycfs(chroma(i));
    wc_mf(i,:) = fuzzytfs(hue(i));
end

% luminance contrast (light&dark)
lumi_contrast = std(lumi_mf(:,6),area);
% chroma contrast (saturation)
ch_contrast = std(ch_mf(:,4),area);
% hue contrast 
hue_contrast = abs(max(hue)-min(hue))/360;
% complement contrast
com_contrast = min(abs(max(hue)-min(hue)),360-abs(max(hue)-min(hue)));
% warm-cold comtrast
wc_mfvalue = wc_mf(:,4);
max_idx = wc_mfvalue==max(wc_mfvalue);
min_idx = wc_mfvalue==min(wc_mfvalue);
wcmax = fuzzytfs(max(hue(max_idx')));
wcmin = fuzzytfs(min(hue(min_idx')));
max_mfs = wcmax(1:3);
min_mfs = wcmin(1:3);
wc_contrast = sum(max_mfs.*min_mfs)/sqrt(sum(max_mfs.^2)*sum(min_mfs.^2));

% warm cold area
[warmarea,coldarea] = warmcoldarea(f);

contrasts = [lumi_contrast,ch_contrast,hue_contrast,com_contrast,...
    wc_contrast,warmarea,coldarea];




