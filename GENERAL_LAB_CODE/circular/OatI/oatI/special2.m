function [rho1,rho2,p,theta1,theta2,theta3,A,B,C,mu1,mu2,rho0]=special2(x,rho)
%
%
%
%
n=length(x);
ettn=ones(n,1);
a1=ettn'*cos(x)/n; b1=ettn'*sin(x)/n;
r1=sqrt(a1*a1+b1*b1)
theta1=atan2(b1,a1);
a2=ettn'*cos(2*x)/n; b2=ettn'*sin(2*x)/n;
r2=sqrt(a2*a2+b2*b2)
theta2=atan2(b2,a2)/2.0;
a3=ettn'*cos(3*x)/n; b3=ettn'*sin(3*x)/n;
r3=sqrt(a3*a3+b3*b3);
theta3=atan2(b3,a3)/3.0;
%gamma1=theta2; gamma2=theta2; gamma3=theta2;
%mu1=theta2;
mu1=0;
gamma1=mu1; gamma2=mu1; gamma3=mu1;
A=r1*cos(theta1-gamma1)/cos(mu1-gamma1);
B=r2*cos(2*(theta2-gamma2))/cos(2*(mu1-gamma2));
C=r3*cos(3*(theta3-gamma3))/cos(3*(mu1-gamma3));
theta=(A*B-C)/(A*A-B);
Gamma=(B*B-A*C)/(A*A-B);
rho1=theta/2+sqrt(theta*theta/4-Gamma);
rho2=-theta/2+sqrt(theta*theta/4-Gamma);
p=(A+rho2)/(rho1+rho2);
gamma1=3*pi/4; gamma2=gamma1;
A=r1*cos(2*(theta2-gamma1));
B=r2*cos(2*(theta2-gamma2));
asq=(4*A*A+rho*rho-B)/(4*rho*rho)+sqrt(((4*A*A+rho*rho-B)/(4*rho*rho))^2-A^2/rho^2)
a=sqrt(asq)
b=A/(a*rho)
mu1=acos(a)+acos(b)+gamma1;
mu2=mu1-2*acos(b);
mu1=mu1*180/pi; mu2=mu2*180/pi;
theta1=theta1*180/pi; theta2=theta2*180/pi; theta3=theta3*180/pi;
%%
%
if (r1^2>r2/2),
  rho0=sqrt(2*r1^2-r2)
else
  rho0=sqrt(2*r1^2+r2)
end
  delta=acos(r1/rho0)*180/pi
barmu=theta2+90
mu1=barmu-delta
mu2=barmu+delta
end;

