load ric.dat
X=ric;
I0=2; J0=2; K0=2
zppp=0.0;
 for i=1:I0 
  for j=1:J0
   for k=1:K0
    zppp=zppp+X((i-1)*J0*K0+(j-1)*K0+k);
   end
  end
 end
 for i=1:I0 
  zipp(i)=0.0;
  for j=1:J0
   for k=1:K0
    zipp(i)=zipp(i)+X((i-1)*J0*K0+(j-1)*K0+k);
   end
  end
 end
 for j=1:J0 
  zpjp(j)=0.0;
  for i=1:I0
   for k=1:K0
    zpjp(j)=zpjp(j)+X((i-1)*J0*K0+(j-1)*K0+k);
   end
  end
 end
 for k=1:K0 
  zppk(k)=0.0;
  for j=1:J0
   for i=1:I0
    zppk(k)=zppk(k)+X((i-1)*J0*K0+(j-1)*K0+k);
   end
  end
 end
for i=1:I0
for j=1:J0
for k=1:K0
 U((i-1)*J0*K0+(j-1)*K0+k)=log(zipp(i))+log(zpjp(j))+log(zppk(k))-2*log(zppp);
end
end
end





