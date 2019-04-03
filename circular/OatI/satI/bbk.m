function [r]=bbk(k0,g,n,N)
%
%
k=1;
for i=0:n-k0-1,
  k=k*(N-g-i)/(N-i);
  k=k*(n-i)/(n-k0-i);
end
for i=0:k0-1,
  k=k*(g-i)/(N-n+k0-i);
end
r=k;
end
