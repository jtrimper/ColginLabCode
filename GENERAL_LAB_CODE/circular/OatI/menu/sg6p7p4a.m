xdata=get(hedittest1,'String'); 
Ddata=get(hedittest2,'String'); 
%%%close(f6p7p4)
%%%figure(f1)
axis('off');
eval(['[r,U]=raymodp(' xdata ',' Ddata ');']);
%eval(['M=' data ';']);
%eval(['M=M(:,1);']);
%pr=2*(1-tcdf(abs(t),df));
rl=length(r);
ht(3)=text(0.02,0.50,'r1 = ');
hedit3=uicontrol('Style','edit','String',num2str(r(1)),'Position',[99 119 60 20]);
ht(4)=text(0.5,0.5,'Direction 1 =');
hedit4=uicontrol('Style','edit','String',num2str(atan2(U(2,1),U(1,1))*180/pi),'Position',[280 119 50 20]);
ht(5)=text(0.99,0.54,'o');
if (rl>1),
ht(6)=text(0.02,0.35,'r2 = ');
hedit4=uicontrol('Style','edit','String',num2str(r(2)),'Position',[99 89 60 20]);
ht(7)=text(0.5,0.5,'Direction 2 =');
hedit4=uicontrol('Style','edit','String',num2str(atan2(U(2,2),U(1,2))*180/pi),'Position',[280 89 50 20]);
ht(8)=text(0.99,0.54,'o');
end
if (rl>2),
ht(9)=text(0.02,0.20,'r3 = ');
hedit5=uicontrol('Style','edit','String',num2str(r(3)),'Position',[99 59 60 20]);
ht(10)=text(0.5,0.5,'Direction 3 =');
hedit4=uicontrol('Style','edit','String',num2str(atan2(U(2,3),U(1,3))*180/pi),'Position',[280 59 50 20]);
ht(11)=text(0.99,0.54,'o');
end
%set(ht,'FontName','Serif');
%set(ht,'FontSize',15);
%set(hedit3,'BackgroundColor',[1 1 1]);
%set(hedit4,'BackgroundColor',[1 1 1]);





