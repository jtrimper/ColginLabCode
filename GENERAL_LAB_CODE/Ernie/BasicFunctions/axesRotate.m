function [xx, yy] = axesRotate (x,y)
	g = polyfit(x,y,1);

	theta = atan(g(1));

	xx = x*cos(theta) + y*sin(theta);
	yy = -x*sin(theta) + y*cos(theta);
