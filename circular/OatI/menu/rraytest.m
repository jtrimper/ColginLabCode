% Rayleigh test
datax=get(hedittest1,'String');
%datay=get(hedittext2,'String'); 
%eval([mCallback]);
%figure(fig)
%axis('off');
hti=2;
eval(['[r,p,test]=raytest(' datax ');'])
%p
%test
ht(hti)=text(0.02,0.44,'r:'); hti=hti+1;
hedit=uicontrol('Style','edit','String',num2str(r),'Position',POSITION(1,:));
set(hedit,'BackgroundColor',[1 1 1]);
ht(hti)=text(0.02,0.32,'P:'); hti=hti+1;
hedit=uicontrol('Style','edit','String',num2str(p),'Position',POSITION(2,:));
set(hedit,'BackgroundColor',[1 1 1]);
ht(hti)=text(0.02,0.2,'test:'); hti=hti+1;
hedit=uicontrol('Style','edit','String',test,'Position',POSITION(3,:));
set(hedit,'BackgroundColor',[1 1 1]);






