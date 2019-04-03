function [theta,phi,u]=randwatg(kappa,alpha,beta,ant,deg);
%
% Generates random numbers from the Fisher distribution on the sphere.
%
% CALL: randvm(kappa,alpha,beta,size,deg); 
%
% where 
%
%     kappa  = concentration parameter, real number [0,infty),
%     theta0 = mean direction,
%     size   = sample size,
%     deg    = 'deg' if direction in degrees.
%
% Copyright 1993, Bjorn Holmquist, Dept of Math. Stat., Universty of Lund.
%
if (nargin<=3), ant=1
end
for i=1:ant,
  c1=sqrt(abs(kappa)); c2=atan(c1);
  u1=rand; v=rand;
  s=tan(c2*u1);
  while (v>=(1-kappa*s^2)*exp(kappa*s^2)),
    s=tan(c2*u1);
    u1=rand; v=rand;
  end
  theta=s; phi=2*pi*rand;
  if (nargin==5)
    if (deg(1:3)=='deg')
      theta=180*theta/pi;
    end
  end
%  t(i,1)=theta+theta0;
  u(i,1)=sin(theta)*cos(phi);
  u(i,2)=sin(theta)*sin(phi);
  u(i,3)=cos(theta);
end
end
