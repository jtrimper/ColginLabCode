%usemenu version 1.1 1999-03-08
fuse=figure('Name','Use','NumberTitle','off',...
'Position',[2 2 590 350],'Resize','off');
set(fuse,'MenuBar','none');
axis('off');
text(0.02,0.95,'Use');
text(0.550,0.95,'.txt');
hedit1=uicontrol('Style','edit','String','','Position',[150,300,160,20]);
text(0.02,0.80,'Number of columns: ');
hedit2=uicontrol('Style','edit','String','23','Position',[250,256,40,20]);
text(0.02,0.7,'of which load columns');
hedit3=uicontrol('Style','edit','String','[1:23]','Position',[250,228,70,20]);
text(0.1,0.6,'Calculate directions and concentrations');
hchb=uicontrol('Style','checkbox','Value',1,'Position',[90,200,20,20]);
text(0.02,0.5,'of the cage in columns 12-');
hedit4=uicontrol('Style','edit','String','23','Position',[280,173,70,20]);
text(0.02,0.4,'and direction of first sector in column');
hedit5=uicontrol('Style','edit','String','11','Position',[340,145,30,20]);
hpb=uicontrol('Style','pushbutton','String','OK',...
'Backgroundcolor',[1 0 0],'Callback','usemenua','Position',[340 5 40 27]);
