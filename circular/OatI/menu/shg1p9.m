f1p9=figure('Name','Save Plot','NumberTitle','off',...
'Position',[2 2 490 250],'Resize','off');
set(f1p9,'MenuBar','none');
axis('off');
ht=[];
ht(1)=text(0.02,0.9,'Save As: ');
%ht(2)=text(0.02,0.7,'x vector: ');
%ht(3)=text(0.02,0.5,'Hypothetical difference: ');
set(ht,'FontName','Serif');
set(ht,'FontSize',15);
%hfr=uicontrol('Style','frame','String','What','Position',[35 15 170 170]);
hedittest1=uicontrol('Style','edit','Value','noname.frm','Position',[170 195 135 20]);
%hedittest2=uicontrol('Style','edit','Position',[170 155 135 20]);
%hchb=uicontrol('Style','checkbox','String','constant','Value','1','Position',[229 115 79 22]);
set(hedittest1,'BackgroundColor',[1 1 1]);
%set(hedittest2,'BackgroundColor',[1 1 1]);
%set(hchb,'BackgroundColor',[1 1 1]);
hpb=uicontrol('Style','pushbutton','String','OK','Callback','sg1p9a','Position',[340 15 40 27]);
