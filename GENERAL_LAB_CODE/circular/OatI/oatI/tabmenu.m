f6p5p2=figure('Name','Table','NumberTitle','off',...
'Position',[2 2 590 350],'Resize','off');
set(f6p5p2,'MenuBar','none');
axis('off');
ht=[];
ht(1)=text(0.02,0.95,'File name');
ht(2)=text(0.02,0.81,'Save table as ');
ht(3)=text(0.02,0.67,'Variables: ');
set(ht,'FontName','Serif');
set(ht,'FontSize',11);
%hfr=uicontrol('Style','frame','String','What','Position',[35 15 170 170]);
hedit1=uicontrol('Style','edit','Position',[177 295 175 20]);
hedit2=uicontrol('Style','edit','String','table.mat','Position',[177 257 175 20]);
set(hedit1,'BackgroundColor',[1 1 1]);
set(hedit2,'BackgroundColor',[1 1 1]);
%hchb1=uicontrol('Style','checkbox','String',var(1,:),'Value','1','Position',[20 125 70 22]);
%hpb1=uicontrol('Style','pushbutton','String','Help','Callback','sg6p5p2b','Position',[400 195 40 27]);
hchbn(1)=uicontrol('Style','checkbox','String','mean length','Value','1','Position',[340 185 95 22]);
hchbn(2)=uicontrol('Style','checkbox','String','mean dir','Value','0','Position',[340 155 95 22]);
hchbn(3)=uicontrol('Style','checkbox','String','mean axis','Value','0','Position',[340 125 95 22]);
hchbn(4)=uicontrol('Style','checkbox','String','axis dir','Value','0','Position',[340 95 95 22]);
[antvar,c]=size(var);
for i=1:antvar,
  k=floor((i-1)/7);
  xi=20+80*k; 
  yi=185-(i-1)*30+k*7*30;
  hchb(i)=uicontrol('Style','checkbox','String',var(i,:),'Value','1','Position',[xi yi 70 22]);
  set(hchb(i),'BackgroundColor',[1 1 1]);
end
hpb=uicontrol('Style','pushbutton','String','OK','Callback','tabmenua','Position',[340 5 40 27]);
hchbiu(1)=uicontrol('Style','checkbox','String','LaTeX','Value','0','Position',[390 35 90 22]);
hchbiu(2)=uicontrol('Style','checkbox','String','Print','Value','0','Position',[390 5 90 22]);


