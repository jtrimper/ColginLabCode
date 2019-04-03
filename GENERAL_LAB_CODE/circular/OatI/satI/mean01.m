function [m,s,Nn]=mean01(x,cat,level)
%
% CALL:
%    
%   [m]=mean1(x)
%   [m,s]=mean1(x)
%   [m,s,n]=mean1(x)
%   [m]=mean1(x,level)
%   [m,s]=mean1(x,level)
%   [m,s,n]=mean1(x,level)
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., University of Lund.
[n,p]=size(x); % assume x and level have the same size
if (nargin==1), 
 level=1*ones(n,p);
end
[nl,pl]=size(level);
%if (pl==1),
% level=level*ones(1,p);
%end
s=[];
%for u=1:p,
  grps=0;
  for i=1:nl,
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
     C(j,1)=0.0; N(j,1)=0; C2(j,1)=0.0;
  end
  for i=1:rm,
    if (finite(x(i))),
      for j=1:grps,
         if cat(i)==grp(j),
           C(j,1)=C(j,1)+x(i); 
           N(j,1)=N(j,1)+1.0;
           C2(j,1)=C2(j,1)+x(i)*x(i);
         end
      end
    end
  end;
  for i=1:grps,
    if N(i,1)>0,
       m(i)=C(i,1)/N(i,1);
    else
       m(i)=NaN;
    end
  end;
  if nargout>1,
    s1=sqrt((C2-C.*C./N)./(N-1));
    s=[s,s1];
    Nn=[Nn,N];
  end
%end % u
end

