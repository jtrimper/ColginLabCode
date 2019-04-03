%datax=get(hedittext1,'String'); 
%datay=get(hedittext2,'String'); 
%eval([mCallback]);
%figure(fig)
%axis('off');
hti=2;
eval(['[Rx Ry p z test]=wilcoxon(' datax ',' datay ');'])
ht(hti)=text(0.02,0.3,'Rx:'); hti=hti+1;
hedit=uicontrol('Style','edit','String',num2str(sum(Rx)),'Position',[175 85 80 20]);
%hedit=uicontrol('Style','edit','String',num2str(sum(Rx)),'Position',POSITION(1,:));
set(hedit,'BackgroundColor',[1 1 1]);
ht(hti)=text(0.02,0.2,'Ry:'); hti=hti+1;
hedit=uicontrol('Style','edit','String',num2str(sum(Ry)),'Position',[175 60 80 20]);
%hedit=uicontrol('Style','edit','String',num2str(sum(Ry)),'Position',POSITION(2,:));
set(hedit,'BackgroundColor',[1 1 1]);
ht(hti)=text(0.53,0.3,'z:'); hti=hti+1;
hedit=uicontrol('Style','edit','String',num2str(z),'Position',[300 85 80 20]);
set(hedit,'BackgroundColor',[1 1 1]);
ht(hti)=text(0.53,0.2,'test:'); hti=hti+1;
hedit=uicontrol('Style','edit','String',test,'Position',[300 60 80 20]);
set(hedit,'BackgroundColor',[1 1 1]);
set(ht,'FontName','Serif');
set(ht,'FontSize',27);
%%uicontrol('Style','pushbutton','String','Plot','Callback','sg6p4p1b','Position',[360 200 60 27]);
%uicontrol('Style','pushbutton','String','Table','Callback','sg6p4p1c','Position',[360 170 60 27]);

