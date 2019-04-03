function [A,r2,n,a]=circaxis(M)
%
% CALL:
%
%   [A,r,n]=circaxis(M)
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., Lund University.

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
if (a<0), a=a+2*pi; end
if (a>pi), a=a-pi; end


