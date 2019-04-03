function [rhohat]=vmod(thetax,thetau)
%
%
% Modell: x_i=rho*u_i, i=1,...,k
thetax=pi*thetax/180;
thetau=pi*thetau/180;
  k=length(thetax);
  X=[cos(thetax)';sin(thetax)']; onek=ones(k,1);
  U=[cos(thetau)';sin(thetau)']; %P=eye(k)-onek*onek'/k;
  rhohat=trace(X'*U)/trace(U'*U);
end
