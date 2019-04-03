% PARAMETERS
%xtext=0.02;
%ytext=0.9;
%%xtext=0.1;
%%ytext=0.78;
%
if exist('FigName')==0, FigName='What?'; end
fig=figure('Name',FigName,'NumberTitle','off','Position',[2 2 390 250],'Resize','off','MenuBar','none');axis('off');
%ht=[]; ht(1)=text(xtext,ytext,'x vector:');
%set(ht(1),'FontName','Serif');set(ht(1),'FontSize',15);
POSITION=[175 111 80 20;175 85 80 20;175 60 80 20];
uicontrol('Style','frame','Position',[18 15 295 206],'Backgroundcolor',Bgc);
hedittest1=uicontrol('Style','edit','Position',[125 195 175 20],'BackgroundColor',Bgc2,'ForegroundColor',Fgc2);
uicontrol('Style','pushbutton','String','OK','Callback',mCallback,'Position',[340 15 40 27],'BackgroundColor',[1 0 0]);
uicontrol('Style','text','String','x vector: ','Position',[20 195 70 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);
