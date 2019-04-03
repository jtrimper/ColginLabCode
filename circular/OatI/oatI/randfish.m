function [theta,phi,u]=randfish(kappa,alpha,beta,ant,deg);
%
% Generates random numbers from the Fisher distribution on the sphere.
%
% CALL: randfish(kappa,alpha,beta,size,deg); 
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
  lambda=exp(-2*kappa);
  theta=2*asin(sqrt(-log(rand*(1-lambda)+lambda)/(2*kappa)));
  phi=2*pi*rand;
  if (nargin==5)
    if (deg(1:3)=='deg')
      theta=180*theta/pi;
    end
  end
%  t(i,1)=theta+theta0;
  u(i,1)=sin(theta)*cos(phi);
  u(i,2)=sin(theta)*sin(phi);
  u(i,3)=cos(theta);
  th0=alpha; ph0=beta;
  A=[cos(th0)*cos(ph0);-sin(ph0);sin(th0)*cos(ph0)];
  A=[A,[cos(th0)*sin(ph0);cos(ph0);sin(th0)*sin(ph0)]];
  A=[A,[-sin(th0);0;cos(th0)]];
  u(i,:)=u(i,:)*A';
end
end
