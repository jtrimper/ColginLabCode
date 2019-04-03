function [w] = algorithm3(u)
%Inverse w of square root of a positive definite 2 x 2 matrix u (see Algorithm 1)
%Algorithm 3, Fisher (1993), p. 210

beta=(u(1,1) - u(2,2))/(2*u(1,2)) - sqrt((u(1,1)-u(2,2))^2/(4*(u(1,2)^2) + 1));

t1 = sqrt(1 + beta^2)/sqrt(beta^2*u(1,1) + 2*beta*u(1,2) + u(2,2));
t2 = sqrt(1 + beta^2)/sqrt(u(1,1) - 2*beta*u(1,2) + beta^2*u(2,2));

w11 = (beta^2*t1 + t2)/(1 + beta^2);
w22 = (t1 + beta^2*t2)/(1 + beta^2);
w12=beta*(t1 - t2)/(1+beta^2);
w21=w12;

w=[w11 w12; w21 w22];