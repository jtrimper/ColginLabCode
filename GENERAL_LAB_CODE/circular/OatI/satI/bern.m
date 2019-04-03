function [Pr]=bern(K,p)
%
% CALL: [Pr]=bern(k,p) 
%
[r,c]=size(K);
for i=1:r,
for j=1:c,
h=1;
k=K(i,j);
if ((k>=0)&(k<=1)),
  for l=0:k-1,
    h=h*(1-l)*p/(k-l)/(1-p);
  end
  Pr(i,j)=h*(1-p);
else
  Pr(i,j)=0;
end
end
end
end
