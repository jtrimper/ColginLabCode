function [t]=randvmam(k,theta0,ant,deg);
%
% Generates random numbers from the von Mises distribution on the circle.
%
% CALL: randvmam(kappa,theta0,size,deg); 
%
% where 
%
%     kappa  = concentration parameter, real number [0,infty),
%     theta0 = mean direction,
%     size   = sample size,
%     deg    = 'deg' if direction in degrees.
%
% Copyright 1993, Bjorn Holmquist, Dept of Math. Stat., Universty of Lund
if (nargin<=2), ant=1
end
for i=1:ant,
  p=rand;
  if (p<0.5)
    t(i,1)=randvm(k,theta0,1,deg);
  else
    if (deg(1:3)=='deg'), 
      t(i,1)=randvm(k,theta0+180,1,deg);
    else
      t(i,1)=randvm(k,theta0+pi,1,deg);
    end 
  end
end
