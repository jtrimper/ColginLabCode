function P=sumperm(a,pow)
%
%
if nargin==1, pow=1; end
Z=permut([1:a]);
[pf,pa]=size(Z);
P=zeros(a^pow,a^pow);
for i=1:pf
  Q=permmat(Z(i,:));
  R=Q;
  for k=2:pow,
    R=kron(R,Q);
  end
  P=P+R;
end
end
