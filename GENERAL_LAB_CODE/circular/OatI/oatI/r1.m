function [R,N]=r1(Y)
%
% CALL: 
%
%     r1(y)
%     [r]=r1(y)
%     [r,n]=r1(y)
%
%  where
%          y   = vector of directions (in degrees)
%          r   = mean vector length
%          n   = number of directions

% Copyright 1994, Björn Holmquist, Dept of Math. Stat., Lund University.
% 1994-Dec-20
[A,B]=size(Y); R=[]; N=[];
for j=1:B,
  x=Y(:,j);
  y=x(find(finite(x)));
  Cc=sum(cos(pi*y/180));
  Ss=sum(sin(pi*y/180));
  n=length(y);
  r=sqrt(Cc*Cc+Ss*Ss)/n;
  R=[R,r];
  N=[N,n];
end
%end fcn






