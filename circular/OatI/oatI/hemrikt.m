function hemrikt(dir)
%
% hemrikt(riktning)
%
global htextcount
global htext
global FontSize
htextcount=htextcount+1;
htext(htextcount)=text(1.45*cos((90-dir)*pi/180),1.45*sin((90-dir)*pi/180), ...
          ['H=',num2str(dir)],'HorizontalAlignment','center')
set(htext,'FontSize',FontSize);
%end fcn

