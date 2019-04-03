function [d]=gauss(x,m,s)
%
% CALL: [d]=gauss(x,m,s) 
%

% 95-01-03
if nargin<3, s=1; end
if nargin<2, m=0; end
d=exp(-0.5*(x-m).^2/s^2)/(s*sqrt(2*pi))
%end fcn
