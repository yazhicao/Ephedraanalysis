clear;
close;
clc
[filedata0,~] = xlsread('kaks_results.xlsx','');
filedata0 = filedata0(filedata0>0.001);

figure;
plot(x0,(phi0*y0)/sum(phi0*y0));

axis([0 0.15 0 0.08]);
legend(['Es-P--equ (order: ',num2str(order0),')']);
       






