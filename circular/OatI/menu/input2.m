%if FigName=='', FigName='What?'; end
%if isempty(FigName), FigName='What?'; end
if isempty(FigName), FigName='What?'; end
fig=figure('Name',FigName,'NumberTitle','off','Position',[2 2 490 250],'Resize','off');
set(fig,'MenuBar','none');
axis('off');
ht=[];
ht(1)=text(0.02,0.9,'x vector: ');
ht(2)=text(0.02,0.7,'y vector: ');
set(ht,'FontName','Serif');
set(ht,'FontSize',16);
hedittext1=uicontrol('Style','edit','Position',[170 195 175 20]);
hedittext2=uicontrol('Style','edit','Position',[170 157 175 20]);
set(hedittext1,'BackgroundColor',[1 1 1]);
set(hedittext2,'BackgroundColor',[1 1 1]);
%hpb1=uicontrol('Style','pushbutton','String','Help','Callback','sg6p3p3b','Position',[400 195 40 27]);
hpb=uicontrol('Style','pushbutton','String','OK','Callback','input2a','Position',[340 15 40 27]);
%hpb=uicontrol('Style','pushbutton','String','OK','Callback',mCallback,'Position',[340 15 40 27]);
