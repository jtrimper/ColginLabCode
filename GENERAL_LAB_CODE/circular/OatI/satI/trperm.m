function P=trperm(a,pow)
%
%
if nargin==1, pow=1; end
Z=permut([1:a]);
[pf,pa]=size(Z);
P=0;
for i=1:pf
  Q=permmat(Z(i,:));
  P=P+trace(Q)^pow;
end
%end
