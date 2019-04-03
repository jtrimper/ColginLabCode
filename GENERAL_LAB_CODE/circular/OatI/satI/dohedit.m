str=get(hedittest,'String'); 
num=str2num(str);
[X,loaded]=chkld(num,X,loaded); 
L=X(sample,vnrld(num,loaded)); 
[m,s]=medel(L);
med=md(L);
figure(f2)
axis('off');
ht(2)=text(0.02,0.7,'Name:');
uicontrol('Style','edit','String',var(num,:),'Position',[90 160 80 20]);
ht(3)=text(0.02,0.5,'Mean:');
uicontrol('Style','edit','String',num2str(m),'Position',[97 121 60 20]);
ht(4)=text(0.02,0.3,'Std:');
uicontrol('Style','edit','String',num2str(s),'Position',[97 78 60 20]);
ht(5)=text(0.02,0.1,'Median:');
uicontrol('Style','edit','String',num2str(med),'Position',[97 35 60 20]);
set(ht,'FontName','Serif');
set(ht,'FontSize',17);
