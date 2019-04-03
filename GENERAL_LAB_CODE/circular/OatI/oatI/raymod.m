function [rhohat,uhat]=raymod(thetax)
%
%
% Modell: x_i=rho*u, i=1,...,k, rho and u unknown
thetax=pi*thetax/180;
  k=length(thetax);
  X=[cos(thetax)';sin(thetax)']; meanx=X*ones(k,1)/k;
  rhohat=sqrt(meanx'*meanx);
  uhat=meanx/rhohat;
end
