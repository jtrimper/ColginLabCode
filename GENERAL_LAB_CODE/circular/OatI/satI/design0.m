function [X]=design(Z)
[n,r]=size(Z);
for j=1:r,
grps(j)=0;
for i=1:n,
 l=Z(i,j);
 defok='false';
 for k=1:grps(j),
   if (l==grp(k,j)), defok='true'; end
 end
 if (defok(1:4)=='fals'),
   grps(j)=grps(j)+1;
   grp(grps(j),j)=l;
 end
end
q=cumsum(grps)
for i=1:n,
 l=Z(i,j);
 X(i,1)=1;
 for k=1:grps(j),
   if (l==grp(k,j)), 
     for s=2:k, 
      if (j==1), X(i,s)=1; end
      if (j>1), X(i,q(j-1)+s-1)=1; end
     end 
   end
 end
end
end
end


