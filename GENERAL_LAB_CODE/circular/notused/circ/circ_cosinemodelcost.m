function error=circ_cosinemodelcost(theta,x,y)
yp=theta(1)+theta(2)*cos(2*x)+theta(3)*sin(2*x);
error=y-yp;
