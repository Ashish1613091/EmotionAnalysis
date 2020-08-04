clc;
clear all;
close all;


load FinalMatrix;

f=finalmatrix;

wname='db4';
feat=[];
AR_order=4;
T=128;
level=4;

for idx =1:size(f,1)
    x = f(idx,:);
    x = detrend(x,0);                 % Zero-mean data
    arcoefs = blockAR(x,AR_order,T);
    feat = [feat; arcoefs];
end

classLabels=zeros(size(feat,1),1);
classLabels(1:64,:)=1;
classLabels(65:128,:)=2;

rng('default');
cv=cvpartition(size(feat,1),'HoldOut',0.3);
idx=cv.test;

featTrain=feat(~idx,:);
featTest=feat(idx,:);
LabelTrain=classLabels(~idx,:);
LabelTest=classLabels(idx,:);


mdl=svmtrain(featTrain,LabelTrain);
labels=predict(mdl,featTest);

Accuracy=mean(LabelTest==labels)*100;
fprintf('\nAccuracy =%d\n',Accuracy)

Cf = cfmatrix2(LabelTest, labels);


