xdata=get(hedittest1,'String'); 
%udata=get(hedittest2,'String'); 
%%%close(f6p7p3)
%%%figure(f1)
axis('off');
eval(['[r,u]=raymod(' xdata ');']);
%eval(['M=' data ';']);
%eval(['M=M(:,1);']);
%pr=2*(1-tcdf(abs(t),df));
ht(3)=text(0.02,0.50,'r = ');
hedit3=uicontrol('Style','edit','String',num2str(r),'Position',[99 119 60 20]);
%ht(4)=text(0.02,0.3,'Direction =');
%hedit4=uicontrol('Style','edit','String',num2str(atan2(u(2),u(1))*180/pi),'Position',[140 79 60 20]);
ht(4)=text(0.5,0.5,'Direction =');
hedit4=uicontrol('Style','edit','String',num2str(atan2(u(2),u(1))*180/pi),'Position',[280 119 50 20]);
ht(5)=text(0.99,0.54,'o');
%set(ht,'FontName','Serif');
%set(ht,'FontSize',15);
%set(hedit3,'BackgroundColor',[1 1 1]);
%set(hedit4,'BackgroundColor',[1 1 1]);

