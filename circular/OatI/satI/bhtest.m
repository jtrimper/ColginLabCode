function [var]=bhtest(g);
%
% Gets the variable names from interml.asc
%
% CALL: getvars; 
%
% Copyright 1993, Bjorn Holmquist, Dept of Math. Stat., Universty of Lund.
%
for i=g:g+10,
asc=setstr(i);
var(i-g+1,1)=asc;
%text(0.5,1.0-(i-g)/10,[num2str(i),asc])
end
