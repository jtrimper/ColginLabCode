function [rhohat]=vmodp(thetax,thetaU)
%
%
% Modell: x_i=rho*u, i=1,...,k, rho and u unknown
thetax=pi*thetax/180;
thetaU=pi*thetaU/180;
  k=length(thetax);
  [k,p]=size(thetaU);
  X=[cos(thetax)';sin(thetax)']; 
  for j=1:p,
    U=[cos(thetaU(:,j))';sin(thetaU(:,j))'];
    a(j,1)=trace(X'*U);
  end
  for i=1:p,
    for j=1:p,
      Ui=[cos(thetaU(:,i))';sin(thetaU(:,i))'];
      Uj=[cos(thetaU(:,j))';sin(thetaU(:,j))'];
      B(i,j)=trace(Ui'*Uj);
    end
  end
  rhohat=inv(B)*a;
end
