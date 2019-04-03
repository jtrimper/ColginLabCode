function [s,N]=std1(x,level)
%
% CALL:
%    
%   [s]=std1[x,group]
%   [s,n]=std1[x,group]
%

% Copyright 1993, Björn Holmquist, Dept of Math. Stat., University of Lund.
[n,p]=size(x); % assume x and level have the same size
%n=length(x);
if (nargin==1), 
 level=1*ones(n,p);
end
[nl,pl]=size(level);
if (pl==1),
 level=level*ones(1,p);
end
%if (nargin==1), 
% level=1*length(x);
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
[rm cm]=size(x);
for j=1:grps,
  C(j,u)=0.0; N(j,u)=0; C2(j,u)=0.0;
end
for i=1:rm,
  if (finite(x(i,u))),
    for j=1:grps,
       if level(i,u)==grp(j),
         C(j,u)=C(j,u)+x(i,u); 
         N(j,u)=N(j,u)+1.0;
         C2(j,u)=C2(j,u)+x(i,u)*x(i,u);
       end
    end
  end
end;
end % u
s=sqrt((C2-C.*C./N)./(N-1));
end








