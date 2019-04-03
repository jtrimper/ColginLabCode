data=get(hedittest1,'String'); 
str=get(hedittest2,'String'); 
figure(f6p5p2)
axis('off');
eval(['[A,r,n,c]=circmc(' data ',' str ');']);
%pr=1-tcdf(abs(t),df);
%l=nqnt((1-str2num(str)/100)/2);
%d=l*s/sqrt(n);
m=180*atan2(A(2),A(1))/pi;
d=180*c/pi;
m1=m-d(3); m2=m+d(3); if m2<0, m1=m1+360; m2=m2+360; end
hedit4=uicontrol('Style','edit','String',['(' num2str(m1) ',' num2str(m2) ')'],'Position',[270 125 140 20]);
set(hedit4,'BackgroundColor',[1 1 1]);
m1=m-d(1); m2=m+d(1); if m2<0, m1=m1+360; m2=m2+360; end
hedit5=uicontrol('Style','edit','String',['(' num2str(m1) ',' num2str(m2) ')'],'Position',[270 95 140 20]);
set(hedit5,'BackgroundColor',[1 1 1]);
m1=c(5)*180/pi; m2=c(4)*180/pi; if m2<0, m1=m1+360; m2=m2+360; end
hedit6=uicontrol('Style','edit','String',['(' num2str(m1) ',' num2str(m2) ')'],'Position',[270 65 140 20]);
set(hedit6,'BackgroundColor',[1 1 1]);
set(ht,'FontName','Serif');
set(ht,'FontSize',13);
%hpb2=uicontrol('Style','pushbutton','String','Help','Callback','sg6p5p1b','Position',[360 200 60 27]);

