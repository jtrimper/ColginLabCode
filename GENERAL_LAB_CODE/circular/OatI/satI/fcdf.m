function [F]=fcdf(x,nu1,nu2)
%
% CALL: fcdf(x,nu1,nu2)
%
y=nu2/(nu2+nu1*x);
F=1-betainc(y,nu2/2,nu1/2);
%end
