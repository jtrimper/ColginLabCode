function [var]=ldxl2ml(g);
%
% Gets the variable names from interml.asc
%
% CALL: getvars; 
%
% Copyright 1993, Bjorn Holmquist, Dept of Math. Stat., University of Lund.
%
%!
dos('xtrvnam.exe stdxltxt 20');
%!
dos('str2asc.exe'); 
%!
%dos('xltx2iml.exe stdxltxt 20 38 1 19');
dos('xltx2iml.exe stdxltxt 20 190 1 19');
end
