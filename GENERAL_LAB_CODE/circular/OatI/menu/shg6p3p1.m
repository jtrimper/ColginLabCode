f6p3p1=figure('Name','Student''s two sample t-test','NumberTitle','off','Position',[12 12 390 250],'Resize','off');
set(f6p3p1,'MenuBar','none');axis('off'); %ht=[];
yip=[185,155,125];
uicontrol('Style','frame','Position',[18 15 295 206],'Backgroundcolor',Bgc);
%ht(1)=text(0.02,0.9,'Data vector 1: ');
%ht(2)=text(0.02,0.7,'Data vector 2: ');
%ht(3)=text(0.02,0.5,'Hypothetical difference: ');
%set(ht,'FontName','Serif');set(ht,'FontSize',15);
hedittest1=uicontrol('Style','edit','Position',[170 yip(1) 135 20],'BackgroundColor',[1 1 1]);
hedittest2=uicontrol('Style','edit','Position',[170 yip(2) 135 20],'BackgroundColor',[1 1 1]);
hedittest3=uicontrol('Style','edit','String','0','Position',[229 yip(3) 35 20],'BackgroundColor',[1 1 1]);
uicontrol('Style','pushbutton','String','OK','Callback','sg6p3p1f','Position',[340 15 40 27],'BackgroundColor',[1 0 0]);
uicontrol('Style','text','String','Data vector 1:','Position',[20 yip(1) 80 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);
uicontrol('Style','text','String','Data vector 2:','Position',[20 yip(2) 80 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);
uicontrol('Style','text','String','Hypothetical difference: ','Position',[20 yip(3) 140 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);

set(hedittest1,'String',var(Xvarnr,:));
set(hedittest2,'String',var(Yvarnr,:));
