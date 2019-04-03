m0=0;
[Rn,Rp,p,z,test]=wilcoxon(y,m0);
fwilcoxon1=figure('Name','Wilcoxon''s signed rank test','NumberTitle','off','Position',[12 12 390 250],'Resize','off');
set(f6p3p1,'MenuBar','none');axis('off'); 
yip=[185,155,125,90,60,30];
uicontrol('Style','frame','Position',[18 15 295 206],'Backgroundcolor',Bgc);
uicontrol('Style','pushbutton','String','OK','Callback','close(fwilcoxon1)','Position',[340 15 40 27],'BackgroundColor',OKBgc);

uicontrol('Style','text','String',num2str(Rn),'Position',[175 yip(2) 80 20],'BackgroundColor',Bgc2);
uicontrol('Style','text','String',num2str(Rp),'Position',[175 yip(3) 80 20],'BackgroundColor',Bgc2);
uicontrol('Style','text','String',num2str(z),'Position',[175 yip(4) 80 20],'BackgroundColor',Bgc2);
uicontrol('Style','text','String',num2str(p),'Position',[175 yip(5) 80 20],'BackgroundColor',Bgc2);
uicontrol('Style','text','String',test,'Position',[175 yip(6) 80 20],'BackgroundColor',Bgc2);
uicontrol('Style','text','String','Ranksum -','Position',[20 yip(2) 60 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);
uicontrol('Style','text','String','Ranksum +','Position',[20 yip(3) 60 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);
uicontrol('Style','text','String','z:','Position',[20 yip(4) 150 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);
uicontrol('Style','text','String',['Probability P(SB>chi2(' num2str(df) ')):'],'Position',[20 yip(5) 150 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);
uicontrol('Style','text','String','Test:','Position',[20 yip(6) 150 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);

