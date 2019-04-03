str=get(hedittest1,'String'); 
hem=str2num(str);
%str=get(hedittest2,'String'); 
%hastvar=str2num(str);
%[X,loaded]=chkld([dirvar,hastvar],X,loaded); 
%[vind,hast]=vectmean(X(sample,vnrld([hastvar,dirvar],loaded)));
%figure(f2)
%axis('off');
%ht(3)=text(0.02,0.5,'Mean direction:');
%uicontrol('Style','edit','String',num2str(vind),'Position',[120 118 50 20]);
%ht(4)=text(0.02,0.3,'Mean speed:');
%uicontrol('Style','edit','String',num2str(hast),'Position',[120 76 50 20]);
%set(ht,'FontName','Serif');
%set(ht,'FontSize',16);
figure(f1)
hemrikt(hem);
