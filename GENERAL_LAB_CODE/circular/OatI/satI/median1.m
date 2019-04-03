function [ut]=median1(M,level)
%
% CALL median(x,grps)
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., University of Lund.
[n,p]=size(M); % assume x and level have the same size
if (nargin==1), 
 level=1*ones(n,p);
end
[nl,pl]=size(level);
if (pl==1),
 level=level*ones(1,p);
end
ut=[];
%[n cm]=size(M);
%if (nargin==1), 
% level=1*ones(length(M),1);
%end
for u=1:p,
grps=0;
for i=1:n,
 l=level(i,u);
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
  Ant(j,1)=0.0; C(j,1)=0.0; N(j,1)=0; C2(j,1)=0.0;
end
for i=1:rm,
  if (finite(M(i,u))),
    for j=1:grps,
       if level(i,u)==grp(j),
         Ant(j,1)=Ant(j,1)+1;
         V(Ant(j,1),j)=M(i,u);
         N(j,1)=N(j,1)+1.0;
       end
    end
  end
end;
for i=1:grps,
  VV=[];
  for j=1:Ant(i,1),
    VV(j,1)=V(j,i);
  end;
  if prod(size(VV))>0, 
    m(i,1)=median(VV);
  else m(i,1)=NaN;
  end
end;
ut=[ut,m];
end %u
end







