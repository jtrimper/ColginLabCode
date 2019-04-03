[u,n]=pcorr(y,xc);
t=sqrt(n-2)*u/sqrt(1-u^ 2);
p=2*(1-tcdf(abs(t),n-2)); df=n-2;
test=dotest(p);
fcorr=figure('Name','Pearson''s product moment correlation','NumberTitle','off','Position',[12 12 390 250],'Resize','off');
set(f6p3p1,'MenuBar','none');axis('off'); 
yip=[185,155,125,90,60,30];
uicontrol('Style','frame','Position',[18 15 295 206],'Backgroundcolor',Bgc);
uicontrol('Style','pushbutton','String','OK','Callback','close(fcorr)','Position',[340 15 40 27],'BackgroundColor',OKBgc);


uicontrol('Style','text','String',num2str(u),'Position',[175 yip(3) 80 20],'BackgroundColor',Bgc2);
uicontrol('Style','text','String',num2str(n),'Position',[175 yip(4) 80 20],'BackgroundColor',Bgc2);
uicontrol('Style','text','String',num2str(p),'Position',[175 yip(5) 80 20],'BackgroundColor',Bgc2);
uicontrol('Style','text','String',test,'Position',[175 yip(6) 80 20],'BackgroundColor',Bgc2);
uicontrol('Style','text','String','Correlation','Position',[20 yip(3) 150 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);
uicontrol('Style','text','String','n:','Position',[20 yip(4) 150 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);
uicontrol('Style','text','String',['2*P(T>t(' num2str(df) ')):'],'Position',[20 yip(5) 150 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);
uicontrol('Style','text','String','Test:','Position',[20 yip(6) 150 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);
