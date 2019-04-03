function bgumbplot(x)
%
% CALL: bgumbplot(x)             plots the values of x in a Gumbel probability paper.
%       bgumbplot                by itself generates an empty Gumbel probability paper.
%       bgumbplot(x,symb)        plots the values of x in a Gumbel probability paper
%                                using colors and symbols specified by symb.
%
% Example:
%       bgumbplot(x,'r*')        plots the values of x using red * symbols in a Gumbel
%                                probability paper
%
%
if nargin==0,
 bprobplot([],'gumb');
 else
   if nargin==2, bprobplot(x,'gumb',symb); end
   if nargin==1, bprobplot(x,'gumb'); end
 end
%end
