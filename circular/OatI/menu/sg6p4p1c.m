tabfg=figure('Name','Table','NumberTitle','off','Position',[100 180 470 300]); 
axis('off')
if v>0.5
eval(['y=' datay ';']);
n=length(y);
XX=ones(n,1);
eval(['XX=[XX,' datax '];']);
  Q=y'*y;
  df=n;
  Qadj=(y-mean(y))'*(y-mean(y));
  dfadj=n-1;
  Q0=(y-XX*[a,b]')'*(y-XX*[a,b]');
%  Q0=y'*(eye(n)-XX*inv(XX'*XX)*XX')*y;
  df0=n-2; % rank(eye(n)-XX*inv(XX'*XX)*XX'); % n-2;
  %Qa=Qadj-Q0;
  mm=mean(XX(:,2));
  Qa=b^2*(XX(:,2)-mm)'*(XX(:,2)-mm);
  dfa=1;
  F=Qa/(Q0/df0);
else
  %
end
text(0.5,0.95,'Analysis of Variances (ANOVA)','HorizontalAlignment','center') 
%text(0,0.8,'Source          SS                 df                    MS               F','HorizontalAlignment','left') 
text(0.0,0.8,'Source  ','HorizontalAlignment','left') 
text(0.2,0.8,'SS      ','HorizontalAlignment','left') 
text(0.4,0.8,'df      ','HorizontalAlignment','left') 
text(0.5,0.8,'MS      ','HorizontalAlignment','left') 
text(0.7,0.8,'F       ','HorizontalAlignment','left') 
text(0.9,0.8,'P       ','HorizontalAlignment','left') 
%%text(1.2,0,'E','VerticalAlignment','middle','HorizontalAlignment','center')
text(0,0.7,'Model','HorizontalAlignment','left')
text(0.2,0.7,num2str(Qa),'HorizontalAlignment','left')
text(0.4,0.7,num2str(dfa),'HorizontalAlignment','left')
text(0.5,0.7,num2str(Qa/dfa),'HorizontalAlignment','left')
text(0.7,0.7,num2str(F),'HorizontalAlignment','left')
text(0.9,0.7,num2str(1-fcdf(F,dfa,df0)),'HorizontalAlignment','left')
text(0,0.6,'Residual','HorizontalAlignment','left')
text(0.2,0.6,num2str(Q0),'HorizontalAlignment','left')
text(0.4,0.6,num2str(df0),'HorizontalAlignment','left')
text(0.5,0.6,num2str(s^2),'HorizontalAlignment','left')
text(0,0.47,'Total','HorizontalAlignment','left')
text(0.2,0.47,num2str(Q),'HorizontalAlignment','left')
text(0.4,0.47,num2str(df),'HorizontalAlignment','left')
text(0.5,0.47,num2str(Q/df),'HorizontalAlignment','left')
text(0,0.35,'Total (adj)','HorizontalAlignment','left')
text(0.2,0.35,num2str(Qadj),'HorizontalAlignment','left')
text(0.4,0.35,num2str(dfadj),'HorizontalAlignment','left')
text(0.5,0.35,num2str(Qadj/dfadj),'HorizontalAlignment','left')
text(0.0,0.2,'Source  ','HorizontalAlignment','left') 
text(0.2,0.2,'Estimate ','HorizontalAlignment','left') 
text(0.4,0.2,'df      ','HorizontalAlignment','left') 
text(0.5,0.2,'Std error','HorizontalAlignment','left') 
text(0.7,0.2,'t       ','HorizontalAlignment','left') 
text(0.9,0.2,'2*P(T>t)','HorizontalAlignment','left') 
text(0,0.1,'Slope','HorizontalAlignment','left')
text(0.2,0.1,num2str(b),'HorizontalAlignment','left')
text(0.4,0.1,'1','HorizontalAlignment','left')
t=s/sqrt((XX(:,2)-mm)'*(XX(:,2)-mm));
text(0.5,0.1,num2str(t),'HorizontalAlignment','left')
t=b/t;
text(0.7,0.1,num2str(t),'HorizontalAlignment','left')
text(0.9,0.1,num2str(2*(1-tcdf(abs(t),df0))),'HorizontalAlignment','left')
text(0,0.0,'Intercept','HorizontalAlignment','left')
text(0.2,0.0,num2str(a),'HorizontalAlignment','left')
text(0.4,0.0,'1','HorizontalAlignment','left')
t=s*sqrt(1/n+mm^2/((XX(:,2)-mm)'*(XX(:,2)-mm)));
text(0.5,0.0,num2str(t),'HorizontalAlignment','left')
t=a/t;
text(0.7,0.0,num2str(t),'HorizontalAlignment','left')
text(0.9,0.0,num2str(2*(1-tcdf(abs(t),df0))),'HorizontalAlignment','left')
