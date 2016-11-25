function centroids = fuzzycluster(data)
% FUZZYCLUSTER processes massive images and cluster luminance into 5
% levels and chromaticity into 3 levels. First the image is segmented into 
% 8 regions, and corresponding average lumi, chroma is computed and formed 
% into 2 vectors. The vector contains the raw data to be clustered.

% function involved: labkmeans2, reducecolor, fuzzyl, fuzzyc

% data = imageSet(directory,'recursive');

folder_num = length([data.Count]);
img_count = [data.Count];

imlch = zeros(8,3);
imlumi = zeros(1,sum(img_count)*8);
% imchr = zeros(1,sum(img_count)*8);

for i=1:folder_num
    disp(i)
    for j=1:img_count(i)
        disp(j)
        im = read(data(i),j);
        if size(im,3) ~= 3
            continue
        else
            imsegs = labkmeans2(im,8);
            for m = 1:8
                tempcell = reducecolor(imsegs{m});
                imlch(m,:) = tempcell{1};
            end
            
            disp(imlch(:,1)')
            disp(imlch(:,2)')
            imlumi(8*j-7:8*j) = imlch(:,1)';
            % imchr(8*j-7:8*j) = imlch(:,2)';
        end
    end
end

lumi_centroids = fuzzyl(imlumi);
% chr_centroids = fuzzyc(imchr);

centroids = {lumi_centroids};

            
            
        





