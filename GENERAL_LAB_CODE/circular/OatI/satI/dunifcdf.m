function [F]=dunifcdf(x,a,b)
%
% CALL: [F]=dunifcdf(x,a,b)
%
%
[rx,cx]=size(x);
for j1=1:rx,
for j2=1:cx,
f=0;
for i=a:b,
  if (i<=x(j1,j2)),
    f=f+dunif(i,a,b);
  end
end
F(j1,j2)=f;
end
end
end
