function [a]=I0(x)
%
% [a]=I0(x)

%a=bessel(0,i*abs(x));
a=besseli(0,abs(x));
end
