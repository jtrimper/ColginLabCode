function [o]=barplot(x,y)
%
% CALL: barplot(y)
%       barplot(x,y)
%
x=x(:)'; if nargin>1, y=y(:)'; end %1999-03-10
if (nargin==1), 
    n=length(x);
    o=plot([1:n;1:n],[x;0*x],'-'); 
end
if (nargin==2), o=plot([x;x],[y;0*y],'-'); end
%end

