function  [U,T1]=branch(p,N,M)
for k=1:M,
x=50;
X=[x]; T=0;
for i=1:N,
  x=sum(randgeom(p,x));
  if (x==0)&(T==0), T=i; end
  X=[X,x];
end
U=X;
T1(k)=T;
end
end
