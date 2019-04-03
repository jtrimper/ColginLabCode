function [p1,p2,t1,t2]=s1006(s1,s2)
t1=0; t2=0;
% välj slump vald dörr
if (rand<0.5),
  if (s1>0),
    s1=s1-1;
  else
    t1=1;
  end
else
  if (s2>0),
    s2=s2-1;
  else
    t2=1;
  end
end
% återvänd till slumpm vald dörr 
if (rand<0.5),
    s1=s1+1;
else
    s2=s2+1;
end
p1=s1; p2=s2;
end;
