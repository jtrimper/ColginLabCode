f6p2p1=figure('Name','Student''s t-test','NumberTitle','off',...
'Position',[2 2 390 250],'Resize','off');
set(f6p2p1,'MenuBar','none');
axis('off');
ht=[];
ht(1)=text(0.02,0.9,'Data vector: ');
ht(2)=text(0.02,0.7,'Hypothetical mean: ');
set(ht,'FontName','Serif');
set(ht,'FontSize',15);
hedittest1=uicontrol('Style','edit','Position',[195 195 75 20]);
hedittest2=uicontrol('Style','edit','Callback','sg6p2p1f','Position',[195 155 35 20]);
