function [rhohat,betahat]=pcdmod(thetax,thetau)
%
%
% Modell: x_i=rho*u_i+beta, i=1,...,k
thetax=pi*thetax/180;
thetau=pi*thetau/180;
  k=length(thetax);
  X=[cos(thetax)';sin(thetax)']; onek=ones(k,1);
  U=[cos(thetau)';sin(thetau)']; P=eye(k)-onek*onek'/k;
  if (trace(U'*U*P)==0),
    disp(' Singular design: PCD not estimable.')
  else
    trace(U'*U*P)
    rhohat=trace(X'*U*P)/trace(U'*U*P);
    betahat=(X*onek-rhohat*U*onek)/k;
  end
%end fcn
