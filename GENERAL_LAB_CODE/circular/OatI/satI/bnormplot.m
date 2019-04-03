function bnormplot(x)
%
% CALL: bnormplot(x)             plots the values of x in a normal probability paper.
%       bnormplot                by itself generates an empty normal probability paper.
%       bnormplot(x,symb)        plots the values of x uin a normal probability paper
%                                using colors and symbols specified by symb.
%
% Example
%       bnormplot(x,'r*')        plots the values of x using red * symbols in a Gumbel
%                                probability paper
%
%
if nargin==0,
 bprobplot([],'norm');
 else
    bprobplot(x,'norm');
 end
%end



