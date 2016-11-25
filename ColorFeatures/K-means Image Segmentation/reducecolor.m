function p = reducecolor(p1)
% REDUCECOLOR replace the original color with the average Lch value
% f is the original RGB image, p is a cell including: the average luminance, 
% chroma, hue (L*c*h), the colored area and the color-reduced image.

nrows = size(p1,1);
ncols = size(p1,2);

%p1d = double(p1);
p1lch = colorspace('->lch',p1);
% calculate colored area (area not black)
p1lchr = reshape(p1lch,nrows*ncols,3);
a = 0;
for i = 1:nrows*ncols
    if all(p1lchr(i,:) ~= 0)
        a = a+1;
    end
end

% average luminance
l1 = sum(p1lchr(:,1))/a;

% average chroma
c1 = sum(p1lchr(:,2))/a;

% average hue
h1 = sum(p1lchr(:,3))/a;

% replace color
for i = 1:nrows*ncols
    if all(p1lchr(i,:) ~= 0)
        p1lchr(i,:) = [l1,c1,h1];
    end
end

newp = reshape(p1lchr,[nrows,ncols,3]);
newp1 = colorspace('lch->rgb',newp);
p = {[l1, c1, h1], a, newp1};