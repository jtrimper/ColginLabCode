function [m]=md(M)
%
% Copyright 1993, Bj”rn Holmquist, Dept of Math. Stat., University of Lund.
[rm cm]=size(M);
j=0;
for i=1:rm,
  if (finite(M(i))),
    j=j+1;
    Y(j)=M(i); 
  end
end;
 m=median(Y);
end
