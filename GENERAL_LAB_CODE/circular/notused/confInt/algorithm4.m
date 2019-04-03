function [theta, kappa, rBar] = algorithm4(Z0, V0, Wb, Zb, n_Data)
%Estimate of mean direction
%Algorithm 4, Fisher (1993), p. 210

x =Z0 - V0*Wb*(Zb - Z0);
Cb=x(1);
Sb=x(2);

%2.9, Fisher (1993), p. 31
theta = atan2 (Sb, Cb);
theta=mod(theta, 2*pi);

rBar = sqrt(Cb^2 + Sb^2);

%Maximum Likelihood estimate of Kappa - Fisher (1993), 4.40
if rBar<0.53
   kappaML=2*rBar + rBar^3 + (5*rBar^5)/6;
else
   if rBar >= 0.85
      kappaML=1/(rBar^3 - 4*rBar^2 + 3*rBar);
   else
      kappaML=-0.4 + 1.39*rBar + 0.43/(1 - rBar);
   end;
end;

%Corrected estimate for Kappa - Fisher (1993), 4.41
if kappaML<2
   kappa=max(kappaML - 2*(n_Data*kappaML)^-1, 0);
else
   kappa=(n_Data-1)^3*kappaML/(n_Data^3 + n_Data);
end;