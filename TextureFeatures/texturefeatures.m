function features = texturefeatures(f)
% TEXTUREFEATURES presents all txture features extracted from the original
% RGB image f, including: GLCM features(entropy, energy, homogenity, and
% contrast); LBP text feature (uniform, 59 bins)

% functions involved: cad_glcm_features(4), getmapping and lbp(59)

grayim = rgb2gray(f);
% glcm features
glcm = graycomatrix(grayim);
glcmout = cad_glcm_features(glcm);
entropy = glcmout.entro;
energy = glcmout.energ;
homogeneity = glcmout.homop;
contrast = glcmout.contr;

% LBP features
 mapping = getmapping(8,'u2');
 h = lbp(f,1,8,mapping,'nh');

features = [entropy,energy,homogeneity,contrast,h];


