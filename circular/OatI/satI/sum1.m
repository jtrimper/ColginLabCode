function [m,Nn]=sum1(x,level)
%
% CALL:
%    
%   [m]=sum1[x]
%   [m,n]=sum1[x]
%   [m]=sum1[x,level]
%   [m,n]=sum1[x,level]
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., Lund University.
[n,p]=size(x); % assume x and level have the same size
if (nargin==1), 
 level=1*ones(n,p);
end
[nl,pl]=size(level);
if (pl==1),
 level=level*ones(1,p);
end
s=[];
Nn=[]; %19980303
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
  [rm cm]=size(x);
  for j=1:grps,
     C(j,1)=0.0; N(j,1)=0; C2(j,1)=0.0;
  end
  for i=1:rm,
    if (finite(x(i,u))),
      for j=1:grps,
         if level(i,u)==grp(j),
           C(j,1)=C(j,1)+x(i,u); 
           N(j,1)=N(j,1)+1.0;
%           C2(j,1)=C2(j,1)+x(i,u)*x(i,u);
         end
      end
    end
  end;
  for i=1:grps,
    m(i,u)=C(i,1);
  end;
%  s1=sqrt((C2-C.*C./N)./(N-1));
%  s=[s,s1];
  Nn=[Nn,N];
end % u
%end

