data1=get(hedittest1,'String'); 
data2=get(hedittest2,'String'); 
%str=get(hedittest2,'String'); 
figure(f6p3p5)
axis('off');
eval(['[v1]=valuesof(' data1 ');']);
eval(['[v2]=valuesof(' data2 ');']);
v=valunion(v1,v2);
eval(['[n1]=nofcases(' data1 ',v,''equal'');']);
eval(['[n2]=nofcases(' data2 ',v,''equal'');']);
X=[n1;n2];[Q,df]=chi2(X);c=chi2pct(0.05,df);
uicontrol('Style','text','String',['Q=' num2str(Q) ],'Position',[170 95 145 20]);
uicontrol('Style','text','String',['df=' num2str(df)],'Position',[170 65 145 20]);
uicontrol('Style','text','String',['5% critical level=' num2str(c)],'Position',[170 35 145 20]);
%set(ht,'FontName','Serif'); set(ht,'FontSize',12);

