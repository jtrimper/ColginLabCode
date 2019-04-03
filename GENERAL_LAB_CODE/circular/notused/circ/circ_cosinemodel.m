function yp=circ_cosinemodel(theta,x)
% cosine tuning function 
%   function yp=circ_cosinemodel(theta,x)
% theta_1: Intercept
% theta_2,3: vector of preferred direction
% yp=theta(1)+theta(2)*cos(2*x)+theta(3)*sin(2*x);
yp=theta(1)+theta(2)*cos(2*x)+theta(3)*sin(2*x);
