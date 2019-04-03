function THETA=vonMises (theta, kappa)
%Returns a value THETA which is a point drawn randomly from a 
%von Mises distribution with mean theta (0<= theta <= 2pi) 
%and concentration kappa (0-infinity).

%Implements the 'Method of Simulation' from Fisher (1993), pg. 49

U=rand(1,3); %rand draws from uniform distribution (U: 0-1)

a=1 + sqrt(1 + 4*kappa^2);
b=(a - sqrt(2*a))/(2*kappa);
r=(1 + b^2)/(2*b);

z=cos(pi*U(1));
f=(1 + r*z)/(r + z);
c=kappa*(r - f);

if c*(2 - c) - U(2) >0 | log(c/U(2)) + 1 - c>0
   THETA = sign(U(3) - 0.5)*acos(f) + theta;
   THETA = mod(THETA, 2*pi);
else
   THETA=vonMises (theta, kappa);
end;