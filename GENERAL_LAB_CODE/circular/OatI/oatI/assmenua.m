v=get(hpu,'Value');
if v<=antvar,
  y=X(sample,vnrld(v,loaded));
  yvars=v
else
  y=Ang(sample,1);
end
XX=[];
antsel=0;
xvars=[];
for i=1:antvar,
  v=get(hchb(i),'Value');
  if v>0.5,
    XX=[XX,X(sample,vnrld(i,loaded))];
    antsel=antsel+1;
    xvars=[xvars,i]
  end
end
close(fdes)
[a,b]=size(XX);
if b>2, xc=xcat(XX); end;
if b==2, xc=xcat2(XX(:,1),XX(:,2)); end
if b==1, xc=XX; x=xc; end
if antsel==0, xc=ones(length(y),1); end
%if Describe==1, describe(y,xc); end
%if Describe==2, descrs2(y,xc); end
%%if Describe==3, hist1(y,xc); end
%%if Describe==4, multreg(y,XX); end % multipel regression
%%if Describe==5, glm(y,design(XX)); end % generell anova modell


