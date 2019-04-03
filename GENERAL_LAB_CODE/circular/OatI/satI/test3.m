f2=figure('Name','Simple Statistics','NumberTitle','off',...
'Position',[2 2 220 290],'Resize','off');
%hradio1=uicontrol('Style','radiobutton','String','Print','Position',[70 210 150 30])
%hradio2=uicontrol('Style','radiobutton','String','Print to file','Position',[70 180 150 30])
%hradio3=uicontrol('Style','radiobutton','String','What','Position',[70 150 150 30])
axis('off')
text(0.25,0.8,'Variable');
%hpop=uicontrol('Style','popupmenu','String','Variable','Position',[170 20 90 80])
hedittest=uicontrol('Style','edit','Position',[130 80 40 20],'Callback','dohedit')
