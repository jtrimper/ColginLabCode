% GLM(X,Y)
% spin
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., University of Lund.
%
az=-37.5; el=30;
%figure
f1=figure('NumberTitle','off','Name','ANOVA Platform','Pointer','arrow');
g=uimenu('Label','File');
uimenu(g,'Label','Load','Position',1);
uimenu(g,'Label','Save','Position',2);
uimenu(g,'Label','Save As ...','Position',3);
uimenu(g,'Label','Home view','Callback','view(3)','Position',4);
uimenu(g,'Label','Rotate az+','Callback','az=az+10; view([az el])','Position',5);
uimenu(g,'Label','Rotate az-','Callback','az=az-10; view([az el])','Position',6);
uimenu(g,'Label','Rotate el+','Callback','el=el+10; view([az el])','Position',7);
uimenu(g,'Label','Rotate el-','Callback','el=el-10; view([az el])','Position',8);
uimenu(g,'Label','Rotate az','Callback','for i=1:50, az=az-2; view([az el]), drawnow, end','Position',9);
uimenu(g,'Label','Rotate el','Callback','for i=1:50, el=el-2; view([az el]), drawnow, end','Position',10);
uimenu(g,'Label','Print','Callback','print ANOVA','Position',11);
uimenu(g,'Label','Quit','Callback','quit','Position',12);
%load test.dat
%X=test;  
%[rows cols]=size(X);
%plot3(X(:,1),X(:,2),X(:,3),'wo')
X=[1,1;1,2;1,1;1,2];
Y=[4;5;4.4;5.2];
[n p]=size(X);
B=inv(X'*X)*X'*Y;
hatY=X*B;
Q0=(hatY-Y)'*(hatY-Y);
df0=trace(eye(n)-X*inv(X'*X)*X');
Q=Y'*Y; Qa=Q-Q0;
df=n; dfa=df-df0;
axis('off')
text(0.5,0.95,'Analysis of Variances (ANOVA)','HorizontalAlignment','center') 
text(0,0.8,'Source          SS                 df                    MS               F','HorizontalAlignment','left') 
%text(1.2,0,'E','VerticalAlignment','middle','HorizontalAlignment','center')
text(0,0.7,'Model','HorizontalAlignment','left')
text(0.2,0.7,num2str(Qa),'HorizontalAlignment','left')
text(0.4,0.7,num2str(dfa),'HorizontalAlignment','left')
text(0.6,0.7,num2str(Qa/dfa),'HorizontalAlignment','left')
text(0.8,0.7,num2str(Qa*df0/(dfa*Q0)),'HorizontalAlignment','left')
text(0,0.6,'Residual','HorizontalAlignment','left')
text(0.2,0.6,num2str(Q0),'HorizontalAlignment','left')
text(0.4,0.6,num2str(df0),'HorizontalAlignment','left')
text(0.6,0.6,num2str(Q0/df0),'HorizontalAlignment','left')
text(0,0.4,'Total','HorizontalAlignment','left')
text(0.2,0.4,num2str(Q),'HorizontalAlignment','left')
text(0.4,0.4,num2str(df),'HorizontalAlignment','left')
text(0.6,0.4,num2str(Q/df),'HorizontalAlignment','left')
%text(-1.2,0,'W','VerticalAlignment','middle','HorizontalAlignment','center')
%S=8;
%Yd=X(:,2);
%for i=2:S,
% Yd=[Yd,X(:,i+1)];
%end
%%%%%mesh(tid,Kk,UU)
%%contour(tid,Kk,UU)
%f=



