%usemenu version 1.1 1999-03-08
%DAT_DIR 2000-11-03
yip=[165,140,115,90,65,40]'-20;
%Bgc=[0.5,0.1,0.3]; Fgc=[1 1 1];
%Bgc=[0.2,0.5,0.3]; Fgc=[1 0.5 0.2]; Bgc2=[0.5 0.8 0.6]; Fgc2=[0 0 0];
if exist('DAT_DIR')==0, DAT_DIR='C:\DAT\'; end;
if exist('TXTFILE_DEF')==0, TXTFILE_DEF=''; end; 
if exist('NOCOLS_DEF')==0, NOCOLS_DEF=23; end;
if exist('CAGECALC')==0, CAGECALC=1; end 
fuse=figure('Name','Use','NumberTitle','off','Position',[100 100 330 180],'Resize','off');
set(fuse,'MenuBar','none'); axis('off');
uicontrol('Style','frame','Position',[17,15,240,155],'Backgroundcolor',Bgc,'Foregroundcolor',Fgc);
uicontrol('Style','text','String','Use file','Position',[20,yip(1),45,20],'HorizontalAlignment','Left','Backgroundcolor',Bgc,'Foregroundcolor',Fgc);
uicontrol('Style','text','String','.txt','Position',[224,yip(1),30,20],'HorizontalAlignment','Left','Backgroundcolor',Bgc,'Foregroundcolor',Fgc);
hedit0=uicontrol('Style','edit','String',DAT_DIR,'Position',[60,yip(1),55,20],'Backgroundcolor',Bgc2,'Foregroundcolor',Fgc2);
%hedit1=uicontrol('Style','edit','String','','Position',[115,yip(1),110,20],'Backgroundcolor',Bgc2,'Foregroundcolor',Fgc2);
hedit1=uicontrol('Style','edit','String',TXTFILE_DEF,'Position',[115,yip(1),110,20],'Backgroundcolor',Bgc2,'Foregroundcolor',Fgc2);

uicontrol('Style','text','String','Number of columns:','Position',[20,yip(2),100,20],'HorizontalAlignment','Left','Backgroundcolor',Bgc,'Foregroundcolor',Fgc);
%hedit2=uicontrol('Style','edit','String','23','Position',[120,yip(2),40,20],'Backgroundcolor',Bgc2,'Foregroundcolor',Fgc2);
hedit2=uicontrol('Style','edit','String',num2str(NOCOLS_DEF),'Position',[120,yip(2),40,20],'Backgroundcolor',Bgc2,'Foregroundcolor',Fgc2);
hedit3=uicontrol('Style','edit','String',['[1:' num2str(NOCOLS_DEF) ']'],'Position',[130,yip(3),70,20],'Backgroundcolor',Bgc2,'Foregroundcolor',Fgc2);
uicontrol('Style','text','String','Calculate directions and concentrations','Position',[20,yip(4),195,20],'HorizontalAlignment','Left','Backgroundcolor',Bgc,'Foregroundcolor',Fgc);
%hchb=uicontrol('Style','checkbox','Value',1,'Position',[210,yip(4),20,20],'Backgroundcolor',Bgc2,'Foregroundcolor',Fgc2);
hchb=uicontrol('Style','checkbox','Value',CAGECALC,'Position',[210,yip(4),20,20],'Backgroundcolor',Bgc2,'Foregroundcolor',Fgc2);

uicontrol('Style','text','String','of the cage in columns 12-','Position',[20,yip(5),140,20],'HorizontalAlignment','Left','Backgroundcolor',Bgc,'Foregroundcolor',Fgc);
hedit4=uicontrol('Style','edit','String','23','Position',[150,yip(5),70,20],'Backgroundcolor',Bgc2,'Foregroundcolor',Fgc2);
%hedit4=uicontrol('Style','edit','String',NOCOLS_DEF,'Position',[150,yip(5),70,20],'Backgroundcolor',Bgc2,'Foregroundcolor',Fgc2);

uicontrol('Style','text','String','and direction of first sector in column','Position',[20,yip(6),180,20],'HorizontalAlignment','Left','Backgroundcolor',Bgc,'Foregroundcolor',Fgc);
hedit5=uicontrol('Style','edit','String','11','Position',[200,yip(6),30,20],'Backgroundcolor',Bgc2,'Foregroundcolor',Fgc2);
hpb=uicontrol('Style','pushbutton','String','OK','Backgroundcolor',[1 0 0],'Callback','usemenua','Position',[280 5 40 27]);
