function [m]=mmean(x,t)
%
% CALL:
%    
%   [m]=mmean(x,t)
%
% Copyright 1993, Bj”rn Holmquist, Dept of Math. Stat., University of Lund.
[rm cm]=size(x);
if cm>rm, x=x'; end
[rm cm]=size(x);
[rt,ct]=size(t);
for j1=1:rt,
for j2=1:ct,
t0=t(j1,j2); 
if (t0~=0), 
  C=0.0; 
else 
  C=1.0; 
end 
n=0;
for i=1:rm,
  if (finite(x(i))),
    if x(i)<0, break; end
    if (t0~=0), 
      C=C+x(i)^t0; 
    else C=C*x(i);
    end
    n=n+1.0;
  end
end;
 if (t0~=0), m(j1,j2)=(C/n)^(1/t0);
 else m(j1,j2)=C^(1/n);
 end
end
end
end
