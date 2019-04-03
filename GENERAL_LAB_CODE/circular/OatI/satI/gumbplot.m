function gumbplot(x)
%
% CALL: gumbplot(x)
%
if nargin==0,
 normplot([],'gumb');
 else
    normplot(x,'gumb');
 end
%end
