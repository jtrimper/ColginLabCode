function anova(y,Z)
Z=[1 1;1 2;1 3;2 1;2 2;2 3;3 1;3 2;3 3]
y=[3 5 4 11 10 12 16 21 17]'
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
%n=length(y);
[n,r]=size(Z);
for j=1:r,
grps(j)=0;
for i=1:n,
 l=Z(i,j);
 defok='false';
 for k=1:grps(j),
   if (l==grp(k,j)), defok='true'; end
 end
 if (defok(1:4)=='fals'),
   grps(j)=grps(j)+1;
   grp(grps(j),j)=l;
 end
end
q=cumsum(grps)
for i=1:n,
 l=Z(i,j);
 X(i,1)=1;
 for k=1:grps(j),
   if (l==grp(k,j)), 
     for s=2:k, 
      if (j==1), X(i,s)=1; end
      if (j>1), X(i,q(j-1)+s-1)=1; end
     end 
   end
 end
end
end
%X=[1,1;1,2;1,1;1,2];
%Y=[4;5;4.4;5.2];
Y=y
X
[n p]=size(X);
B=inv(X'*X)*X'*Y
hatY=X*B;
Q0=(hatY-Y)'*(hatY-Y);
df0=trace(eye(n)-X*inv(X'*X)*X');
Q=Y'*Y; Qa=Q-Q0;
df=n; dfa=df-df0;
dfadj=n-1;
Qadj=Y'*(eye(n)-ones(n,1)*ones(1,n)/n)*Y;
Qa=Qadj-Q0; dfa=dfadj-df0;
axis('off')
text(0.5,0.95,'Analysis of Variances (ANOVA)','HorizontalAlignment','center') 
%text(0,0.8,'Source          SS                 df                    MS               F','HorizontalAlignment','left') 
text(0,0.8,'Source','HorizontalAlignment','left') 
text(0.2,0.8,'SS    ','HorizontalAlignment','left') 
text(0.4,0.8,'df    ','HorizontalAlignment','left') 
text(0.6,0.8,'MS    ','HorizontalAlignment','left') 
text(0.8,0.8,'F     ','HorizontalAlignment','left') 
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



