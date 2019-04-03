function [u]=randgeom(p,M,N)
%
% CALL x=randgeom(p)
%      x=randgeom(p,M)
%      x=randgeom(p,M,N)
%
if (nargin<3), N=1; end
if (nargin<2), M=1; end
for j1=1:M,
for j2=1:N,
v=rand;
for k=0:(1-p)*10/p,
  if ((geomcdf(k-1,p)<=v)&(v<geomcdf(k,p))),
    u(j1,j2)=k;
    break;
  end
end
end
end
end
