function [A,r2,N,c,a]=circac(M,qnt)
%
% CALL:
%
%   [A,r,n,c]=circac(M)
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., University of Lund.

[rows cols]=size(M);
Cc=0.0; Ss=0.0; n=0.0;
for i=1:rows
  if (finite(M(i))),
  Cc=Cc+cos(2.0*pi*M(i)/180.0); Ss=Ss+sin(2.0*pi*M(i)/180.0);  
  n=n+1.0;
  end
end;
r2=sqrt(Cc*Cc+Ss*Ss)/n;
A(1)=Cc/(n*r2); A(2)=Ss/(n*r2); a=atan2(A(2),A(1));
a=a/2.0; A(1)=cos(a); A(2)=sin(a);   
if (a<0), a=a+2*pi;  
end
if (a>pi), a=a-pi;
end
if (nargout>=3), N=n; end
if (nargin<2), qnt=95; end
%chi=(nqnt((1-qnt/100)/2))^2;
%psi=(cos(2*a)*ones(1,n)*cos(2*M*pi/180)+sin(2*a)*ones(1,n)*sin(2*M*pi/180))/n;
%W=n*(1-psi)/(4*n^2*r^2);
%l=nqnt((1-qnt/100)/2);
%c=asin(l*sqrt(2*W)); % Fisher and Lewis
alpha4=(cos(4*a)*ones(1,n)*cos(4*M*pi/180)+sin(4*a)*ones(1,n)*sin(4*M*pi/180))/n;
W=0.5*(1-alpha4)/(n*r2^2);
l=npct((1-qnt/100)/2);
c(1)=0.5*asin(l*sqrt(W)); % Prentice? Holmquist1
alphap4=(ones(1,n)*(cos(M*pi/180-a).^4))/n;
W=(0.5*(1+r2)-alphap4)/(n*r2^2);
l=chi2pct(1-qnt/100,1);
c(2)=asin(sqrt(l*W)); % Prentice
c(3)=0;
l=npct((1-qnt/100)/2);
for v0=a:0.001:a+pi,   % Holmquist2
  f=sqrt(n)*r2*sin(2*(a-v0))/sqrt(0.5*(1-ones(1,n)*cos(4*(M-v0))/n));
  if (f<-l), break, end;
end
c(4)=v0;
for v0=a:-0.001:a-pi,
  f=sqrt(n)*r2*sin(2*(a-v0))/sqrt(0.5*(1-ones(1,n)*cos(4*(M-v0))/n));
  if (f>l), break, end;
end
c(5)=v0;
for v0=a+pi:0.001:a+2*pi,   % Holmquist2
  f=sqrt(n)*r2*sin(2*(a+pi-v0))/sqrt(0.5*(1-ones(1,n)*cos(4*(M-v0))/n));
  if (f>l), break, end;
end
c(6)=v0;
for v0=a+pi:-0.001:a,
  f=sqrt(n)*r2*sin(2*(a+pi-v0))/sqrt(0.5*(1-ones(1,n)*cos(4*(M-v0))/n));
  if (f<-l), break, end;
end
c(7)=v0;
%if (nargin==4)
%c(4)=acos(sqrt(2*n0*(2*n0^2*r0^2-n0*chi)/(4*n0-chi))/n0/r0);
%c(5)=acos(sqrt(n0^2-(n0^2-n0^2*r0^2)*exp(chi/n0))/(n0*r0));
%end
