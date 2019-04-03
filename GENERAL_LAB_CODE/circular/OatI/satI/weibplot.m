function weibplot(x,symb)
%
% CALL: weibplot(x)
%       weibplot
%       weibplot(x,symb)
%
%       weibplot(x) plots the values of x in a Weibull probability paper.
%       weibplot by itself generates an empty Weibull probability paper.
%       weibplot(x,symb) plots the values of x using colors and symbols specified by symb.

if nargin==0,
 normplot([],'weib');
 else
   if nargin==2, normplot(x,'weib',symb); end
   if nargin==1, normplot(x,'weib'); end
 end
%end
