X=[]; loaded=[];
%data=get(hedittest1,'String'); 
str=get(hedit2,'String'); 
[antvar,c]=size(var);
T=[]; tit=''; titlx='';
for i=1:antvar,  
  v=get(hchb(i),'Value');
  if (v>0.5), 
    [X,loaded]=chkld(i,X,loaded);
    T=buildtab(T,X(:,vnrld(i,loaded)));
    tit=[tit,'   ',var(i,:)];
    if (titlx==''), titlx=[var(i,:)];
    else 
      titlx=[titlx '&' var(i,:)];
    end
  end
end
[X,loaded]=chkld(11,X,loaded);
[X,loaded]=chkld(cage,X,loaded);
[rx,cx]=size(X);
sects=length(cage);
sectdir=ones(rx,1)*[0:sects-1]*360/sects+X(:,vnrld(11,loaded))*ones(1,sects);
[R,N,A1,A2,A]=sect2rk(X(:,vnrld(cage,loaded)),sectdir);
for i=1:4,  
  v=get(hchbn(i),'Value');
  if (v>0.5), 
    if (i==1), 
      T=buildtab(T,R(:,1));   
      tit=[tit,'   ','r'];
      titlx=[titlx,'&','r'];
    end
    if (i==2), 
      T=buildtab(T,A(:,1));   
      tit=[tit,'   ','a'];
      titlx=[titlx,'&','a'];
    end
    if (i==3), 
      T=buildtab(T,R(:,2));   
      tit=[tit,'   ','r2'];
      titlx=[titlx,'&','r2'];
    end
    if (i==4), 
      T=buildtab(T,A(:,2));   
      tit=[tit,'   ','a2'];
      titlx=[titlx,'&','a2'];
    end
  end
end
v1=get(hchbiu(1),'Value');
if (v1>0.5),
  tabelllx(T,titlx,[str '.tex']);
 else
  tabell(T,tit,str);
end
v=get(hchbiu(2),'Value');
if (v>0.5),
  if (v1>0.5),
    dos(['latex ' str]); 
    dos(['dvijep ' str]); 
    dos(['spr ' str '.jep']); 
  else
    dos(['print ' str]); 
  end
end
%figure(tabmenu)
%axis('off');
%eval(['[A,r,n,c]=circmc(' data ',' str ');']);
%d=180*c/pi;
%hedit4=uicontrol('Style','edit','String',['(' num2str(m1) ',' num2str(m2) ')'],'Position',[270 125 140 20]);
%set(hedit4,'BackgroundColor',[1 1 1]);
%m1=m-d(1); m2=m+d(1); if m2<0, m1=m1+360; m2=m2+360; end
%hedit5=uicontrol('Style','edit','String',['(' num2str(m1) ',' num2str(m2) ')'],'Position',[270 95 140 20]);
%set(hedit5,'BackgroundColor',[1 1 1]);
%set(ht,'FontName','Serif');
%set(ht,'FontSize',15);
%hpb2=uicontrol('Style','pushbutton','String','Help','Callback','sg6p5p1b','Position',[360 200 60 27]);

