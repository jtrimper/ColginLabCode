function [d]=lognorm(x,lambda,xi)
%
% CALL: [d]=lognorm(x,lambda,xi) 
%
  [r,c]=size(x);
  for i=1:r,
    for j=1:c,
      x0=x(i,j);
      d(i,j)=exp(-0.5*(log(x0)-lambda)^2/xi^2)/(x0*xi*sqrt(2*pi));
    end
  end
end
