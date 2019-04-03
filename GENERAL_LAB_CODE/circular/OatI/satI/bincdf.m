function [F]=bincdf(x,n,p)
%
% CALL: [F]=bincdf(x,n,p)
%
%
[rx,cx]=size(x);
for j1=1:rx,
for j2=1:cx,
f=0;
for i=0:n,
  if (i<=x(j1,j2)),
    f=f+bin(i,n,p);
  end
end
F(j1,j2)=f;
end
end
%end
