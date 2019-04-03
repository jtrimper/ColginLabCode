f6p4p1=figure('Name','Linear Regression','NumberTitle','off',...
'Position',[2 2 490 250],'Resize','off');
set(f6p4p1,'MenuBar','none');
axis('off');
ht=[];
%ht(1)=text(0.02,0.9,'y vector: ');
%ht(2)=text(0.02,0.7,'x vector: ');
%set(ht,'FontName','Serif');
%set(ht,'FontSize',15);
%hedittest1=uicontrol('Style','edit','Position',[170 195 135 20]);
%hedittest2=uicontrol('Style','edit','Position',[170 155 135 20]);
%hchb=uicontrol('Style','checkbox','String','constant','Value','1','Position',[229 115 79 22]);
%set(hedittest1,'BackgroundColor',[1 1 1]);
%set(hedittest2,'BackgroundColor',[1 1 1]);
%set(hchb,'BackgroundColor',[1 1 1]);
%hpb=uicontrol('Style','pushbutton','String','OK','Callback','sg6p4p1a','Position',[340 15 40 27]);
%%%%%%%%
[antvar,c]=size(var);
popupen=[var(1,:)];
for i=2:antvar,
  popupen=[popupen,'|',var(i,:)];
end
popupen=[popupen,'| Ang(:,1)',];
%text(0.02,0.95,'y-variable');
ht=[]; hti=1;
ht(hti)=text(0.02,0.9,'y-variable: '); hti=hti+1;
ht(hti)=text(0.02,0.7,'x-variable: '); hti=hti+1;
set(ht,'FontName','Serif');
set(ht,'FontSize',15);
hedittest1=uicontrol('Style','edit','String',var(yvars,:),'Position',[170 195 135 20]);
set(hedittest1,'BackgroundColor',[1 1 1]);
%hpuy=uicontrol('Style','popup','String',popupen,'Value',yvars,'Position',[180 200 120 25]);
hedittest2=uicontrol('Style','edit','String',var(xvars(1),:),'Position',[170 155 135 20]);
set(hedittest2,'BackgroundColor',[1 1 1]);
%hpux=uicontrol('Style','popup','String',popupen,'Value',xvars(1),'Position',[180 160 120 25]);
%text(0.02,0.7,'x-variable(s)');
%for i=1:antvar,
%  k=floor((i-1)/7);
%  xi=100+80*k; 
%  yi=185-(i-1)*30+k*7*30;
%  hchb(i)=uicontrol('Style','checkbox','String',var(i,:),'Value',0,'Position',[xi yi 90 22]);
%  set(hchb(i),'BackgroundColor',[1 1 1]);
%end
%hpb=uicontrol('Style','pushbutton','String','OK','Callback','assmenua','Position',[340 5 40 27]);
hchb=uicontrol('Style','checkbox','String','constant','Value','1','Position',[180 115 85 25]);
hpb=uicontrol('Style','pushbutton','String','OK','Callback','sg6p4p1a','Position',[340 15 40 27]);







