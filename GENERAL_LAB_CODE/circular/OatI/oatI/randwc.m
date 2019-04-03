function [t]=randwc(k,rho,theta0,ant,deg);
%
% Generates random numbers from the wrapped Cauchy distribution on the circle.
%
% CALL: randwc(k,rho,theta0,size,deg); 
%
% where 
%     k      = modality
%     rho    = concentration parameter, real number [0,1],
%     theta0 = mean direction,
%     size   = sample size,
%     deg    = 'deg' if direction in degrees.
%
% Copyright 1993, Bjorn Holmquist, Dept of Math. Stat., Universty of Lund.
%
if (nargin<=3), ant=1
end
for i=1:ant,
  u=rand(1,1);
  t=floor(u*2.0*p);
  u=u-t/(2*p);
  z=cos(2*pi*u);
  a=1+sqrt(1+4.0*k*k); 
  b=0.5*(a-sqrt(2.0*a))/k;
  c=0.5*(1+b*b)/b;
  d=cos(pi*rand(1,1)); e=(1.0+c*d)/(c+d); d=k*(c-e);
  f=rand(1,1); 
  while (log(d/f)<d-1) %(d*(2/d)<=f)
    a=1+sqrt(1+4.0*k*k); 
    b=0.5*(a-sqrt(2.0*a))/k;
    c=0.5*(1+b*b)/b;
    d=cos(pi*rand(1,1)); e=(1.0+c*d)/(c+d); d=k*(c-e);
    f=rand(1,1); 
  end
%if (d*(2-d)>f) | (log(d/f)>=d-1)
  theta=acos(e);
  if (e<0) 
    theta=theta+0.5*pi;
  end
  if (rand(1,1)<0.5) 
    theta=-theta;
  end
  if (nargin==4)
    if (deg(1:3)=='deg')
      theta=180*theta/pi;
    end
  end
  t(i,1)=theta+theta0;
%end
end


