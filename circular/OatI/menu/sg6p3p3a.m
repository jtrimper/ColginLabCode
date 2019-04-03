datax=get(hedittest1,'String'); 
datay=get(hedittest2,'String'); 
figure(f6p3p3)
clf %961129
axis('off');
eval(['[A1,r1,n1]=circmean(' datax ');']);
eval(['[A2,r2,n2]=circmean(' datay ');']);
r=(n1*r1+n2*r2)/(n1+n2);
t1=(2/sqrt(3))*(asin(2*sqrt(3/8)*r1)-asin(2*sqrt(3/8)*r2))/sqrt(1/(n1-4)+1/(n2-4));
t2=(asinh((r1-1.0894)/0.25789)-asinh((r2-1.0894)/0.25789))/(0.89325*sqrt(1/(n1-3)+1/(n2-3)));
t3=n1*(1-r1)*(n2-1)/(n2*(1-r2)*(n1-1));
if (r<0.45),
  t=t1;
%pr=1-tcdf(abs(t),df);
%l=nqnt((1-str2num(str)/100)/2);
%d=l*s/sqrt(n);
%m=180*atan2(A(2),A(1))/pi;
%d=180*c/pi;
%m1=m-d(3); m2=m+d(3); if m2<0, m1=m1+360; m2=m2+360; end
  hedit4=uicontrol('Style','edit','String',num2str(t),'Position',[270 80 140 20]);
  set(hedit4,'BackgroundColor',[1 1 1]);
  ht(3)=text(0.02,0.3,'Case I: Test quantity =');
elseif (r<0.70),
  t=t2;
  hedit4=uicontrol('Style','edit','String',num2str(t),'Position',[270 80 140 20]);
  set(hedit4,'BackgroundColor',[1 1 1]);
  ht(3)=text(0.02,0.3,'Case II: Test quantity =');
else
  t=t3;
  hedit4=uicontrol('Style','edit','String',num2str(t),'Position',[270 80 140 20]);
  set(hedit4,'BackgroundColor',[1 1 1]);
  ht(3)=text(0.02,0.3,'Case III: Test quantity =');
end
set(ht(3),'FontName','Serif'); %971111
set(ht(3),'FontSize',15); %971111

