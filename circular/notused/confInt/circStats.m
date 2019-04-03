function [theta, kappa, rBar] = circStats (data)
%Takes a 1-dim vector of circular data and computes theta and kappa

n_Data = max(size(data));

%Theta - Fisher (1993), 2.7, 2.8, 2.9
C=sum(cos(data));
S=sum(sin(data));

cBar=C/n_Data;
sBar=S/n_Data;
theta=atan2(sBar, cBar);

%R and rBar Fisher (1993) 2,7, 2.10
R=sqrt(C^2 + S^2);
rBar=R/n_Data;

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

