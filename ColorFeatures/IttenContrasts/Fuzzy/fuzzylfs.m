function fs = fuzzylfs(x)
% FUZZYLFS specifies all functions generate from fuzzy membership. fs is
% the vector containing all the membership values of a certain input x
% luminance centroids [(0),21,39,55,68,84,(100)]

c = [21,39,55,68,84];

% function 1
if x <= c(1)
    out1 = 1;
elseif x >= c(2)
    out1 = 0;
else
    out1 = (c(2)-x)/(c(2)-c(1));
end

% function 2
if x <= c(1)
    out2 = 0;
elseif x >= c(3)
    out2 = 0;
elseif x>c(1) && x<=c(2)
    out2 = (x-c(1))/(c(2)-c(1));
else
    out2 = (c(3)-x)/(c(3)-c(2));
end

% function 3
if x <= c(2)
    out3 = 0;
elseif x >= c(4)
    out3 = 0;
elseif x>c(2) && x <=c(3)
    out3 = (x-c(2))/(c(3)-c(2));
else
    out3 = (c(4)-x)/(c(4)-c(3));
end

% function 4
if x <= c(3)
    out4 = 0;
elseif x >= c(5)
    out4 = 0;
elseif x>c(3) && x<=c(4)
    out4 = (x-c(3))/(c(4)-c(3));
else
    out4 = (c(5)-x)/(c(5)-c(4));
end

% function 5
if x <= c(4)
    out5 = 0;
elseif x >= c(5)
    out5 = 1;
else
    out5 = (x-c(4))/(c(5)-c(4));
end

% membership function value
mfv = out1*1+out2*2+out3*3+out4*4+out5*5;

fs = [out1, out2, out3, out4, out5, mfv];