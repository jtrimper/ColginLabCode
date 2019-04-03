data=get(hedittest1,'String'); 
str=get(hedittest2,'String'); 
figure(f6p5p3)
axis('off');
eval(['[A,r,n,c]=circac(' data ',' str ');']);
m=180*atan2(A(2),A(1))/pi;
d=180*c/pi;
m1=m-d(2); m2=m+d(2); if m2<0, m1=m1+360; m2=m2+360; end
if (m1>180), m1=m1-180; m2=m2-180; end
hedit4=uicontrol('Style','edit','String',['(' num2str(m1) ',' num2str(m2) ')' '(' num2str(m1+180) ',' num2str(m2+180) ')'],'Position',[270 125 180 20]);
set(hedit4,'BackgroundColor',[1 1 1]);
m1=m-d(1); m2=m+d(1); if m2<0, m1=m1+360; m2=m2+360; end
if (m1>180), m1=m1-180; m2=m2-180; end
hedit5=uicontrol('Style','edit','String',['(' num2str(m1) ',' num2str(m2) ')' '(' num2str(m1+180) ',' num2str(m2+180) ')'],'Position',[270 95 180 20]);
set(hedit5,'BackgroundColor',[1 1 1]);
m1=d(5); m2=d(4); if m2<0, m1=m1+360; m2=m2+360; end
m11=d(7); m22=d(6); if m22<0, m11=m11+360; m22=m22+360; end
hedit6=uicontrol('Style','edit','String',['(' num2str(m1) ',' num2str(m2) ')' '(' num2str(m11) ',' num2str(m22) ')'],'Position',[270 65 180 20]);
set(hedit6,'BackgroundColor',[1 1 1]);
set(ht,'FontName','Serif');
set(ht,'FontSize',13);
%hpb2=uicontrol('Style','pushbutton','String','Help','Callback','sg6p5p1b','Position',[360 200 60 27]);

