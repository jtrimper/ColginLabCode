function [v]=valunion(v1,v2)
%
% CALL: v=valunion(v1,v2)
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., University of Lund.
% 
n1=length(v1);
n2=length(v2);
grps=0;
v=v1;
j1=n1;
for i=1:n2,
   defok='fals';
 for j=1:n1,
   if (v2(i)==v(j)),
     defok='true';
   end
 end
 if defok=='fals', 
   j1=j1+1;
   v(j1)=v2(i);
 end
end


