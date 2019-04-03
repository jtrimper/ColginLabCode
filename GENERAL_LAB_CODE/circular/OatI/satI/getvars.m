function [var]=getvars(g);
%
% Gets the variable names from interml.asc
%
% CALL: getvars; 
%
% Copyright 1993, Bjorn Holmquist, Dept of Math. Stat., Universty of Lund.
%
%load D:\matlabR11\toolbox\menu\interml.asc
load([g 'toolbox\menu\interml.asc'])
var=setstr(interml);
%end
