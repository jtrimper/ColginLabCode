data=get(hedittest1,'String'); 
%dirvar=str2num(str);
m0str=get(hedittest2,'String'); 
%m0=str2num(str);
figure(f6p2p1)
axis('off');
eval(['[t,df]=ttest(' data ',' m0str ');']);
t
df
pr=2*(1-tcdf(abs(t),df))
ht(3)=text(0.02,0.5,'t quantity:');
hedit3=uicontrol('Style','edit','String',num2str(t),'Position',[195 118 80 20]);
ht(4)=text(0.02,0.3,'Probability:');
hedit4=uicontrol('Style','edit','String',num2str(pr),'Position',[195 76 80 20]);
set(ht,'FontName','Serif');
set(ht,'FontSize',15);
set(hedit3,'BackgroundColor',[1 1 1]);
set(hedit4,'BackgroundColor',[1 1 1]);
%figure(f1)
%vindrikt(vind+180,hast);
