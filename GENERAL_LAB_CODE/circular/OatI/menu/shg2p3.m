[B,c,n]=circmean(M); 
plot([0;c*B(2)],[0;c*B(1)],'y');
psi=3*pi/4;
l1=cos(psi)*c*B(2)-sin(psi)*c*B(1);
l2=sin(psi)*c*B(2)+cos(psi)*c*B(1);
plot([c*B(2);c*B(2)+0.07*l1],[c*B(1);c*B(1)+0.07*l2],'y');
psi=-3*pi/4;
l1=cos(psi)*c*B(2)-sin(psi)*c*B(1);
l2=sin(psi)*c*B(2)+cos(psi)*c*B(1);
plot([c*B(2);c*B(2)+0.07*l1],[c*B(1);c*B(1)+0.07*l2],'y');
a=atan2(B(2),B(1));
if (a<0), a=a+2*pi; end
%global htextcount
%global htext
%if ((txt(1)=='y')|(txt(1)=='s')), 
xcoord=-1.2;
ycoord=-1.1;
%sg2p3x;
ff2p3=figure('Name','Position?','NumberTitle','off',...
'Position',[2 2 400 200],'Resize','off');
set(ff2p3,'MenuBar','none');
axis('off');
ht=[];
ht(1)=text(0.02,0.65,'x-coordinate');
ht(2)=text(0.02,0.4,'y-coordinate');
set(ht,'FontName','Serif');
set(ht,'FontSize',16);
hedit1=uicontrol('Style','edit','String',num2str(xcoord),'Position',[195 118 40 20]);
hedit2=uicontrol('Style','edit','String',num2str(ycoord),'Position',[195 76 40 20]);
hpb=uicontrol('Style','pushbutton','String','OK','Callback','sg2p3xx','Position',[340 15 40 27]);

