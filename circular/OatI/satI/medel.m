function [m,s,N]=medel(x,level)
%
% CALL:
%    
%   [m]=medel[x]
%   [m,s]=medel[x]
%   [m,s,n]=medel[x]
%
% Copyright 1993, Bj”rn Holmquist, Dept of Math. Stat., University of Lund.
n=length(x);
[n,p]=size(x);
if (nargin==1), 
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
for i=1:grps,
 m(i)=C(i)/N(i);
end;
% if ((nargout>=2)|(nargout==0)),
%  for i=1:grps,
%   s(i)=sqrt((C2(i)-N(i)*m(i)*m(i))/(N(i)-1.0));
%  end
% end
end
