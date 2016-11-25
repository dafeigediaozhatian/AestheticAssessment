function p = labkmeans(f, nColors)
% LABKMEANS applies K-means on the original RGB image f for image
% segmentation. The image is converted to L*a*b color space and then
% segmented with k=nColors.

cform = makecform('srgb2lab');
lab_f = applycform(f,cform);
ab = double(lab_f(:,:,2:3));

nrows = size(ab,1);
ncols = size(ab,2);

% Initialize means to randomly-selected colors in the original photo.
means = zeros(nColors, 2);
rand_x = ceil(nrows*rand(nColors, 1));
rand_y = ceil(ncols*rand(nColors, 1));
for i = 1:nColors
    means(i,:) = ab(rand_x(i), rand_y(i), :);
end


% array that will store the nearest neighbor for every
% pixel in the image
nearest_mean = zeros(nrows);

% Run k-means
maxiter = 100;
for itr = 1:maxiter
    
    % Stores the means to be calculated in this iteration
    new_means = zeros(size(means));
    
    % num_assigned(n) stores the number of pixels clustered
    % around the nth mean
    num_assigned = zeros(nColors, 1);
    
    % For every pixel in the image, calculate the nearest mean. Then 
    % Update the means.
    for i = 1:nrows
        for j = 1:ncols
            % Calculate the nearest mean for the pixels in the image
            a = ab(i,j,1); b = ab(i,j,2);
            diff = ones(nColors,1)*[a,b] - means;
            distance = sum(diff.^2, 2);
            [val, ind] = min(distance);
            nearest_mean(i,j) = ind;
            
            % Add this pixel to the rgb values of its nearest mean
            new_means(ind, 1) = new_means(ind, 1) + a;
            new_means(ind, 2) = new_means(ind, 2) + b;
            num_assigned(ind) = num_assigned(ind) + 1;
        end
    end
    
    % Calculate new means
    for i = 1:nColors
        % Only update the mean if there are pixels assigned to it
        if (num_assigned(i) > 0)
            new_means(i,:) = new_means(i,:) ./ num_assigned(i);
        end
    end
    
    % Convergence test. Display by how much the means values are changing
    d = sum(sqrt(sum((new_means - means).^2, 2)))
    if d < 1e-5
        break
    end
    
    means = new_means;
end
disp(itr)

means = round(means);

% Recalculate 
p_l = double(lab_f(:,:,1));
p_ab = double(lab_f(:,:,2:3));
for i = 1:nrows
    for j = 1:ncols
        diff = ones(nColors,1)*[a,b] - means;
        distance = sum(diff.^2, 2);
        [val, ind] = min(distance);
        p_ab(i,j,:) = means(ind,:);
    end 
end
p_temp = zeros(size(f));
p_temp(:,:,1) = p_l;
p_temp(:,:,2) = p_ab(:,:,1);
p_temp(:,:,3) = p_ab(:,:,2);

cform = makecform('lab2srgb');
p = applycform(p_temp,cform);

