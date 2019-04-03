datay=get(hedittest1,'String');
[n,pv]=size(var);
[ny,py]=size(datay);
if py==pv,
for i=1:antvar,
  if datay(1:pv)==var(i,:),
    y=X(sample,vnrld(i,loaded));
    datay=['X(sample,vnrld(' num2str(i) ',loaded))'];
  end
end
end
datax=get(hedittest2,'String');
v=get(hchb,'Value');
[n,p]=size(X(sample,:));
if v>0.5,
  XX=ones(n,1);
else
  XX=[];
end
[nx,px]=size(datax);
if px==pv,
for i=1:antvar,
  if datax(1:pv)==var(i,:),
    XX=[XX,X(sample,vnrld(i,loaded))];
    datax=['X(sample,vnrld(' num2str(i) ',loaded))'];
  end
end
end
%datay=get(hedittest1,'String'); 
%datax=get(hedittest2,'String'); 
figure(f6p4p1)
axis('off');
if v>0.5, eval(['[a b s]=linreg(' datay ',' datax ');'])
else
  [b,s]=multreg(y,XX);
end
if v>0.5,
  ht(hti)=text(0.02,0.3,'intercept (a):'); hti=hti+1;
  hedit4=uicontrol('Style','edit','String',num2str(a),'Position',[175 75 80 20]);
  set(hedit4,'BackgroundColor',[1 1 1]);
else
  ht(hti)=text(0.02,0.3,'              '); hti=hti+1;
  hedit4=uicontrol('Style','edit','String',' ','Position',[175 75 80 20]);
  set(hedit4,'BackgroundColor',[0 0 0]);
end
ht(hti)=text(0.02,0.1,'slope (b):'); hti=hti+1;
hedit5=uicontrol('Style','edit','String',num2str(b),'Position',[175 35 80 20]);
set(hedit5,'BackgroundColor',[1 1 1]);
set(ht,'FontName','Serif');
set(ht,'FontSize',27);
hpb2=uicontrol('Style','pushbutton','String','Plot','Callback','sg6p4p1b','Position',[360 200 60 27]);
hpb2=uicontrol('Style','pushbutton','String','Table','Callback','sg6p4p1c','Position',[360 170 60 27]);

