function [s2,N]=var1(x,level)
%
% CALL:
%    
%   [v]=var1(x)
%   [v,n]=var1(x)
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., University of Lund.
n=length(x);
if (nargin==1), 
 level=ones(length(x),1);
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
  C(j)=0.0; N(j)=0; C2(j)=0.0;
end
for i=1:rm,
  if (finite(x(i))),
    for j=1:grps,
       if level(i)==grp(j),
         C(j)=C(j)+x(i); 
         N(j)=N(j)+1.0;
         C2(j)=C2(j)+x(i)*x(i);
       end
    end
  end
end;
%for i=1:grps,
% m(i)=C(i)/N(i);
%end;
s2=(C2-C.*C./N)./(N-1);
%end
