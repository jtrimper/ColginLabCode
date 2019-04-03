function [F]=nctcdf(t,nu,delta)
%
% CALL: nctcdf(t,nu,delta)
%
x=(t*(1-1/(4*nu))-delta)/sqrt(1+t.^2/(2*nu));
F=ncdf(x);
end
