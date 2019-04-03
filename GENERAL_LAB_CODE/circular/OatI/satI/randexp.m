function [u]=randexp(m,M,N)
%
% CALL: u=randexp(m)
%       u=randexp(m,M)
%       u=randexp(m,M,N)
%
if (nargin<3), N=1; end
if (nargin<2), M=1; end
for j1=1:M,
for j2=1:N,
  u(j1,j2)=-m*log(rand);
end
end
end
