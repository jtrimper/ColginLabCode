data=get(hedittest1,'String');
udata=get(hedittest3,'String'); 
%dirvar=str2num(str);
posstr=get(hedittest2,'String'); 
%m0=str2num(str);
close(f3p6)
figure(f1)
axis('off');
eval(['s2cplot1(' data ',' udata ',''deg'',' posstr ');']);
eval(['M=' data ';']);
eval(['M=M(:,1);']);
%pr=2*(1-tcdf(abs(t),df));
%ht(3)=text(0.02,0.5,'t quantity:');
%hedit3=uicontrol('Style','edit','String',num2str(t),'Position',[195 118 40 20]);
%ht(4)=text(0.02,0.3,'Probability:');
%hedit4=uicontrol('Style','edit','String',num2str(pr),'Position',[195 76 80 20]);
%set(ht,'FontName','Serif');
%set(ht,'FontSize',15);
%set(hedit3,'BackgroundColor',[1 1 1]);
%set(hedit4,'BackgroundColor',[1 1 1]);

