function [f]=bbtillf(g,n,N,p)
%
%
s=0;
for i=0:g,
  s=s+hyp(i,g,n,N)*(1-p)^i;
end
f=s;
end
