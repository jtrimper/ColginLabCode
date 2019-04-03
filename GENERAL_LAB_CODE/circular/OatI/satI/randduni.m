function [u]=randduni(a,b,M,N)
%
%
%
if (nargin<4), N=1; end
if (nargin<3), M=1; end
for j1=1:M,
for j2=1:N,
v=rand;
for k=a:b,
  if ((dunifcdf(k-1,a,b)<=v)&(v<dunifcdf(k,a,b))),
    u(j1,j2)=k;
    break;
  end
end
end
end
end
