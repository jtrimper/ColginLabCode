function sun(x)
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
%
global htextcount
global htext
angle=180*atan2(x(1),x(2))/pi;
if angle<0, angle=angle+360;
end 
  htextcount=htextcount+1;
  htext(htextcount)=text(x(1),x(2),[int2str(angle)],'HorizontalAlignment','center');
  set(htext,'FontSize',8)
  hold on
  plot(x(1)+0.1*cos(pi*(90-[-180:180])/180),x(2)+0.1*sin(pi*(90-[-180:180])/180),'w-')
  plot([x(1)+0.1*cos(pi*(90-[-180:10:180])/180);x(1)+0.15*cos(pi*(90-[-180:10:180])/180)],[x(2)+0.1*sin(pi*(90-[-180:10:180])/180);x(2)+0.15*sin(pi*(90-[-180:10:180])/180)],'w-')
end


