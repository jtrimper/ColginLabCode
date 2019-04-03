datax=get(hedittest1,'String'); 
datay=get(hedittest2,'String'); 
%str=get(hedittest2,'String'); 
figure(f6p3p4)
axis('off');
eval(['[A1,r1,n1]=circmean(' datax ');']);
eval(['[A2,r2,n2]=circmean(' datay ');']);
th1=atan2(A1(1),A1(2)); th2=atan2(A2(1),A2(2));
%r=sqrt((n1*r1*cos(th1)+n2*r2*cos(th2))^2+(n1*r1*sin(th1)+n2*r2*sin(th2))^2)/(n1+r2)
%r1
%r2
eval(['[A,r,n]=circmean([' datax ';' datay ']);']);
%r
%n
%pr=1-tcdf(abs(t),df);
%l=nqnt((1-str2num(str)/100)/2);
%d=l*s/sqrt(n);
%m=180*atan2(A(2),A(1))/pi;
%d=180*c/pi;
%m1=m-d(3); m2=m+d(3); if m2<0, m1=m1+360; m2=m2+360; end
df1=2-1; SS1=n1*r1+n2*r2-(n1+n2)*r; MS1=SS1/df1;
df2=n1+n2-2; SS2=n1+n2-n1*r1-n2*r2; MS2=SS2/df2;
ht(3)=text(0.02,0.5,'d.f.         SS         MS          F');
hedit4=uicontrol('Style','edit','String',[num2str(df1) '        ' num2str(SS1) '        ' num2str(MS1) '       ' num2str(MS1/MS2)],'Position',[70 80 200 20]);
set(hedit4,'BackgroundColor',[1 1 1]);                                            
hedit4=uicontrol('Style','edit','String',[num2str(df2) '        ' num2str(SS2) '        ' num2str(MS2) '       ' ],'Position',[70 55 200 20]);
set(hedit4,'BackgroundColor',[1 1 1]);
set(ht,'FontName','Serif');
set(ht,'FontSize',15);
%hpb2=uicontrol('Style','pushbutton','String','Help','Callback','sg6p5p1b','Position',[360 200 60 27]);





