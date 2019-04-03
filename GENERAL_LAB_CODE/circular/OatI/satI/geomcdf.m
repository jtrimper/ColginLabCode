function [F]=geomcdf(x,p)
%
% CALL: [F]=geomcdf(x,p)
%
%
[rx,cx]=size(x);
for j1=1:rx,
for j2=1:cx,
f=0;
for i=0:x(j1,j2),
  f=f+geom(i,p);
end
F(j1,j2)=f;
end
end
end
