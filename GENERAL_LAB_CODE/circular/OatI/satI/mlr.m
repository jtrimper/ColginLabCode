function [res]=mlr(y,X)
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., University of Lund.
%
f1=figure('NumberTitle','off','Name','ANOVA Platform','Pointer','arrow','Position',[0 0 450 200]);
g=uimenu('Label','File');
uimenu(g,'Label','Load','Position',1);
uimenu(g,'Label','Home view','Callback','view(3)','Position',4);
uimenu(g,'Label','Print','Callback','print ANOVA','Position',11);
uimenu(g,'Label','Quit','Callback','quit','Position',12);
n=length(y);
Y=y;
[n p]=size(X);
B=inv(X'*X)*X'*Y;
hatY=X*B;
res=Y-hatY;
Q0=(hatY-Y)'*(hatY-Y);
df0=trace(eye(n)-X*inv(X'*X)*X');
Q=Y'*Y; Qa=Q-Q0;
df=n; dfa=df-df0;
Qadj=Y'*(eye(n)-ones(n,1)*ones(1,n)/n)*Y;
dfadj=n-1;
Qa=Qadj-Q0; dfa=dfadj-df0;
c=tpct(0.025,df0)*sqrt(Q0*diag(inv(X'*X))/df0);
axis('off')
text(0.5,0.95,'Analysis of Variances (ANOVA)','HorizontalAlignment','center') 
%text(0,0.8,'Source          SS                 df                    MS               F','HorizontalAlignment','left') 
text(0.0,0.8,'Source  ','HorizontalAlignment','left') 
text(0.2,0.8,'SS      ','HorizontalAlignment','left') 
text(0.4,0.8,'df      ','HorizontalAlignment','left') 
text(0.6,0.8,'MS      ','HorizontalAlignment','left') 
text(0.8,0.8,'F       ','HorizontalAlignment','left') 
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
text(0,0.2,'Total (adj)','HorizontalAlignment','left')
text(0.2,0.2,num2str(Qadj),'HorizontalAlignment','left')
text(0.4,0.2,num2str(dfadj),'HorizontalAlignment','left')
text(0.6,0.2,num2str(Qadj/dfadj),'HorizontalAlignment','left')
%text(-1.2,0,'W','VerticalAlignment','middle','HorizontalAlignment','center')
%f2=figure('NumberTitle','off','Name','Means plot','Pointer','arrow','Position',[380 240 300 280]);
%axis('off')
%meanplot(grp',cumsum(B),c);
%title('Means plot');
%xlabel('Levels');
%ylabel('Values');
%z1=cumsum(B)-c; z2=cumsum(B)+c;
%axis([min(grp)-1 max(grp)+1 0.98*min(z1) 1.02*max(z2)])
f3=figure('NumberTitle','off','Name','Residual plot','Pointer','arrow','Position',[0 270 300 250]);
axis('off')
plot(res,'o');
title('Residual plot');
xlabel('Index');
ylabel('Values');
axis([0 n+1 1.02*min(res) 1.02*max(res)])
end


