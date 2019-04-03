function [var]=ldxl2ml(g);
%
% Gets the variable names from interml.asc
%
% CALL: getvars; 
%
% Copyright 1993, Bjorn Holmquist, Dept of Math. Stat., Universty of Lund.
%
!xtrvnam.exe stdxltxt 20
!str2asc.exe 
!xltx2iml.exe stdxltxt 20
%load interml.v5
%x5=interml;
%load interml.v6
%x6=interml;
%load interml.v7
%x7=interml;
%load interml.v8
%x8=interml;
%load interml.v9
%x9=interml;
%load interml.v10
%x10=interml;
%load interml.v11
%x11=interml;
end
