FS1=50; FS1=35;
FS2=20;
fintro=figure('Name','OAT','NumberTitle','off',...
'Position',[0 0 750 650],'Resize','off');
set(fintro,'MenuBar','none');
axis('off');
htone=[];   httwo=[];
htone(1)=text(0.0,0.9,'ORIENTATION','FontSize',FS1);
htone(2)=text(0.25,0.7,'ANALYSIS');
htone(3)=text(0.50,0.5,'TOOLBOX');
httwo(1)=text(0.0,0.4,'for use with');
htone(4)=text(0.22,0.2,'MATLAB');
%httwo(2)=text(0.78,0.1,'under Windows');
%set(htone,'FontName','Serif')
%set(htone,'FontAngle','oblique')
set(htone,'FontSize',FS1)
%set(httwo,'FontName','Serif')
%set(httwo,'FontAngle','oblique')
set(httwo,'FontSize',FS2)
pause(6)
set(fintro,'Visible','off')
%circlesh
%hedittest1=uicontrol('Style','edit','Position',[140 195 35 20]);
%hedittest2=uicontrol('Style','edit','Callback','shg2p11f','Position',[140 155 35 20]);
