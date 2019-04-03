frmfile=get(hedittest1,'String'); 
%datax=get(hedittest2,'String'); 
%figure(f1)
%axis('off');
F=getframe(f1);
%fid=fopen
%eval(['[a b s]=linreg(' datax ',' datay ');']);
eval(['fid=fopen(' frmfile ');']);
count=fwrite(fid,F);
status=fclose(fid);
%ht(3)=text(0.02,0.3,'intercept (a):');
%hedit4=uicontrol('Style','edit','String',num2str(a),'Position',[175 75 40 20]);
%set(hedit4,'BackgroundColor',[1 1 1]);
%ht(4)=text(0.02,0.1,'slope (b):');
%hedit5=uicontrol('Style','edit','String',num2str(b),'Position',[175 35 80 20]);
%set(hedit5,'BackgroundColor',[1 1 1]);
%set(ht,'FontName','Serif');
%set(ht,'FontSize',15);
%hpb2=uicontrol('Style','pushbutton','String','Plot','Callback','sg6p4p1b','Position',[360 200 60 27]);

