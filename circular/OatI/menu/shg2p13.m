f2p13=figure('Name','text','NumberTitle','off',...
'Position',[2 2 450 250],'Resize','off');
set(f2p13,'MenuBar','none');
axis('off');
ht=[];
ht(1)=text(0.02,0.9,'Text: ');
ht(2)=text(0.02,0.3,'Horiz pos: ');
ht(3)=text(0.02,0.1,'Vert  pos:');
set(ht,'FontName','Serif');
set(ht,'FontSize',16);
hedittest1=uicontrol('Style','edit','Position',[140 195 290 20]);
hedittest2=uicontrol('Style','edit','Position',[140 75 35 20]);
hedittest3=uicontrol('Style','edit','Position',[140 35 35 20]);
hedittest4=uicontrol('Style','edit','Position',[140 155 290 20]);
hedittest5=uicontrol('Style','edit','Position',[140 115 290 20]);
hpb=uicontrol('Style','pushbutton','String','OK','Callback','shg2p13f','Position',[340 10 40 27]);
