f3p2=figure('Name','DOUBLEPLOT','NumberTitle','off',...
'Position',[2 2 390 250],'Resize','off');
set(f3p2,'MenuBar','none');
axis('off');
ht=[];
ht(1)=text(0.02,0.9,'Vanishing direction: ');
ht(2)=text(0.02,0.5,'Position: ');
ht(3)=text(0.02,0.7,'One minute direction: ');
set(ht,'FontName','Serif');
set(ht,'FontSize',15);
%hfr=uicontrol('Style','frame','String','What','Position',[35 15 170 170]);
hedittest1=uicontrol('Style','edit','String','Y(:,11)','Position',[199 195 135 20]);
hedittest2=uicontrol('Style','edit','String','Y(:,12)','Position',[199 155 135 20]);
hedittest3=uicontrol('Style','edit','String','0','Position',[190 115 135 20]);
%hedittest3=uicontrol('Style','edit','Position',[229 115 35 20]);
set(hedittest1,'BackgroundColor',[1 1 1]);
set(hedittest2,'BackgroundColor',[1 1 1]);
set(hedittest3,'BackgroundColor',[1 1 1]);
hpb=uicontrol('Style','pushbutton','String','OK','Callback','sg3p2aa','Position',[340 15 40 27]);
