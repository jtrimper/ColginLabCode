function [Z]=zr(x,r)
%
%
X=[];
p=length(x);
if (r==1),
  Z=x';
else
  for j=1:p,
%  if (j==1),
%    y=[x(j+1:p)];
%  elseif (j==p),
%    y=[x(1:j-1)];
%  else
%    y=[x(1:j-1),x(j+1:p)];
%  end
  y=x;
  X=[X;ones(p^(r-1),1)*x(j),zr(y,r-1)];
end
 Z=X;
end





