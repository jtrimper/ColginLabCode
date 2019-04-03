function [n]=sector(x,e)
%
%  Calculates the number of observations in different sectors
%
% CALL: [n]=sector(x,e);
%
% where
%
%     x  = a vector of directions,
%     e  = a vector of sector directions.
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., University of Lund.
[re ce]=size(e);
[rx,cx]=size(x);
if e(1)>0, e(1)=e(1)-360;
end
d=[e,e(1)+360];
if d(1)>360, d(1)=d(1)-360;
end
for j=1:ce,
  n(j,1)=0;
end
for i=1:rx,
  for j=1:ce,
%    if (x(i,1)>d(j))&(x(i,1)<=d(j+1))
    if (sin(pi*(x(i,1)-d(j))/180)>0)&(sin(pi*(x(i,1)-d(j+1))/180)<=0)
     n(j,1)=n(j,1)+1; 
    end
  end
end
end
