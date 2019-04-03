function [noo]=N(x,theta0)
%
% CALL  [n]=N(x,theta0)
%
%  where
%
%     n  = number of observations in x in the half circle (theta0-pi,theta0]
%          theta0 given in radians.
%     x  = directions (i radians).
%
n=length(x); noo=[];
nth=length(theta0);
for j=1:nth,
 no=0;
 for k=1:n,
  if cos(x(k)-theta0(j)+pi/2)>0,
    no=no+1;
  end
  if x(k)==theta0(j),
 %    no=no+1;
  end
 end
 noo=[noo,no];
end
end
