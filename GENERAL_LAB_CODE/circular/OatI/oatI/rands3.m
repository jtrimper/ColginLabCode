function [u]=rands3(N)
%
%
%
if (nargin<1), N=1; end
for j=1:N,
  n=randn(1,3);
  u(j,:)=n/sqrt(n*n');
end
end
