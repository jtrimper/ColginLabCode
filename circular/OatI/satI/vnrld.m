function [vnr]=vnrld(nr,nrld)
%
% CALL: vnr=vnrld(nr,nrld);
%
% where
%
%     nr   = nr of variable(s),
%     nrld = row vector of loaded variables,
%     vnr  = number of variable(s) among the loaded variables.
vnr=0;
[rx,cx]=size(nrld);
[rnr,cnr]=size(nr);
for j=1:cnr,
  for i=1:cx,
    if (nr(j)==nrld(1,i)),
      vnr(j)=i;
    end
  end
end
%end
