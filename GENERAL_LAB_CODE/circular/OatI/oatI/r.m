function [r,n]=r(x)
%
% CALL: 
%
%     [r]=r(x)
%     [r,n]=r(x)
%
%  where
%          x   = vector of directions (in degrees)
%
% Copyright 1994, Björn Holmquist, Dept of Math. Stat., Lund University.

% 1994-Dec-20
I=find(finite(x));
y=x(I);
Cc=sum(cos(pi*y/180));
Ss=sum(sin(pi*y/180));
n=length(y);
r=sqrt(Cc*Cc+Ss*Ss)/n;
A(1)=Cc/(n*r); A(2)=Ss/(n*r); a=atan2(A(2),A(1));
if (a<0), a=a+2*pi; end
a=a*180/pi;
% end fcn






