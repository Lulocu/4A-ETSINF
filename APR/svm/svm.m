#! /snap/bin/octave -qf
addpath() %a donde toque
load ../datos/mini/trSep.dat
load ../datos/mini/trSeplabels.dat
res = svmtrain(xl,X,'-t 0 -c 1000')
%vector de peso
theta = res.sv_coef' * res.SVs
%peso umbral
theta0= sign(res.sv_coef(1)) - theta * res.SVs(1,:)'
%Frontera separación
x1 = [0:7]
x2 = -theta(1)/theta(2)*x1 - theta0/theta(2)


plot(X(xl==1,1),X(xl==1,2),"sr",X(xl==2,1),X(xl==2,2),"ob",x1,x2,"-k")


