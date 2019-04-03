function [A,r,N,c]=circmc(M,qnt,n0,r0)
%
% CALL: 
%
%     [A,r,n,c]=circmc(x,qnt)
%
%  where
%         x   = vector of directions (in degrees)
%         qnt = confidence
%
% Copyright 1993, Bj”rn Holmquist, Dept of Math. Stat., University of Lund.
[rm cm]=size(M);
Cc=0.0; Ss=0.0;  n=0;
for i=1:rm,
  if (finite(M(i))),
    Cc=Cc+cos(pi*M(i)/180.0); Ss=Ss+sin(pi*M(i)/180.0);  
    n=n+1.0;
  end
end;
r=sqrt(Cc*Cc+Ss*Ss)/n;
A(1)=Cc/(n*r); A(2)=Ss/(n*r); a=atan2(A(2),A(1));
if (a<0), a=a+2*pi;
end
if (nargout>=3), N=n; end
chi=(nqnt((1-qnt/100)/2))^2;
c(1)=acos(sqrt(2*n*(2*n^2*r^2-n*chi)/(4*n-chi))/n/r);      %Upton 1
c(2)=acos(sqrt(n^2-(n^2-n^2*r^2)*exp(chi/n))/(n*r));        %Upton 2
psi=(cos(2*a)*ones(1,n)*cos(2*M*pi/180)+sin(2*a)*ones(1,n)*sin(2*M*pi/180))/n;
W=n*(1-psi)/(4*n^2*r^2);
l=nqnt((1-qnt/100)/2);
c(3)=asin(l*sqrt(2*W)); % Fisher and Lewis
for v0=a:0.001:a+2*pi,
  f=sqrt(n)*r*sin(a-v0)/sqrt(0.5*(1-ones(1,n)*cos(2*(M-v0))/n));
  if (f<-l), break, end;
end
c(4)=v0;
for v0=a:-0.001:a-2*pi,
  f=sqrt(n)*r*sin(a-v0)/sqrt(0.5*(1-ones(1,n)*cos(2*(M-v0))/n));
  if (f>l), break, end;
end
c(5)=v0;
%if (nargin==4)
%c(4)=acos(sqrt(2*n0*(2*n0^2*r0^2-n0*chi)/(4*n0-chi))/n0/r0);
%c(5)=acos(sqrt(n0^2-(n0^2-n0^2*r0^2)*exp(chi/n0))/(n0*r0));
%end
%end
