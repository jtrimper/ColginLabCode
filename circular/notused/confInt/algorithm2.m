function [v] = algorithm2(u)
%Square root v of positive definite symmetric 2 x 2 matrix u (see Algorithm 1)
%Algorithm 2, Fisher (1993), p. 210

beta=(u(1,1) - u(2,2))/(2*u(1,2)) - sqrt((u(1,1)-u(2,2))^2/(4*(u(1,2)^2) + 1));

t1 = sqrt(beta^2*u(1,1) + 2*beta*u(1,2) + u(2,2))/sqrt(1 + beta^2);
t2 = sqrt(u(1,1) - 2*beta*u(1,2) + beta^2*u(2,2))/sqrt(1 + beta^2);

v11 = (beta^2*t1 + t2)/(1 + beta^2);
v22 = (t1 + beta^2*t2)/(1 + beta^2);
v12=beta*(t1 - t2)/(1+beta^2);
v21=v12;

v=[v11 v12; v21 v22];