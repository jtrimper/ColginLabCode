function [M]=ciplvar(nr,X,loaded)
%
% A menu shell for circular data analysis.
%
% CALL: ciplvar(nr,X,loaded)
%
% Copyright (C) 1993, Bjorn Holmquist, Dept of Math. Stat., University of Lund.
[X,loaded]=chkld(nr,X,loaded); 
M=X(:,vnrld(nr,loaded)); 
circplot(M,'degrees')
%end
