f6p3p5=figure('Name','Chi-square homogeneity test','NumberTitle','off',...
'Position',[12 12 490 250],'Resize','off');
set(f6p3p5,'MenuBar','none');
axis('off');
ht=[];
ht(1)=text(0.02,0.9,'Data vector 1: ');
ht(2)=text(0.02,0.7,'Data vector 2: ');
set(ht,'FontName','Serif');set(ht,'FontSize',12);
hedittest1=uicontrol('Style','edit','Position',[170 195 175 20]);
hedittest2=uicontrol('Style','edit','Position',[170 157 175 20]);
set(hedittest1,'BackgroundColor',[1 1 1]);
set(hedittest2,'BackgroundColor',[1 1 1]);
hchb1=uicontrol('Style','text','String','Classify according to vector values','Value',0,'Position',[70 125 260 22]);
%hchb1=uicontrol('Style','checkbox','String','Classify according to vector values','Value',0,'Position',[70 125 260 22]);
set(hchb1,'BackgroundColor',[1 1 1]);
%hpb=
uicontrol('Style','pushbutton','String','OK','Callback','sg6p3p5a','Position',[340 15 40 27]);
