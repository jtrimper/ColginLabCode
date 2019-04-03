str=get(hedittest1,'String'); 
dirvar=str2num(str);
str=get(hedittest2,'String'); 
hastvar=str2num(str);
[X,loaded]=chkld([dirvar,hastvar],X,loaded); 
%L=X(sample,vnrld(num,loaded)); 
%[vind,hast]=vectmean(X(sample,vnrld([hastvar,dirvar],loaded)));
xzz=X(sample,vnrld([hastvar,dirvar],loaded));
vind=vectmean([ones(size(xzz,1),1),xzz(:,2)]);
hast=mean(xzz(:,1));
figure(f2)
axis('off');
ht1(3)=text(0.02,0.5,'Mean direction:');
uicontrol('Style','edit','String',num2str(vind),'Position',[140 118 40 20]);
ht1(4)=text(0.02,0.3,'Mean speed:');
uicontrol('Style','edit','String',num2str(hast),'Position',[140 76 40 20]);
set(ht1,'FontName','Serif');
set(ht1,'FontSize',16);
figure(f1)
vindrikt(vind+180,hast);
