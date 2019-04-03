function [a,r,N]=circmean(M)
%
% CALL: 
%
%     [A,r,n]=circmean(x)
%     [A,r,n]=s2mean(x)
%
%  where
%         x   = vector of directions (in degrees)
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
a=a*180/pi;
N=n;
end






