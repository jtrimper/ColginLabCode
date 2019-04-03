f6p5p2=figure('Name','Select','NumberTitle','off',...
'Position',[2 100 500 150],'Resize','off');
%'Position',[2 2 590 350],'Resize','off');
set(f6p5p2,'MenuBar','none');
axis('off');
ht=[];
ht(1)=text(0.02,0.68,'Use variable');
ht(2)=text(0.02,0.46,'with criteria ');
ht(3)=text(0.02,0.20,'as');
ht(4)=text(0.45,0.20,'and sample ');
set(ht,'FontName','Serif');
set(ht,'FontSize',11);
%hfr=uicontrol('Style','frame','String','What','Position',[35 15 170 170]);
hedit1=uicontrol('Style','edit','String','','Position',[90 30 140 20]);
hedit3=uicontrol('Style','edit','String','sample1','Position',[300 30 130 20]);
hedit2=uicontrol('Style','edit','String','<1000','Position',[277 60 175 20]);
set(hedit1,'BackgroundColor',[1 1 1]);
set(hedit2,'BackgroundColor',[1 1 1]);
set(hedit3,'BackgroundColor',[1 1 1]);
%hchb1=uicontrol('Style','checkbox','String',var(1,:),'Value','1','Position',[20 125 70 22]);
%hpb1=uicontrol('Style','pushbutton','String','Help','Callback','sg6p5p2b','Position',[400 195 40 27]);
%hchbn(1)=uicontrol('Style','checkbox','String','mean length','Value','1','Position',[340 185 95 22]);
%hchbn(2)=uicontrol('Style','checkbox','String','mean dir','Value','0','Position',[340 155 95 22]);
%hchbn(3)=uicontrol('Style','checkbox','String','mean axis','Value','0','Position',[340 125 95 22]);
%hchbn(4)=uicontrol('Style','checkbox','String','axis dir','Value','0','Position',[340 95 95 22]);
[antvar,c]=size(var);
%for i=1:antvar,
%  k=floor((i-1)/7);
%  xi=20+80*k; 
%  yi=185-(i-1)*30+k*7*30;
%%  hchb(i)=uicontrol('Style','radiobutton','String',var(i,:),'Value','0','Position',[xi yi 70 22]);
%  hchb(i)=uicontrol('Style','checkbox','String',var(i,:),'Position',[xi yi 70 22]);
%%  set(hchb(i),'BackgroundColor',[1 1 1]);
%end
popchoice=[var(1,:)];
for i=2:antvar,
%  k=floor((i-1)/7);
  popchoice=[popchoice '|' var(i,:)]; 
%  xi=20+80*k; 
%  yi=185-(i-1)*30+k*7*30;
%  hchb(i)=uicontrol('Style','radiobutton','String',var(i,:),'Value','0','Position',[xi yi 70 22]);
%  hchb(i)=uicontrol('Style','popup','String',,'Position',[xi yi 70 22]);
%  set(hchb(i),'BackgroundColor',[1 1 1]);
end
popchoice=[popchoice '|mean length|mean dir|axis length|axis dir']; 
hpu1=uicontrol('Style','popup','String',popchoice,'Position',[150 87 120 82]);  %27
hpu2=uicontrol('Style','popup','String',popchoice,'Position',[155 57 120 82]);  %27
hpb=uicontrol('Style','pushbutton','String','OK','Callback','selmenua','Position',[450 5 40 27]);
%hchbiu(1)=uicontrol('Style','checkbox','String','LaTeX','Value','0','Position',[390 35 90 22]);
%hchbiu(2)=uicontrol('Style','checkbox','String','Print','Value','0','Position',[390 5 90 22]);


