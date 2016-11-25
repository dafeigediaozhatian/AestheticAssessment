function features = spatialarrangefeatures(f)
% SPATIALARRANGEFEATURES presents all spatial arrangement features of the
% original RGB image f. Including Symmetry and the average saliency value
% for each third subregion.

% functions involved: symmetry(1), saliencyValue(36)

symm = symmetry2(f);
saliency = avgsaliency(f,5);

features = [symm,saliency];