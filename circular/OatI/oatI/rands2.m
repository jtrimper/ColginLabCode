function [u]=rands2(N)
%
%
%
if (nargin<1), N=1; end
for j=1:N,
  n=randn(1,2);
  u(j,:)=n/sqrt(n*n');
end
end
