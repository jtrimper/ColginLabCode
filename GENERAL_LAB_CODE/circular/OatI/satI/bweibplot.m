function bweibplot(x,symb)
%
% CALL: bweibplot(x)             plots the values of x in a Weibull probability paper.
%       bweibplot                by itself generates an empty Weibull probability paper.
%       bweibplot(x,symb)        plots the values of x in a Weibull probability paper
%                                using colors and symbols specified by symb.
%
% Example: 
%       bweibplot(x)             plots the values of x in a Weibull probability paper.
%       bweibplot(x,'r*')        plots the values of x using red * symbols in a Weibull
%                                probability paper.
% 
if nargin==0,
 bprobplot([],'weib');
 else
   if nargin==2, bprobplot(x,'weib',symb); end
   if nargin==1, bprobplot(x,'weib'); end
 end
%end
