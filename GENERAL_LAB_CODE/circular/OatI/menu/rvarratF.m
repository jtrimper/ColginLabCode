
v2=var1(y); v1=var1(xc);
%[R,n,p,h,test]=kruswall(y,xc);
p1=1-fcdf(v1/v2,length(xc)-1,length(y)-1);
p2=1-fcdf(v2/v1,length(y)-1,length(xc)-1);
p=2*min(p1,p2);
test=dotest(p);
fvarF=figure('Name','Variance ratio F-test','NumberTitle','off','Position',[12 12 390 250],'Resize','off');
set(f6p3p1,'MenuBar','none');axis('off'); 
yip=[185,155,125,90,60,30];
uicontrol('Style','frame','Position',[18 15 295 206],'Backgroundcolor',Bgc);
uicontrol('Style','pushbutton','String','OK','Callback','close(fvarF)','Position',[340 15 40 27],'BackgroundColor',OKBgc);



%uicontrol('Style','text','String',num2str(R),'Position',[75 yip(3) 180 20],'BackgroundColor',Bgc2);
uicontrol('Style','text','String',num2str(v1/v2),'Position',[175 yip(4) 80 20],'BackgroundColor',Bgc2);
uicontrol('Style','text','String',num2str(p),'Position',[175 yip(5) 80 20],'BackgroundColor',Bgc2);
uicontrol('Style','text','String',test,'Position',[175 yip(6) 80 20],'BackgroundColor',Bgc2);
%uicontrol('Style','text','String','Ranksum','Position',[20 yip(3) 60 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);
uicontrol('Style','text','String','var1/var2:','Position',[20 yip(4) 150 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);
uicontrol('Style','text','String',['P(F(' num2str(length(xc)-1) ',' num2str(length(y)-1) ')>var1/var2):'],'Position',[20 yip(5) 150 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);
uicontrol('Style','text','String','Test:','Position',[20 yip(6) 150 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);




