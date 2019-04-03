if isempty(FigName), FigName='What?'; end
fig=figure('Name',FigName,'NumberTitle','off','Position',[2 2 490 250],...
   'Resize','off');
set(fig,'MenuBar','none');
axis('off');
ht=[];
text(0.02,0.98,'Perform a test of the');
text(0.02,0.76,'with groups given by');
ht(1)=text(0.02,0.68,'group vector: ');
ht(2)=text(0.02,0.88,'variable vector: ');
set(ht,'FontName','Serif');
set(ht,'FontSize',16);
hedittext1=uicontrol('Style','edit','Position',[170 157 175 20],...
   'HorizontalAlignment','left');
hedittext2=uicontrol('Style','edit','Position',[170 195 175 20],...
   'HorizontalAlignment','left');
set(hedittext1,'BackgroundColor',[1 1 1]);
set(hedittext2,'BackgroundColor',[1 1 1]);
hpb=uicontrol('Style','pushbutton','String','OK','Callback','input2a',...
   'Position',[340 15 40 27]);
