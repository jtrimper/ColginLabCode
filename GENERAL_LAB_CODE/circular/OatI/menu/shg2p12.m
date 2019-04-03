f2p12=figure('Name','gtext','NumberTitle','off',...
'Position',[2 2 290 250],'Resize','off');
set(f2p10,'MenuBar','none');
axis('off');
%ht=[];
htextcount=htextcount+1
htext(htextcount)=text(0.02,0.9,'Text: ');
%set(ht,'FontName','Serif');
set(htext,'FontSize',FontSize);
hedittest1=uicontrol('Style','edit','Callback','shg2p12f','Position',[145 195 250 20]);
