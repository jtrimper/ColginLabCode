function [a]=T(x)
%
%
%[rx,cx]=size(x);
%a=2*(abs(x).*Ainv(x)-log(I0(Ainv(x))));
k=Ainv(abs(x));
a=2.0*(x.*k-log(I0(k)));
end
