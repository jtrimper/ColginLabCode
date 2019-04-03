function [p,rho1,rho2,mu1,mu2]=mix2fpom(x,deg);
%
% CALL: [p,rho1,rho2,mu1,mu2]=mix2fpom(x,deg);
%
% Estimation of parameters in the four parameter opposite mode mixing distr
%
if (nargin==2),
  x=pi*x/180;
  disp(' Converting to radians')
end
n=length(x);
a1=cos(x)'*ones(n,1)/n; b1=sin(x)'*ones(n,1)/n; r1=sqrt(a1^2+b1^2);
costh1=a1/r1; sinth1=b1/r1; th1=atan2(sinth1,costh1);
a2=cos(2*x)'*ones(n,1)/n; b2=sin(2*x)'*ones(n,1)/n; r2=sqrt(a2^2+b2^2);
cos2th2=a2/r2; sin2th2=b2/r2; th2=atan2(sin2th2,cos2th2)/2;
a3=cos(3*x)'*ones(n,1)/n; b3=sin(3*x)'*ones(n,1)/n; r3=sqrt(a3^2+b3^2);
cos3th3=a3/r3; sin3th3=b3/r3; th3=atan2(sin3th3,cos3th3)/3; 
A=r1*(costh1*cos(th2)+sinth1*sin(th2));
B=r2;
C=r3*(cos3th3*cos(3*th2)+sin3th3*sin(3*th2));
d0=(A*B-C)/(2*(A*A-B));
d1=(B*B-A*C)/(A*A-B);
rho1=d0+sqrt(d0*d0-d1);
rho2=-d0+sqrt(d0*d0-d1);
p=(A+rho2)/(rho1+rho2);
mu1=th2; mu2=th2+pi;
if (nargin==2),
  mu1=mu1*180/pi;
  mu2=mu2*180/pi;
end
%end fcn 
