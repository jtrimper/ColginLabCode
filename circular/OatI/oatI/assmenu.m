fdes=figure('Name','Assign variables','NumberTitle','off',...
'Position',[2 2 590 350],'Resize','off');
set(fdes,'MenuBar','none');
axis('off');
%ht=[];
%set(ht,'FontName','Serif');
%set(ht,'FontSize',11);
[antvar,c]=size(var);
popupen=[var(1,:)];
for i=2:antvar,
  popupen=[popupen,'|',var(i,:)];
end
popupen=[popupen,'| Ang(:,1)',];
text(0.02,0.95,'y-variable');
hpu=uicontrol('Style','popup','String',popupen,'Value',1,'Position',[180 300 100 25]);
text(0.02,0.7,'x-variable(s)');
for i=1:antvar,
  k=floor((i-1)/7);
  xi=100+80*k; 
  yi=185-(i-1)*30+k*7*30;
  hchb(i)=uicontrol('Style','checkbox','String',var(i,:),'Value',0,'Position',[xi yi 90 22]);
  set(hchb(i),'BackgroundColor',[1 1 1]);
end
hpb=uicontrol('Style','pushbutton','String','OK','Callback','assmenua','Position',[340 5 40 27]);

