function [u]=randbin(n,p,M,N)
%
% randbin(n,p,M,N)
%
if (nargin<4), N=1; end
if (nargin<3), M=1; end
for j1=1:M,
for j2=1:N,
v=rand;
for k=0:n,
  if ((bincdf(k-1,n,p)<=v)&(v<bincdf(k,n,p))),
    u(j1,j2)=k;
    break;
  end
end
end
end
%end
