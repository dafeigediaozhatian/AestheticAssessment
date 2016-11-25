function accuracy = svm2(dataHQ,dataLQ)
% SVM2 using Sypport Vector Machine train a Support Vector Machine to
% classify the image into 2 classes. kernal function = RBF

% dataHQ = imageSet('HighQuality','recursive');
% dataLQ = imageSet('LowQuality','recursive');

% animal
% animalHQ = dataHQ(1);
% animalLQ = dataLQ(1);

% random select training set and test set
trnidHQ = randsample(dataHQ.Count,round(dataHQ.Count/2));
tstidHQ = setdiff(1:dataHQ.Count,trnidHQ);
trnidLQ = randsample(dataLQ.Count,length(trnidHQ));
tstidLQ = randsample(setdiff(1:dataLQ.Count,trnidLQ),length(trnidLQ));

% move images to cell
HQcell = cell(1,dataHQ.Count);
LQcell = cell(1,dataLQ.Count);
for i = 1:dataHQ.Count
    HQcell{i} = read(dataHQ,i);
end
for i=1:dataLQ.Count
    LQcell{i} = read(dataLQ,i);
end

% train and test set
% anmHQtrn = anmHQcell{trnidHQ};
HQtrn = cell(1,length(trnidHQ));
for i = 1:length(trnidHQ)
    HQtrn{i} = HQcell{trnidHQ(i)};
end
% anmHQtst = anmHQcell{tstidHQ};
HQtst = cell(1,length(tstidHQ));
for i = 1:length(tstidHQ)
    HQtst{i} = HQcell{tstidHQ(i)};
end
% anmLQtrn = anmLQcell{trnidLQ};
LQtrn = cell(1,length(trnidLQ));
for i = 1:length(trnidLQ)
    LQtrn{i} = LQcell{trnidLQ(i)};
end
%anmLQtst = anmLQcell{tstidLQ};
LQtst = cell(1,length(tstidLQ));
for i = 1:length(tstidLQ)
    LQtst{i} = LQcell{tstidLQ(i)};
end

trndt = [HQtrn,LQtrn];

% labels
trnlabel = double([ones(length(HQtrn),1);-ones(length(LQtrn),1)]);
% trnlabel = double([ones(length(trn_cfs)/2,1);-ones(length(trn_cfs)/2,1)]);

% extract features
% separately????????
trn_cfs = zeros(length(trndt),117);
HQtst_cfs = zeros(length(HQtst),117);
LQtst_cfs = zeros(length(LQtst),117);
for i=1:length(trndt)
    disp(i)
    if size(trndt{i},3) ~= 3
        continue
    end
    trn_cfs(i,1:28) = colorfeatures(trndt{i});
    trn_cfs(i,29:91) = texturefeatures(trndt{i});
    trn_cfs(i,92:end) = spatialarrangefeatures(trndt{i});
end

%HQ test
for i=1:length(HQtst)
    disp(i)
    if size(HQtst{i},3)~=3
        continue
    end
    HQtst_cfs(i,1:28) = colorfeatures(HQtst{i});
    HQtst_cfs(i,29:91) = texturefeatures(HQtst{i});
    HQtst_cfs(i,92:end) = spatialarrangefeatures(HQtst{i});
end
% LQ test
for i=1:length(LQtst)
    disp(i)
    if size(LQtst{i},3)~=3
        continue
    end
    LQtst_cfs(i,1:28) = colorfeatures(LQtst{i});
    LQtst_cfs(i,29:91) = texturefeatures(LQtst{i});
    LQtst_cfs(i,92:end) = spatialarrangefeatures(LQtst{i});
end


% SVM RBF 
% select parameter for RBF kernel
folds = 5;
[C,gamma] = meshgrid(-5:2:15, -15:2:3);
% grid search and cross-validation
cv_acc = zeros(numel(C),1);
for i=1:numel(C)
    cv_acc(i) = svmtrain(trnlabel, sparse(trn_cfs), ...
        sprintf('-c %f -g %f -v %d -h 0 -m 1000', 2^C(i), 2^gamma(i), folds));
end
% select (C,gamma) with best accuracy
[~,idx] = max(cv_acc);
best_C = 2^C(idx);
best_gamma = 2^gamma(idx);

% svm train data
model = svmtrain(trnlabel,trn_cfs,sprintf('-t 2 -g %f -c %f',best_gamma,best_C));
[labelHQ,accuHQ,~] = svmpredict(ones(length(HQtst_cfs),1),HQtst_cfs,model);
[labelLQ,accuLQ,~] = svmpredict(-ones(length(LQtst_cfs),1),LQtst_cfs,model);

accuHQ = accuHQ(1);
accuLQ = accuLQ(1);

accuracy = (accuHQ+accuLQ)/2


% SVM linear
model = svmtrain(trnlabel,trn_cfs,'-t 0');
[labelHQ,accuHQ,~] = svmpredict(ones(length(HQtst_cfs),1),HQtst_cfs,model);
[labelLQ,accuLQ,~] = svmpredict(-ones(length(LQtst_cfs),1),LQtst_cfs,model);

accuHQ = accuHQ(1);
accuLQ = accuLQ(1);

accuracy = (accuHQ+accuLQ)/2
