clc
clear
a(1:30,1)=1;
a(31:60,1)=2;
a(61:90,1)=3;
a(91:120,1)=0;
data4=xlsread('Training data2.xlsx',4);
data=xlsread('Training data2.xlsx',1);
data2=xlsread('Training data2.xlsx',2);
data3=xlsread('Training data2.xlsx',3);
TraininS(1:30,1:10)=data(:,1:10)
TraininS(31:60,1:10)=data2(:,1:10)
TraininS(61:90,1:10)=data3(:,1:10)
TraininS(91:120,1:10)=data4(:,1:10)
% 
% data1=xlsread('Training data2.xlsx',1);
% data2=xlsread('Training data2.xlsx',2);
% data3=xlsread('Training data2.xlsx',3);
% data4=xlsread('Training data2.xlsx',4);
% TraininS(1:30,1:4)=data1(:,5:8)
% TraininS(31:60,1:4)=data2(:,5:8)
% TraininS(61:90,1:4)=data3(:,5:8)
% TraininS(91:120,1:4)=data4(:,5:8)
u=unique(a);
numClasses=length(u);
%result = zeros(length(TestSet(:,1)),1);
%build models
for k=1:numClasses
%Vectorized statement that binarizes Group
%where 1 is the current class and 0 is all other classes
G1vAll=(a==u(k));
models(k) = svmtrain(TraininS,G1vAll);
end

save('D:\Fall Detection\traingS-linear2.mat')