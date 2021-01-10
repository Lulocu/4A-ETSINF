#! /snap/bin/octave -qf
addpath('libreria');
%carga de datos

load ../datos/mnist/train-images-idx3-ubyte.mat.gz
load ../datos/mnist/train-labels-idx1-ubyte.mat.gz
load ../datos/mnist/t10k-images-idx3-ubyte.mat.gz
load ../datos/mnist/t10k-labels-idx1-ubyte.mat.gz


filename = "mnistRes.out";
fid = fopen(filename,"w");
res = svmtrain(xl,X,'-t 1 -d 2');
test = svmpredict(yl,Y,res);
error = sum(test!=yl)/length(yl) * 100;
intervalo=1.96*sqrt((error*(1-error))/length(yl))

fprintf(fid," Error:%.1f \t Intervalo de confianza +-v %.4f\n",error,intervalo);
fclose(fid);