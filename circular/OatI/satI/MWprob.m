function p=MWprob(u0,m,n)
[a,b]=size(u0);
for i=1:a,
for j=1:b,
u=u0(i,j);
if u<0,
  if (m>=0)&(n>=0), p=0; end
elseif m==0,
  if u==0, p=1; end
  if (u>0)&(n>=1), p=0; end
elseif n==0,
  if u==0, p=1; end
  if (u>0)&(m>=1), p=0; end
else
  p(i,j)=(m/(m+n))*MWprob(u,m-1,n)+(n/(m+n))*MWprob(u-m,m,n-1);
end
end
end
