data1=get(hedittest1,'String'); data2=get(hedittest2,'String');
nmmm=0;
%, data1=X(:,strmatch(data1,var)); end;
if (strmatch(data1,var)>0)&(strmatch(data2,var)>0)
%if strmatch(data2,var)>0, data2=X(:,strmatch(data2,var));
  nmmm=1;
  eval(['[t df]=ttest(X(:,strmatch(data1,var)),X(:,strmatch(data2,var)),' m0str ');']);
end;
m0str=get(hedittest3,'String'); 
figure(f6p3p1);axis('off');
yip=[yip,90,60,30];
%eval(['[t df]=ttest2(' data1 ',' data2 ',' m0str ');']);
if nmmm==0, eval(['[t df]=ttest(' data1 ',' data2 ',' m0str ');']); end
%pr1=1-tcdf(t,df);
%pr2=2*(1-tcdf(abs(t),df));
%ht(4)=text(0.02,0.3,'t quantity:');
%hedit4=
uicontrol('Style','text','String',num2str(t),'Position',[175 yip(4) 80 20],'BackgroundColor',Bgc2);
%ht(5)=text(0.02,0.1,'Probability:');
%hedit5=
uicontrol('Style','text','String',num2str(1-tcdf(t,df)),'Position',[175 yip(6) 80 20],'BackgroundColor',Bgc2);
uicontrol('Style','text','String',num2str(2*(1-tcdf(abs(t),df))),'Position',[175 yip(5) 80 20],'BackgroundColor',Bgc2);
%ht(4)=text(0.02,0.3,'Probability:');
%set(ht,'FontName','Serif');
%set(ht,'FontSize',15);
uicontrol('Style','text','String','t-quantity:','Position',[20 yip(4) 80 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);
uicontrol('Style','text','String','Probability P(T>t):','Position',[20 yip(6) 130 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);
uicontrol('Style','text','String','Probability 2*P(T>|t|):','Position',[20 yip(5) 130 20],'HorizontalAlignment','Left','BackgroundColor',Bgc,'ForegroundColor',Fgc);
