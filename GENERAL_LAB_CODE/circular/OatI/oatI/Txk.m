function [a]=T(x,kappa)
%
%
[rx,cx]=size(x)
a=2*(x*kappa-ones(rx,1)*log(bessel(0,i*kappa)));
%a=2*x*kappa;
end
