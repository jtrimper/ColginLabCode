f2p10=figure('Name','Home','NumberTitle','off',...
'Position',[2 2 190 250],'Resize','off');
set(f2p10,'MenuBar','none');
axis('off');
ht=[];
%htextcount=htextcount+1
ht(1)=text(0.02,0.9,'Home direction: ');
set(ht,'FontName','Serif');
set(ht,'FontSize',16);
hedittest1=uicontrol('Style','edit','Callback','shg2p10f','Position',[145 195 30 20]);
