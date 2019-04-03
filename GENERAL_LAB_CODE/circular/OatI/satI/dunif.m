function [Pr]=dunif(K,a,b)
%
% CALL: [Pr]=dunif(k,a,b) 
%
[r,c]=size(K);
for i=1:r,
for j=1:c,
h=1;
k=K(i,j);
if ((k>=a)&(k<=b)),
  Pr(i,j)=1/(b-a+1);
else
  Pr(i,j)=0;
end
end
end
end
