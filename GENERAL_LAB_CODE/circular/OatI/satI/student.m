function [d]=student(x,nu,m)
%
% CALL: [d]=student(x,nu,m) 
%
  [r,c]=size(x);
  if (nargin<3), m=0; end
  for i=1:r,
    for j=1:c,
      x0=x(i,j);
      d(i,j)=gamma((nu+1)/2)*(1+(x0-m)^2/nu)^(-(nu+1)/2)/gamma(nu/2)/sqrt(pi*nu);
    end
  end
end
