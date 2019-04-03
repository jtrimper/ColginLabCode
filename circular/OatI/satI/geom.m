function [Pr]=geom(K,p)
%
% CALL: [Pr]=geom(k,p) 
%
[r,c]=size(K);
q=1-p;
for i=1:r,
for j=1:c,
k=K(i,j);
if (k>=0),
  Pr(i,j)=p*q^k;
else
  Pr(i,j)=0;
end
end
end
end






