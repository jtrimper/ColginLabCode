function c=mod(a,b)
%
% CALL: c=mod(a,b)
%       c= a mod b
c=a-fix(a/b)*b;
c=c+(c<0)*b; 
%end

