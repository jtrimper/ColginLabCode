function [a,b,s,p,unc]=linreg(y0,x0)
%
%
% CALL:
%
%   [a,b,s,p,unc]=linreg(y,x)
%
%    where 
% 
%           x = vector of values of the regressor
%           y = vector of values of the response
%           a = LS estimated intercept
%           b = LS estimated slope
%           s = mean root square error.
%           p = significance levels of parameters = 0           
%         unc = uncertainties of a and b
%
[n,p]=size(x0);
j=0;
for k=1:n,
  if (finite(x0(k))&finite(y0(k))),
    j=j+1;
    x(j,1)=x0(k);
    y(j,1)=y0(k);
  end
end
[n,p]=size(x);
X=[ones(n,1),x];
[c,s,unc]=multreg(y,X);
a=c(1); b=c(2);
p(1)=2*(1-tcdf(abs(a/unc(1)),n-2));
p(2)=2*(1-tcdf(abs(b/unc(2)),n-2));
%end fcn
