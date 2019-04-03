function [X,varnbrs]=ldmlname(varnames,var);
%
% Gets the variables from interml.v??
%
% CALL: [X,varnbrs]=ldmlname(varnames,var); 
%
% where
%
%     varnames = matrix with variable names to be loaded in the rows,
%     var      = matrix of variable names.
%
% Copyright 1993, Bjorn Holmquist, Dept of Math. Stat., Universty of Lund.
%
[ro,co]=size(varnames);
for i=1:ro,
%  name=varnames(i,:);
  varnbrs=[varnbrs,varnrof(varnames(i,:),var)];
end
X=ldmlvars(varnbrs);
end
