datax=get(hedittest1,'String'); 
hti=2;
eval(['[Un n]=watsonun(' datax ');'])
test='Not finished';
%if Un>1.747, test='*';
%if Un>2.001, test='**';
ht(hti)=text(0.02,0.44,'Un:'); hti=hti+1;
hedit=uicontrol('Style','edit','String',num2str(Un),'Position',POSITION(1,:));
set(hedit,'BackgroundColor',[1 1 1]);
ht(hti)=text(0.02,0.32,'n:'); hti=hti+1;
hedit=uicontrol('Style','edit','String',num2str(n),'Position',POSITION(2,:));
set(hedit,'BackgroundColor',[1 1 1]);
%ht(hti)=text(0.02,0.2,'Dnp:'); hti=hti+1;
%hedit=uicontrol('Style','edit','String',num2str(V),'Position',POSITION(3,:));
%set(hedit,'BackgroundColor',[1 1 1]);
hedit=uicontrol('Style','edit','String',test,'Position',[300 60 80 20]);
set(hedit,'BackgroundColor',[1 1 1]);
%set(ht,'FontName','Serif');
%set(ht,'FontSize',27);
%%uicontrol('Style','pushbutton','String','Plot','Callback','sg6p4p1b','Position',[360 200 60 27]);
%uicontrol('Style','pushbutton','String','Table','Callback','sg6p4p1c','Position',[360 170 60 27]);

