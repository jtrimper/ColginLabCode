x=[1:20];
for n=15:15:75,
for g=1:20,
  y(g)=1-hyp(0,g,n,80);
end
plot(x,y)
hold on
text(12-2*n/15-(n-40)/20,y(12-2*n/15)+0.05*(n-40)/25,['0,g,' int2str(n) ',80'])
end
xlabel('g')
title('1-hyp(0,g,n,80)')

