for k=1:50,
[p1,p2,t1,t2]=s1006(2,2);
for i=1:100,
    t1=0; t2=0;
   [p1,p2,t1,t2]=s1006(p1,p2);
   if ((t1==1)|(t2==1)),
      N=i
      break
   end
end;
nn(k)=N;
end
mean(nn)

