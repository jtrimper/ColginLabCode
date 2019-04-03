f2=figure('Name','Wind','NumberTitle','off',...
'Position',[2 2 190 250],'Resize','off');
set(f2,'MenuBar','none');
axis('off');
ht1=[]; %  ht2=[];
ht1(1)=text(0.02,0.9,'Wind direction:');
ht1(2)=text(0.02,0.7,'Wind speed:');
hedittest1=uicontrol('Style','edit','Position',[140 195 35 20]);
hedittest2=uicontrol('Style','edit','Position',[140 155 35 20]);
hpb=uicontrol('Style','pushbutton','String','OK','Callback','shg2p11f','Position',[145 10 40 27]);
