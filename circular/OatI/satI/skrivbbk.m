function [a]=skrivbbk(g,n,N)
for i=0:g,
 a(i+1,1)=i;
 a(i+1,2)=bbk(i,g,n,N);
end
