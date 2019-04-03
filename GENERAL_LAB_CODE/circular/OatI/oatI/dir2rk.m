function [R,N,A1,A2,A]=dir2rk(x,l)
%
% CALL [R,N,A1,A2,A]=dir2rk(x)
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., University of Lund.
[rm cm]=size(x);
if (nargin<=1),
  l=[0:rm-1]';
end
cl=length(l);
 for k=1:cl,
  Cc=0.0; Ss=0.0; n=0;
  for j=1:rm,
    if (finite(x(j))),
      Cc=Cc+cos(l(k)*pi*x(j)/180.0); Ss=Ss+sin(l(k)*pi*x(j)/180.0);  
      n=n+1;
    end
  end
  N(k)=n;
  R(k)=sqrt(Cc*Cc+Ss*Ss)/n;
  r=R(k);
  A1(k)=Cc/(n*r); A2(k)=Ss/(n*r); a=atan2(A2(k),A1(k));
  if (a<0), a=a+2*pi; end
  A(k)=180*a/pi;
 end
%end fcn
