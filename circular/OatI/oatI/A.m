function [a]=A(kappa)
%
%  [a]=A(kappa)

%a=-i*bessel(1,i*kappa)./bessel(0,i*kappa);
a=I1(kappa)./I0(kappa);
%end
