f6p5p3=figure('Name','Mean axis (circular)','NumberTitle','off',...
'Position',[2 2 490 250],'Resize','off');
set(f6p5p3,'MenuBar','none');
axis('off');
ht=[];
ht(1)=text(0.02,0.9,'Data vector: ');
ht(2)=text(0.12,0.7,' % confidence interval: ');
set(ht,'FontName','Serif');
set(ht,'FontSize',13);
%hfr=uicontrol('Style','frame','String','What','Position',[35 15 170 170]);
hedittest1=uicontrol('Style','edit','Position',[170 195 175 20]);
hedittest2=uicontrol('Style','edit','Position',[70 157 35 20]);
set(hedittest1,'BackgroundColor',[1 1 1]);
set(hedittest2,'BackgroundColor',[1 1 1]);
hchb1=uicontrol('Style','checkbox','String','Prentice','Value','0','Position',[70 125 150 22]);
%hpb1=uicontrol('Style','pushbutton','String','Help','Callback','sg6p5p2b','Position',[400 195 40 27]);
hchb2=uicontrol('Style','checkbox','String','Holmquist 1','Value','1','Position',[70 95 150 22]);
hchb3=uicontrol('Style','checkbox','String','Holmquist 2','Value','1','Position',[70 65 150 22]);
set(hchb1,'BackgroundColor',[1 1 1]);
set(hchb2,'BackgroundColor',[1 1 1]);
set(hchb3,'BackgroundColor',[1 1 1]);
hpb=uicontrol('Style','pushbutton','String','OK','Callback','sg6p5p3a','Position',[340 15 40 27]);
