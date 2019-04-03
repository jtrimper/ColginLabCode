function [m]=medel(M)
%
% Copyright 1993, Bj”rn Holmquist, Dept of Math. Stat., University of Lund.
[rm cm]=size(M);
C=0.0; n=0;
for i=1:rm,
  if (finite(M(i))),
    C=C+M(i); 
    n=n+1.0;
  end
end;
 m=C/n;
end
