data1=get(hedittest1,'String'); 
data2=get(hedittest2,'String'); 
%m0str=get(hedittest3,'String'); 
figure(f6p3p2)
axis('off');
eval(['[U2]=watsonu2(' data1 ',' data2 ');']);
%pr=1-tcdf(abs(t),df);
ht(3)=text(0.02,0.3,'U2:');
hedit4=uicontrol('Style','edit','String',num2str(U2),'Position',[135 75 40 20]);
set(hedit4,'BackgroundColor',[1 1 1]);
%ht(5)=text(0.02,0.1,'Probability:');
%hedit5=uicontrol('Style','edit','String',num2str(pr),'Position',[175 35 80 20]);
%set(hedit5,'BackgroundColor',[1 1 1]);
set(ht,'FontName','Serif');
set(ht,'FontSize',15);

