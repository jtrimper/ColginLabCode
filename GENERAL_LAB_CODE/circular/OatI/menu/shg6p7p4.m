f6p7p4=figure('Name','RAYMODP','NumberTitle','off',...
'Position',[2 2 390 250],'Resize','off');
set(f6p7p4,'MenuBar','none');
axis('off');
ht=[];
ht(1)=text(0.02,0.9,'Response directions: ');
%ht(2)=text(0.02,0.7,'Regressor directions: ');
set(ht,'FontName','Serif');
set(ht,'FontSize',15);
%hfr=uicontrol('Style','frame','String','What','Position',[35 15 170 170]);
hedittest1=uicontrol('Style','edit','String','x','Position',[198 200 135 20]);
%hedittest2=uicontrol('Style','edit','String','u','Position',[198 160 135 20]);
%hedittest3=uicontrol('Style','edit','Position',[229 115 35 20]);
set(hedittest1,'BackgroundColor',[1 1 1]);
%set(hedittest2,'BackgroundColor',[1 1 1]);
%set(hedittest3,'BackgroundColor',[1 1 1]);
hpb=uicontrol('Style','pushbutton','String','OK','Callback','sg6p7p4a','Position',[340 15 40 27]);
