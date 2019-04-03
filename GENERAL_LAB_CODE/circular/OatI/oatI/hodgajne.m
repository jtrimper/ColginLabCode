function [Nmax,P,Pa]=hodgajne(x);
%
% CALL: [Nmax,P]=hodgajne(x)
%
% where       x = vector of directions in (degrees)
%
Nmax=0;
n=length(x);
x=pi*x/180;
%[N(x,x),N(x,x+pi)];
Nmax=max([N(x,x),N(x,x+pi)]);

%for j=1:n
% if N(x,x(j))>Nmax,
%   Nmax=N(x,x(j));
% end
% if N(x,x(j)+180)>Nmax,
%   Nmax=N(x,x(j)+pi);
% end
%end

% calculating probability
k=Nmax; s=0;
for j=0:(n-k)/(2*k-n),
  s=s+binom(n,j*(2*k-n)+k);
end
%P(N ge k)
P=s*(2*k-n)*2^(1-n);
% asymptotic distribution
s=0;
c=(2*k-n)/sqrt(n);
for j=0:10,
  s=s+exp(-(2*j+1)^2*c^2/2);
end
Pa=c*s*sqrt(2/pi);
%end fcn




