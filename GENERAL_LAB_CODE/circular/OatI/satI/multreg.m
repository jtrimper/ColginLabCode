function [b,s,berr,n,p,R2]=multreg(y0,X0)
%
%
% CALL:
%
%   [b,s,berr]=multreg(y,X)
%   [b,s,berr,n,p,R2]=multreg(y,X)
%
%   where 
%         X = n by p matrix of p regressors
%         y = n by 1 vector of responses
%         b = LS estimated parameters
%         s = root mean square error
%         berr = uncertainties of the elements in b
%
[n,p]=size(X0);
%j=0;
%[I,J]=find(~finite([y0,X0]));
II=find(finite([y0]));
%II=exclude([1:n],I')';
y=y0(II); X=X0(II,:); [n,p]=size(X);
b=X\y;
Cinv=inv(X'*X);
%b=Cinv*(X'*y);
d=y-X*b;
s=sqrt(d'*d/(n-p));
%y-mean(y)
%d
%y-mean(y)
%d'*d
%(y-mean(y))'*(y-mean(y))
a=(d'*d)/((y-mean(y))'*(y-mean(y)));
%R2=1-a;
R2=1-(d'*d)/((y-mean(y))'*(y-mean(y)));
berr=s*sqrt(diag(Cinv));
%unc=[-1,-1];
%end fcn

