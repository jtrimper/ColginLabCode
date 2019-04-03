f2=figure('Name','Simple Statistics','NumberTitle','off',...
'Position',[2 2 180 250],'Resize','off');
set(f2,'MenuBar','none');
axis('off');
ht=[];
ht(1)=text(0.02,0.9,'Variable');
set(ht,'FontName','Serif');
set(ht,'FontSize',17);
hedittest=uicontrol('Style','edit','Callback','dohedit','Position',[100 200 40 20]);

