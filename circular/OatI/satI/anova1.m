function [res]=anova1(y,level)
%
% CALL: [res]=anova1(y,x)
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., Lund University.
%
az=-37.5; el=30;
%figure
f1=figure('NumberTitle','off','Name','ANOVA Platform','Pointer','arrow','Position',[0 0 450 200]);
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
n=length(y);
grps=0;
for i=1:n,
 l=level(i);
 defok='false';
 for k=1:grps,
   if (l==grp(k)), defok='true'; end
 end
 if (defok(1:4)=='fals'),
   grps=grps+1;
   grp(grps)=l;
 end
end
%grp
for i=1:n,
 l=level(i);
 for k=1:grps,
   if (l==grp(k)), 
     for j=1:k, X(i,j)=1; end 
   end
 end
end
%X=[1,1;1,2;1,1;1,2];
%Y=[4;5;4.4;5.2];
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
F=Qa*df0/(dfa*Q0);
axis('off')
text(0.5,0.95,'Analysis of Variances (ANOVA)','HorizontalAlignment','center') 
%text(0,0.8,'Source          SS                 df                    MS               F','HorizontalAlignment','left') 
text(0.0,0.8,'Source  ','HorizontalAlignment','left') 
text(0.2,0.8,'SS      ','HorizontalAlignment','left') 
text(0.4,0.8,'df      ','HorizontalAlignment','left') 
text(0.6,0.8,'MS      ','HorizontalAlignment','left') 
text(0.8,0.8,'F       ','HorizontalAlignment','left') 
text(1.0,0.8,'P       ','HorizontalAlignment','left') 
%text(1.2,0,'E','VerticalAlignment','middle','HorizontalAlignment','center')
text(0,0.7,'Model','HorizontalAlignment','left')
text(0.2,0.7,num2str(Qa),'HorizontalAlignment','left')
text(0.4,0.7,num2str(dfa),'HorizontalAlignment','left')
text(0.6,0.7,num2str(Qa/dfa),'HorizontalAlignment','left')
text(0.8,0.7,num2str(F),'HorizontalAlignment','left')
text(1.0,0.7,num2str(1-fcdf(F,dfa,df0)),'HorizontalAlignment','left')
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
k=0;
while (k~=3),
  k=menu('Choose','Means plot','Residuals plot','Exit');
if (k==1),
  f2=figure('NumberTitle','off','Name','Means plot','Pointer','arrow','Position',[380 240 300 280]);
  axis('off')
  meanplot(grp',cumsum(B),c);
  title('Means plot');
  xlabel('Levels');
  ylabel('Values');
  z1=cumsum(B)-c; z2=cumsum(B)+c;
  axis([min(grp)-1 max(grp)+1 0.98*min(z1) 1.02*max(z2)])
end
if (k==2),
  f3=figure('NumberTitle','off','Name','Residual plot','Pointer','arrow','Position',[0 270 300 250]);
  axis('off')
  plot(res,'o');
  title('Residual plot');
  xlabel('Index');
  ylabel('Values');
  axis([0 n+1 1.02*min(res) 1.02*max(res)])
end
end
close(f3);
close(f2);
close(f1);
end





