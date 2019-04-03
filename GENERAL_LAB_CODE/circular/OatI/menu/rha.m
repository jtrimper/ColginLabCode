% Hodjes-Ajne's test
datax=get(hedittest1,'String'); 
%datay=get(hedittext2,'String'); 
%eval([mCallback]);
%figure(fig)
%axis('off');
hti=2;
%eval(['[Dn Dnp Dnm p test]=hodgajne(' datax ');'])
eval(['[n P]=hodgajne(' datax ');']);
test=dotest(P);
%p
%test
%Dn
%Dnp
%Dnm
%n
%POSITION=[175 111 80 20;
%175 85 80 20;
%175 60 80 20];
ht(hti)=text(0.02,0.44,'N max:'); hti=hti+1;
%hedit=uicontrol('Style','edit','String',num2str(n),'Position',[175 110 80 20]);
hedit=uicontrol('Style','edit','String',num2str(n),'Position',POSITION(1,:));
set(hedit,'BackgroundColor',[1 1 1]);
ht(hti)=text(0.02,0.32,'P:'); hti=hti+1;
%hedit=uicontrol('Style','edit','String',num2str(P),'Position',[175 85 80 20]);
hedit=uicontrol('Style','edit','String',num2str(P),'Position',POSITION(2,:));
ht(hti)=text(0.02,0.2,'test:'); hti=hti+1;
%hedit=uicontrol('Style','edit','String',test,'Position',[175 60 80 20]);
hedit=uicontrol('Style','edit','String',test,'Position',POSITION(3,:));
set(hedit,'BackgroundColor',[1 1 1]);
%ht(hti)=text(0.53,0.32,'P:'); hti=hti+1;
%hedit=uicontrol('Style','edit','String',num2str(p),'Position',[300 85 80 20]);
%set(hedit,'BackgroundColor',[1 1 1]);
%ht(hti)=text(0.53,0.2,'test:'); hti=hti+1;
%hedit=uicontrol('Style','edit','String',test,'Position',[300 60 80 20]);
%set(hedit,'BackgroundColor',[1 1 1]);
%set(ht,'FontName','Serif');
%set(ht,'FontSize',27);
set(ht,'FontSize',15);





