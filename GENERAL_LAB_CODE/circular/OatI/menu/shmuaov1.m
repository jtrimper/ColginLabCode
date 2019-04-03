faov=figure('Name','One-way analysis of variance','NumberTitle','off','Position',[12 12 390 250],'Resize','off');
set(faov,'MenuBar','none');axis('off'); 
yip=[185,155,125];
uicontrol('Style','frame','Position',[18 15 295 206],'Backgroundcolor',Bgc);
hedittest1=uicontrol('Style','edit','Position',[170 yip(1) 135 20],'BackgroundColor',[1 1 1]);
hedittest2=uicontrol('Style','edit','Position',[170 yip(2) 135 20],'BackgroundColor',[1 1 1]);
uicontrol('Style','text','String','Respons vector:','Position',[20 yip(1) 120 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);
uicontrol('Style','text','String','Category vector:','Position',[20 yip(2) 120 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);
%uicontrol('Style','text','String','Hypothetical difference: ','Position',[20 yip(3) 140 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);

if exist('Xvarnr')==1, set(hedittest1,'String',var(Xvarnr,:)); end
if exist('Yvarnr')==1, set(hedittest2,'String',var(Yvarnr,:)); end

uicontrol('Style','pushbutton','String','OK','Callback','smuaov1f','Position',[340 15 40 27],'BackgroundColor',[1 0 0]);


%uicontrol('Style','pushbutton','String','OK','Callback','data1=get(hedittest1,''String''); data2=get(hedittest2,''String'');nmmm=0,if (strmatch(data1,var)>0)&(strmatch(data2,var)>0),nmmm=1, y=X(:,strmatch(data1,var));xc=X(:,strmatch(data2,var)),end;if nmmm==0,eval([''y=data1; xc=data2;'']);end; close(faov)','Position',[340 15 40 27],'BackgroundColor',[1 0 0]);


