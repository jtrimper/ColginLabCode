f1p1=figure('Name','Copy','NumberTitle','off',...
'Position',[10 50 300 110],'Resize','off');
set(f1p1,'MenuBar','none');
axis('off');
ht=[];
ht(1)=text(0.02,0.9,'XL file: \DAT\');
ht(2)=text(0.8,0.9,'.TXT');
set(ht,'FontName','Serif');
set(ht,'FontSize',16);
%hedittest1=uicontrol('Style','edit','Position',[135 195 35 20]);
hedittest2=uicontrol('Style','edit','Callback','shg1p1f','Position',[154 80 67 20]);
%hedittest2=uicontrol('Style','slider','Position',[20 10 100 25]);
