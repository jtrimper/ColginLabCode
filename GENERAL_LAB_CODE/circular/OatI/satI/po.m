function [Pr]=po(K,m)
%
% CALL: [Pr]=po(k,m) 
%
[r,c]=size(K);
for i=1:r,
for j=1:c,
h=1;
k=K(i,j);
if (k>=0),
  for l=0:k-1,
    h=h*m/(l+1);
  end
  Pr(i,j)=exp(-m)*h;
else
  Pr(i,j)=0;
end
end
end
%end
