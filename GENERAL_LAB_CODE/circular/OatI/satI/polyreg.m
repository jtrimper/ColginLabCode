function [b,s,p,unc]=polyreg(p,y,x)
%
%
% CALL:
%
%   [b,s,p,unc]=polyreg(p,y,x)
%
%    where 
%
%           p = order of the polynomial,
%           x = vector of values of the regressor,
%           y = vector of values of the response,
%           b = LS estimated coefficients in b(1)+b(2)x+b(3)x^2+...+b(p+1)x^p,
%           s = mean root square error.
%           p = significance levels of parameters = 0           
%         unc = uncertainties of the elements in b
%
[n,c]=size(x);
xp=ones(n,1);
X=xp;
for j=1:p,
  xp=xp.*x;
  X=[X,xp];
end
[b,s,unc]=multreg(y,X);
p=2*(1-tcdf(abs(b/unc),n-p));
end
