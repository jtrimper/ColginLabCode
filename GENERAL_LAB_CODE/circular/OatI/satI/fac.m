function [r]=fac(kk)
%
% CALL: [r]=fac(k)
%
[r,c]=size(kk);
for i=1:r,
  for j=1:c,
    k=kk(i,j);
    if k>=1,
      r(i,j)=prod(1:k);
   %  r=k*fac(k-1);
    else
      r(i,j)=1;
    end
  end
end
%end %function
