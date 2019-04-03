fdes=figure('Name','Describe','NumberTitle','off',...
'Position',[2 2 590 350],'Resize','off');
set(fdes,'MenuBar','none');
axis('off');
%var=['var 1';'var 2';'var 3'];
%ht=[];
%set(ht,'FontName','Serif');
%set(ht,'FontSize',11);
[antvar,c]=size(vars);
popupen=[vars(1,:)];
for i=2:antvar,
  popupen=[popupen,'|',vars(i,:)];
end
popupen=[popupen,'| Ang(:,1)',];
text(0.02,0.95,'Describe');
hpu=uicontrol('Style','popup','String',popupen,'Value',1,'Position',[180 300 100 25]);
text(0.02,0.7,'split by');
for i=1:antvar,
  k=floor((i-1)/7);
  xi=100+80*k; 
  yi=185-(i-1)*30+k*7*30;
  hchb(i)=uicontrol('Style','checkbox','String',vars(i,:),'Value',0,'Position',[xi yi 90 22]);
  set(hchb(i),'BackgroundColor',[1 1 1]);
end
hpb=uicontrol('Style','pushbutton','String','OK','Callback','desmenua','Position',[340 5 40 27]);

