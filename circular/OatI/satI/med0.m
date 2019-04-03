function [m]=median1(M,level)
%
% CALL median(x,grps)
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., University of Lund.
[n cm]=size(M);
if (nargin==1), 
 level=1*ones(length(M),1);
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
[rm cm]=size(M);
for j=1:grps,
  Ant(j)=0.0; C(j)=0.0; N(j)=0; C2(j)=0.0;
end
for i=1:rm,
  if (finite(M(i))),
    for j=1:grps,
       if level(i)==grp(j),
         Ant(j)=Ant(j)+1;
         V(Ant(j),j)=M(i);
         N(j)=N(j)+1.0;
       end
    end
  end
end;
for i=1:grps,
  VV=[];
  for j=1:Ant(i),
    VV(j)=V(j,i);
  end;
  m(i)=median(VV);
end;
end
