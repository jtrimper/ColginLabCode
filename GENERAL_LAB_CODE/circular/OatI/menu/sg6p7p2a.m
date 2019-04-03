xdata=get(hedittest1,'String'); 
%dirvar=str2num(str);
udata=get(hedittest2,'String'); 
%%%close(f6p7p1)
%%%figure(f1)
axis('off');
eval(['[r]=vmodp(' xdata ',' udata ');']);
%eval(['M=' data ';']);
%eval(['M=M(:,1);']);
%pr=2*(1-tcdf(abs(t),df));
rl=length(r);
ht(3)=text(0.02,0.50,'r1 = ');
hedit3=uicontrol('Style','edit','String',num2str(r(1)),'Position',[99 119 60 20]);
if (rl>1),
ht(4)=text(0.02,0.35,'r2 = ');
hedit4=uicontrol('Style','edit','String',num2str(r(2)),'Position',[99 89 60 20]);
end
if (rl>2),
ht(5)=text(0.02,0.20,'r3 = ');
hedit5=uicontrol('Style','edit','String',num2str(r(3)),'Position',[99 59 60 20]);
end
%ht(4)=text(0.02,0.3,'Probability:');
%hedit4=uicontrol('Style','edit','String',num2str(pr),'Position',[195 76 80 20]);
%set(ht,'FontName','Serif');
%set(ht,'FontSize',15);
%set(hedit3,'BackgroundColor',[1 1 1]);
%set(hedit4,'BackgroundColor',[1 1 1]);

