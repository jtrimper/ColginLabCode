function [varname]=vn(x,var)
%
% CALL: varname=vn(name,var);
%
% where
%
%     name   = row vector containing name,
%     var    = matrix of variable names,
%     vrname = rovector containing the variable name.
%
[ro,co]=size(var);
[rx,cx]=size(x);
%for j=1:rx,
  for i=cx:co-1
    x=[x,' '];
  end
  varname=x;
%end
end
