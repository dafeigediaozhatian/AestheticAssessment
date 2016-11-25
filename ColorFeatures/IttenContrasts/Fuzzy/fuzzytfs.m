function fs = fuzzytfs(x)
% FUZZYTFS specifies all functions generate from fuzzy membership. fs is
% the vector containing all the membership values of a certain input x

% warm function
if x>=0 && x<140
    out1 = cos(degtorad(x-50));
elseif x>=320 && x<=360
    out1 = cos(degtorad(x-50));
else
    out1 = 0;
end

% cold function
if x>=140 && x<320
    out2 = cos(degtorad(x-230));
else
    out2 = 0;
end

% neutral function
out3 = 1-(out1+out2);

% membership function value
mfv = 1*out2+2*out3+3*out1;

fs = [out2, out3, out1, mfv];