function [d]=nofcases(x,f,typ,level)
%
%
  n=length(x);
  [m,two]=size(f);
  if ((m==1)&(two>1)),
    f=f';
    [m,two]=size(f);
  end
  if (two==1),
    if (typ(1:5)=='equal'), g=[f-10^3*eps,f]; end
    if (typ(1:5)=='split'), g=[[-Inf;f],[f;Inf]]; end
  end
  [m,two]=size(g);
%  d=zeros(1,m);
n=length(x);
if (nargin<4), 
 level=1*ones(length(x),1);
end
grps=0;
for i=1:n,
 l=level(i);
 defok='false';
 for k=1:grps,
   if (l==grp(k)), defok='true'; end
 end
 if (defok(1:4)=='fals'),
   grps=grps+1;
   grp(grps)=l;
 end
end
[rm cm]=size(x);
for j=1:grps,
  for k=1:m,
    d(j,k)=0.0;
  end
end
for i=1:rm,
  if (finite(x(i))),
    for j=1:grps,
       if level(i)==grp(j),
%         C(j)=C(j)+x(i); 
         for k=1:m,
%         for i=1:n,
            if ((g(k,1)<x(i))&(x(i)<=g(k,2))),
            d(j,k)=d(j,k)+1;
          end
         end
%         dstar(j)=n-sum(d);
       end
    end
  end
end;
%
end
