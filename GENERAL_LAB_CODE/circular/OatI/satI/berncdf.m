function [F]=berncdf(x,p)
%
% CALL: [F]=berncdf(x,p)
%
%
[rx,cx]=size(x);
for j1=1:rx,
for j2=1:cx,
f=0;
for i=0:1,
  if (i<=x(j1,j2)),
    f=f+bern(i,p);
  end
end
F(j1,j2)=f;
end
end
end
