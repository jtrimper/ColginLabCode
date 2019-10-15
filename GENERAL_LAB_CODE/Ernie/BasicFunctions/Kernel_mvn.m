%WIP: need to figure out 2D kernel estimation

function [pdf]=Kernel_mvn(data)

u = mean(data,1);
covariance = cov(data);
ndimension = size(covariance,1);
delta_x = data-repmat(u,size(data,1),1);
constant = det(covariance)^(-1/2)/(2*pi^(-ndimension/2));
exp_term = -1/2*(delta_x)/(covariance)*(delta_x)';

pdf = constant*exp(exp_term);


%one D gaussian
 yaxis = 2*pi^(-1/2)*exp(-1/2*xaxis.^2);
 
 
 xaxis = (min(min(data)):.1:max(max(data)))';
 ndimension = size(data,2);
 
 pdf=zeros(size(xaxis,1),size(xaxis,1));
 for n=1:size(data,1)
     
     dx1 = xaxis-data(n,1);
     dx2 = xaxis-data(n,2);
     x1gauss = (2*pi)^(-1/2)*exp(-1/2*(dx1(:,1).^2));
     x2gauss = (2*pi)^(-1/2)*exp(-1/2*(dx2(:,1).^2));
     x1x2gauss = x1gauss*x2gauss';
     pdf = pdf+x1x2gauss;
     
 end
 pdf = pdf/size(data,1);