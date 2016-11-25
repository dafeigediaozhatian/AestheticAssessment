function fs = fuzzycfs(x)
% FUZZYCFS specifies all functions generate from fuzzy membership. fs is
% the vector containing all the membership values of a certain input x
% saturation centroids [(0),10,27,51,(100)]

c = [10,27,51];
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
elseif x >= c(3)
    out3 = 1;
else
    out3 = (x-c(2))/(c(3)-c(2));
end

% membership funvtion value
mfv = out1*1+out2*2+out3*3;

fs = [out1, out2, out3, mfv];