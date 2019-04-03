f6p5p1b=figure('Name','Help','NumberTitle','off',...
'Position',[230 210 400 220],'Resize','off');
set(f6p5p1b,'MenuBar','none');
axis('off');
ht=[];
ht(1)=text(0.02,0.9,'An interval based on Fisher and Lewis (1983)');
ht(2)=text(0.02,0.80,'can be used for unknown distributions. It is');
ht(3)=text(0.02,0.70,'based on the CLT and requires a fair sample size.');
ht(4)=text(0.02,0.50,'An interval based on Upton (1986) can be used when');
ht(5)=text(0.02,0.40,'von Mises-ness has been adequately checked. It is');
ht(6)=text(0.02,0.30,'based on an approximation of the likelihood ratio test.');
set(ht,'FontName','Serif');
set(ht,'FontSize',15);
%hfr=uicontrol('Style','frame','String','What','Position',[35 15 170 170]);
%hedittest1=uicontrol('Style','edit','Position',[170 195 175 20]);
%hedittest2=uicontrol('Style','edit','Position',[50 90 40 20]);
%set(hedittest1,'BackgroundColor',[1 1 1]);
%set(hedittest2,'BackgroundColor',[1 1 1]);
%hchb1=uicontrol('Style','checkbox','String','Chebyshev','Value','0','Position',[270 145 95 22]);
%hpb1=uicontrol('Style','pushbutton','String','Help','Callback','sg6p5p1a','Position',[370 145 40 27]);
%hchb2=uicontrol('Style','checkbox','String','Normality','Value','1','Position',[270 115 95 22]);
%hpb2=uicontrol('Style','pushbutton','String','Help','Callback','sg6p5p1a','Position',[370 115 40 27]);
%set(hchb1,'BackgroundColor',[1 1 1]);
%set(hchb2,'BackgroundColor',[1 1 1]);
hpb=uicontrol('Style','pushbutton','String','OK','Callback','ht=[]; close(f6p5p1b)','Position',[340 15 40 27]);