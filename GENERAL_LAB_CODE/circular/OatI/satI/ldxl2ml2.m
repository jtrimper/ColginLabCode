function [var]=ldxl2ml(g);
%
% Copyright 1993, Bjorn Holmquist, Dept of Math. Stat., Universty of Lund.
%
%!
dos('xtrvnam.exe stdxltxt 23');
%!
dos('str2asc.exe'); 
%!
dos('xltx2iml.exe stdxltxt 23 200 1 23');
%load interml.v5
%x5=interml;
dos('copy /circ/interml.* /matlab/toolbox/menu/*.*')
end
