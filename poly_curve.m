clear
close
clc

[data,~] = xlsread('result_sub_datasets.xlsx');

x = [3 6 9 12 15 18.4];
y1 = mean(reshape(data(1,:),3,5));
y2 = mean(reshape(data(4,:),3,5));
y1 = [y1,3630];
y2 = [y2,5327];
p1 = polyfit(log(x),log(y1),2); %correspond to two
p2 = polyfit(log(x),log(y2),2); %correspond to total

eval1 = [18.4  3630];
eval2 = [18.4  5327];

x_test = log(linspace(1,45));
y1_test = polyval(p1,x_test);
y2_test = polyval(p2,x_test);
figure
plot(x*10000,y1,'o')
hold on
plot(x*10000,y2,'x')
hold on
plot(exp(x_test)*10000,exp(y1_test))
hold on
plot(exp(x_test)*10000,exp(y2_test))
hold off
xlabel('Number of Consensus Sequences');
ylabel('Number of Genes');


