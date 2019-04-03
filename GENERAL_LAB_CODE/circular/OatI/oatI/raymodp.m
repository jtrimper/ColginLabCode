function [rhohat,U]=raymodp(thetax,D)
%
%
% Modell: x_i=rho*u, i=1,...,k, rho and u unknown
thetax=pi*thetax/180;
%thetaU=pi*thetaU/180;
  k=length(thetax);
  [k,p]=size(D);
  X=[cos(thetax)';sin(thetax)'];
  s(1)=0;
  for j=1:p,
    c=D(:,j);
    c=classify(c,valuesof(c),'equal');
    vc=valuesof(c);
    s(j+1)=length(vc)+s(j);
    L1=zeros(length(vc),k);
    for i=1:k,
      L1(c(i),i)=1;
    end
    L=[L;L1]
  end
  L*L'
  Vtr=pinv(L*L')*(L*X'); V=Vtr';
  for j=1:s(p+1);
    vj(j)=sqrt(V(:,j)'*V(:,j));
  end
  U=V*inv(diag(vj));
  for j=1:p,
    Lj=L([s(j)+1:s(j+1)],:);
    Uj=U(:,[s(j)+1:s(j+1)]);
    a(j,1)=trace(X'*Uj*Lj);
  end
  for i=1:p,
    for j=1:p,
      Lj=L([s(j)+1:s(j+1)],:);
      Uj=U(:,[s(j)+1:s(j+1)]);
      Li=L([s(i)+1:s(i+1)],:);
      Ui=U(:,[s(i)+1:s(i+1)]);
      B(i,j)=trace(Li'*Ui'*Uj*Lj);
    end
  end
  rhohat=inv(B)*a;
end




