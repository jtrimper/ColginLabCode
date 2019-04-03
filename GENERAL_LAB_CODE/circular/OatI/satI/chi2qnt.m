function [cp]=chi2qnt(p,nu);
%
%
xp=nqnt(p);
%g1=(xp^3+xp)/4.0;
%g2=(5.0*xp^5+16.0*xp^3+3.0*xp)/96;
%g3=(3*xp^7+19*xp^5+17*xp^3-15*xp)/384.0;
%g4=(79*xp^9+776*xp^7+1482*xp^5-1920*xp^3-945*xp)/92160.0;
%tp=xp+g1/nu+g2/nu^2+g3/nu^3+g4/nu^4;
cp=nu*(1-2/(9*nu)+xp*sqrt(2/(9*nu)))^3;
end

