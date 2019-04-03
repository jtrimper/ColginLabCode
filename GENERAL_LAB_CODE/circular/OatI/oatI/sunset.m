function sunset(x)
%
% Plots a sunrise in position x
%
% CALL: sunset(x)
%
% where
%
%     x   = column vector of directions,
%
% Copyright (C) 1993, Bjorn Holmquist, Dept of Math. Stat., University of Lund.
%
angle=180*atan2(x(1),x(2))/pi;
 if angle<0, angle=angle+360;
end 
  text(x(1),x(2)-0.05,[num2str(angle)],'HorizontalAlignment','center')
  hold on   
  plot([x(1)-0.15;x(1)+0.15],[x(2);x(2)+0.0],'w-')
  plot(x(1)+0.1*cos(pi*(90-[-90:90])/180),x(2)+0.1*sin(pi*(90-[-90:90])/180),'w-')
  plot([x(1)+0.1*cos(pi*(90-[-80:20:80])/180);x(1)+0.12*cos(pi*(90-[-80:20:80]-5)/180)],[x(2)+0.1*sin(pi*(90-[-80:20:80])/180);x(2)+0.12*sin(pi*(90-[-80:20:80]-5)/180)],'w-')
  plot([x(1)+0.12*cos(pi*(90-[-80:20:80]-5)/180);x(1)+0.14*cos(pi*(90-[-80:20:80])/180)],[x(2)+0.12*sin(pi*(90-[-80:20:80]-5)/180);x(2)+0.14*sin(pi*(90-[-80:20:80])/180)],'w-')
  plot([x(1)+0.14*cos(pi*(90-[-80:20:80])/180);x(1)+0.16*cos(pi*(90-[-80:20:80]-5)/180)],[x(2)+0.14*sin(pi*(90-[-80:20:80])/180);x(2)+0.16*sin(pi*(90-[-80:20:80]-5)/180)],'w-')
  plot([x(1)+0.16*cos(pi*(90-[-80:20:80]-5)/180);x(1)+0.18*cos(pi*(90-[-80:20:80])/180)],[x(2)+0.16*sin(pi*(90-[-80:20:80]-5)/180);x(2)+0.18*sin(pi*(90-[-80:20:80])/180)],'w-')
end


