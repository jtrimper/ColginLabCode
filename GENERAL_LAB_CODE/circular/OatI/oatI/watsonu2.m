function [U2]=watsonu2(x,y)
%
% CALL: [U2]=watsonu2(x,y)
%
z=sort([x',y']');
d=ecdf(z,y)-ecdf(z,x);
n=length(d);
dm=mean(d);
U=(d'*d-n*dm^2)/(n^2);
U2=length(x)*length(y)*U;
%end
