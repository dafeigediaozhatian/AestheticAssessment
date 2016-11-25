function H = getHist(magnitudes,angles,numBins)
% GETHIST generate the histogram for gradient vectors. The angles are
% diveided into numBins bins, the value of each bin is the sum of the
% magnitudes inside of the vectors in that bin. Angles are in radius,
% ranging from -pi~pi. Each gradient vector's magnitude is split between
% the two nearest bins.

H = zeros(1,numBins);
binSize = pi/numBins;
% angles are unsigned, meaning ranging from 0~pi
angles(angles<0) = angles(angles<0)+pi;

binIdx_l = floor(angles/binSize);
binIdx_r = binIdx_l+1;
binIdx_l(binIdx_l==0) = numBins;
binIdx_r(binIdx_r==(numBins+1)) = 1;
binCenter_l = (binIdx_l-0.5)*binSize;

weight_r = (angles-binCenter_l)/binSize;
weight_l = 1-weight_r;

for i=1:numBins
    pixels = (binIdx_l==i);
    H(1,i) = sum(magnitudes(pixels).*weight_l(pixels));
    pixels = (binIdx_r==i);
    H(1,i) = H(1,i)+sum(magnitudes(pixels).*weight_r(pixels));
end


