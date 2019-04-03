%U=(X(:,vnrld(ksel,loaded))<200);
%X=[]; loaded=[];
namnet=get(hedit1,'String'); 
samplet=get(hedit3,'String'); 
str=get(hedit2,'String'); 
%[antvar,c]=size(var);
%T=[]; tit=''; titlx='';
val1=get(hpu1,'Value');
val2=get(hpu2,'Value');
for i=1:antvar,  
  if (i==val2),
    [X,loaded]=chkld(i,X,loaded);
    U=eval(['(X(:,vnrld(i,loaded))' str ')']);
  end
%  v=get(hchb(i),'Value');
%  if (v>0.5), 
%    [X,loaded]=chkld(i,X,loaded);
%%     fsel=figure;     
%%     text(0.02,0.3,var(i,:));
%%     hed(1)=uicontrol('Style','edit','String','=1000','Position',[100 100 150 50])
%%     hchbb(2)=uicontrol('Style','pushbutton','String','GT','Callback','=','Position',[10 10 50 50])
%     U=eval(['(X(:,vnrld(i,loaded))' str ')']);
%%    T=buildtab(T,X(:,vnrld(i,loaded)));
%%    tit=[tit,'   ',var(i,:)];
%%    if (titlx==''), titlx=[var(i,:)];
%%    else 
%%      titlx=[titlx '&' var(i,:)];
%%    end
%  end
end
[X,loaded]=chkld(11,X,loaded);
[X,loaded]=chkld(cage,X,loaded);
[rx,cx]=size(X);
sects=length(cage);
sectdir=ones(rx,1)*[0:sects-1]*360/sects+X(:,vnrld(11,loaded))*ones(1,sects);
[R,N,A1,A2,A]=sect2rk(X(:,vnrld(cage,loaded)),sectdir);
for i=antvar+1:antvar+4,  
  if (i==val2),
%    [X,loaded]=chkld(i,X,loaded);
    if (i-antvar==1), U=eval(['(R(:,1)' str ')']); end
    if (i-antvar==2), U=eval(['(A(:,1)' str ')']); end
    if (i-antvar==3), U=eval(['(R(:,2)' str ')']); end
    if (i-antvar==4), U=eval(['(A(:,2)' str ')']); end
  end
end
for i=1:antvar,  
  if (i==val1),
    [X,loaded]=chkld(i,X,loaded);
    eval(['[' namnet ',sample]=select(X(:,vnrld(i,loaded)),U);']);
    eval([samplet '=sample;']);
  end
end
for i=antvar+1:antvar+4,  
  if (i==val1),
%    [X,loaded]=chkld(i,X,loaded);
    if (i-antvar==1),  eval(['[' namnet ',sample]=select(R(:,1),U);']); end
    if (i-antvar==2),  eval(['[' namnet ',sample]=select(A(:,1),U);']); end
    if (i-antvar==3),  eval(['[' namnet ',sample]=select(R(:,2),U);']); end
    if (i-antvar==4),  eval(['[' namnet ',sample]=select(A(:,2),U);']); end
%    if (i-antvar==2), [M,sample]=select(A(:,1),U); end
%    if (i-antvar==3), [M,sample]=select(R(:,2),U); end
%    if (i-antvar==4), [M,sample]=select(A(:,2),U); end
%    eval(['[' namnet ',sample]=select(R(:,1),U);']);
    eval([samplet '=sample;']);
  end
end
%M=select(X(:,vnrld(3)),U)
%for i=1:4,  
%  v=get(hchbn(i),'Value');
%  if (v>0.5), 
%    if (i==1), 
%      T=buildtab(T,R(:,1));   
%      tit=[tit,'   ','r'];
%      titlx=[titlx,'&','r'];
%    end
%  end
%end
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

