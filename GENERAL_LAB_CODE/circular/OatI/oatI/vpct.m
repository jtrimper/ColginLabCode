function [c]=vpct(p0,n)
%
% CALL : 
%          [r=vpct(p0,n)
%
%   where   
%           p    = the extreme probability for the actual configuration
%  load vtesttab
  load vtest.tab
  for j=2:5,
    if (p0<=0.10), j0=2; end
    if (p0<=0.05), j0=3; end
    if (p0<=0.025), j0=4; end
    if (p0<=0.01), j0=5; end
  end
  c=table2(vtest,n,p0);
end

                                   
