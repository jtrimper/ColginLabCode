function [r]=bb(g,n,N)
%
%
k=1;
for i=0:n-1,
  k=k*(N-g-i)/(N-i);
end
r=k;
end
