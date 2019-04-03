xdata=get(hedittest1,'String'); 
udata=get(hedittest2,'String'); 
%%%close(f6p7p4)
%%%figure(f1)
axis('off');
eval(['[r,be]=pcdmod(' xdata ',' udata ')']);
%eval(['b=' beta ';']);
r
be
%eval(['M=M(:,1);']);
%pr=2*(1-tcdf(abs(t),df));
ht(3)=text(0.02,0.50,'r = ');
hedit3=uicontrol('Style','edit','String',num2str(r),'Position',[99 119 60 20]);
ht(4)=text(0.02,0.35,'pcd conc = ');
hedit4=uicontrol('Style','edit','String',num2str(sqrt(be'*be)),'Position',[110 89 60 20]);
ht(5)=text(0.5,0.35,'pcd direction =');
hedit4=uicontrol('Style','edit','String',num2str(atan2(be(2,1),be(1,1))*180/pi),'Position',[250 89 50 20]);
%ht(6)=text(0.99,0.54,'o');
%set(ht,'FontName','Serif');
%set(ht,'FontSize',15);
%set(hedit3,'BackgroundColor',[1 1 1]);
%set(hedit4,'BackgroundColor',[1 1 1]);





