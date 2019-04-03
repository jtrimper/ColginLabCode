function [r,N]=iqr1(x,level)
%
% CALL:
%    
%   [v]=iqr1[x]
%   [v,n]=iqr1[x]
%   [v,n]=iqr1[x,group]
%

% Copyright 1993, Björn Holmquist, Dept of Math. Stat., Lund University
n=length(x);
if (nargin==1), 
 level=1*length(x);
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
for j=1:grps,
  z=[];
  for i=1:rm,
    if (finite(x(i))),
       if level(i)==grp(j),
        z=[z;x(i)];
       end
    end %if finite...
   end %i
   xs=sort(z);
   n=length(z);
   r(j)=xs(floor(0.75*n))-xs(floor(0.25*n));
end; %j
%end fcn
