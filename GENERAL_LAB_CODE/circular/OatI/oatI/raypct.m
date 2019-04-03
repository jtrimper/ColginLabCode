function [r]=raypct(p0,n)
%
% CALL : 
%          [r]=raypct(p0,n)
%
%   where   
%           p    = the extreme probability for the actual configuration
%  load rayleigh
  load raytsttb.tab   %raytest.tab
  for j=2:6,
    if (p0<=0.10), j0=2; end
    if (p0<=0.05), j0=3; end
    if (p0<=0.025), j0=4; end
    if (p0<=0.01), j0=5; end
    if (p0<=0.001), j0=6; end
  end
  r=table2(raytsttb,n,p0);
end

                                   
