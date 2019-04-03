f6p3p2=figure('Name','Watson''s U2 test for equal distribution','NumberTitle','off',...
'Position',[2 2 390 250],'Resize','off');
set(f6p3p2,'MenuBar','none');
axis('off');
ht=[];
ht(1)=text(0.02,0.9,'Data vector 1: ');
ht(2)=text(0.02,0.7,'Data vector 2: ');
%ht(3)=text(0.02,0.5,'Hypothetical difference: ');
set(ht,'FontName','Serif');
set(ht,'FontSize',15);
%hfr=uicontrol('Style','frame','String','What','Position',[35 15 170 170]);
hedittest1=uicontrol('Style','edit','Position',[170 195 135 20]);
hedittest2=uicontrol('Style','edit','Position',[170 155 135 20]);
set(hedittest1,'BackgroundColor',[1 1 1]);
set(hedittest2,'BackgroundColor',[1 1 1]);
hpb=uicontrol('Style','pushbutton','String','OK','Callback','sg6p3p2a','Position',[340 15 40 27]);
