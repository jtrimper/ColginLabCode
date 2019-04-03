function [Pr]=bin(K,n,p)
%
% CALL: [Pr]=bin(k,n,p) 
%
[r,c]=size(K);
for i=1:r,
for j=1:c,
h=1;
k=K(i,j);
if ((k>=0)&(k<=n)),
  for l=0:k-1,
    h=h*(n-l)*p/(k-l)/(1-p);
  end
  Pr(i,j)=h*(1-p)^n;
else
  Pr(i,j)=0;
end
end
end
%end
