load ric.dat
X=ric;
I0=2; J0=2; K0=2
logX=log(X);
for i=1:I0
 for j=1:J0 
  z(i,j)=0.0;
  for k=1:K0
    z(i,j)=z(i,j)+X((i-1)*J0*K0+(j-1)*K0+k)
  end
  z(i,j)=z(i,j)/K0;
 end
end
zpp=0.0;
 for j=1:J0 
  for i=1:I0
   zpp=zpp+z(i,j);
  end
 end
 for i=1:I0 
  zip(i)=0.0;
  for j=1:J0
   zip(i)=zip(i)+z(i,j);
  end
 end
 for j=1:J0 
  zpj(j)=0.0;
  for i=1:I0
   zpj(j)=zpj(j)+z(i,j);
  end
 end
for i=1:I0
for j=1:J0
for k=1:K0
 U((i-1)*J0*K0+(j-1)*K0+k)=log(zip(i))+log(zpj(j))-log(zpp);
end
end
end





