function [r]=permut(x,i)
%
% CALL: permut(x)
%
%       Enumerate all permutations of the elements of x
%
X=[];
k=length(x);
if (k==2),
  r=[x(1),x(2);x(2),x(1)];
else
 for j=1:k,
  if (j==1),
    y=[x(j+1:k)];
  elseif (j==k),
    y=[x(1:j-1)];
  else
    y=[x(1:j-1),x(j+1:k)];
  end
  X=[X;ones(fac(k-1),1)*x(j),permut(y)];
 end
r=X;
if nargin==2, r=X(i,:); end
end 




