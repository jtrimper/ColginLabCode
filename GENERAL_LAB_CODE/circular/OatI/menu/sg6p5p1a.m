data=get(hedittest1,'String'); 
str=get(hedittest2,'String'); 
%m0str=get(hedittest3,'String'); 
figure(f6p5p1)
axis('off');
eval(['[m,s,n]=medel(' data ');']);
%pr=1-tcdf(abs(t),df);
l=nqnt((1-str2num(str)/100)/2);
d=l*s/sqrt(n);
%ht(2)=text(0.02,0.3,'95 % conf int:');
hedit4=uicontrol('Style','edit','String',['(' num2str(m-d) ',' num2str(m+d) ')'],'Position',[270 95 140 20]);
set(hedit4,'BackgroundColor',[1 1 1]);
%ht(4)=text(0.02,0.1,'slope (b):');
%hedit5=uicontrol('Style','edit','String',num2str(b),'Position',[175 35 80 20]);
%set(hedit5,'BackgroundColor',[1 1 1]);
set(ht,'FontName','Serif');
set(ht,'FontSize',15);
%hpb2=uicontrol('Style','pushbutton','String','Help','Callback','sg6p5p1b','Position',[360 200 60 27]);

