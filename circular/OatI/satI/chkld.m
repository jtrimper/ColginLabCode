function [X,nrld]=chkld(nr,X,nrld)
%
% CALL: chkld(nr,X,nrld)
%
% where
%
%     nr     = variable to be checked if loaded,
%     X      = matrix with variables in columns,
%     nrld   = already loaded variable numbers.
%
[ro,co]=size(nr);
for j=1:co,
  if (vnrld(nr(j),nrld)==0),
    [X,nrld]=ldmlvars([nrld,nr(j)]);
  end
end
%end
