function [p]=wsrpmf(k,n)
%
%
[r,c]=size(k);
for j1=1:r,
for j2=1:c,
j=k(j1,j2);
p(j1,j2)=0.0;
if n>3,
  if (j<-n*(n-3)/2),
    p(j1,j2)=wsrpmf(j+n,n-1)/2;
  end
  if ((j>=-n*(n-3)/2)&(j<=n*(n-3)/2)),
    p(j1,j2)=(wsrpmf(j-n,n-1)+wsrpmf(j+n,n-1))/2;
  end
  if (j>n*(n-3)/2),
    p(j1,j2)=wsrpmf(j-n,n-1)/2;
  end
else
  if (abs(j)==2),
    p(j1,j2)=1/2^n;
  end
  if (abs(j)==4),
    p(j1,j2)=1/2^n;
  end
  if (abs(j)==6),
    p(j1,j2)=1/2^n;
  end
  if (j==0),
    p(j1,j2)=2/2^n;
  end
end
end
end
end
