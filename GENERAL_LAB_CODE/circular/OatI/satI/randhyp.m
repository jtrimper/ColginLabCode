function [u]=randhyp(g,n,N,M,N0)
%
%
%
if (nargin<5), N0=1; end
if (nargin<4), M=1; end
for j1=1:M,
for j2=1:N0,
v=rand;
for k=0:n,
  if ((hypcdf(k-1,g,n,N)<=v)&(v<hypcdf(k,g,n,N))),
    u(j1,j2)=k;
  break;
  end
end
end
end
end
