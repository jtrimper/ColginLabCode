function [nr]=varnrof(x,var)
%
% CALL: nr=varnrof(name,var);
%
% where
%
%     name  = row vector containing a string,
%     var   = matrix of variable names,
%     nr    = is the number of the string in the matrix var.
%
nr=0;
[ro,co]=size(var);
%[rx,cx]=size(x);
%for i=cx:co-1
%  x=[x,' '];
%end
x=vn(x,var);
for i=1:ro,
 if x==var(i,:)
   nr=i;
 end
end
end
