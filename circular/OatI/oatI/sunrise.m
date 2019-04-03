function sunrise(x)
%
% Plots a sunrise in position x
%
% CALL: sun(x)
%
% where
%
%     x   = column vector of directions,
%
% Copyright (C) 1993, Bjorn Holmquist, Dept of Math. Stat., University of Lund.
angle=180*atan2(x(1),x(2))/pi;
if angle<0, angle=angle+360;
end 
global htextcount
global htext
htextcount=htextcount+1;
htext(htextcount)=text(x(1),x(2)-0.05,[num2str(angle)],'HorizontalAlignment','center')
hold on 
plot([x(1)-0.15;x(1)+0.15],[x(2);x(2)+0.0],'w-')
plot(x(1)+0.1*cos(pi*(90-[-90:90])/180),x(2)+0.1*sin(pi*(90-[-90:90])/180),'w-')
plot([x(1)+0.1*cos(pi*(90-[-90:10:90])/180);x(1)+0.15*cos(pi*(90-[-90:10:90])/180)],[x(2)+0.1*sin(pi*(90-[-90:10:90])/180);x(2)+0.15*sin(pi*(90-[-90:10:90])/180)],'w-')
end


