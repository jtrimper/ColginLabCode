function [grp]=valuesof(y)
%
% CALL: valuesof(x)
%
% Copyright 1993,1997, Björn Holmquist, Dept of Math. Stat., University of Lund.
%

tol=exp(-20);
n=length(y);
grps=0;
grp=[];
for i=1:n,
%n-i
% l=level(i);
 l=y(i);
 defok='false';
% for k=1:grps,
%%   if (l==grp(k)), defok='true'; end
%   if (abs(l-grp(k))<tol), defok='true'; end %960820
% end %for
 if min(abs(grp-l))<tol,  defok='true'; end %970417
 if isnan(l), defok='true'; end % 940921
 if (defok(1:4)=='fals'),
   grps=grps+1;
   grp(grps)=l;
 end %if
end %for
%end

