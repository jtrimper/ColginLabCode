function [F]=ncdf(x,m,s)
%
% CALL: ncdf(x)
%       ncdf(x,m,s)
%
if nargin==1,
  if (x>=0),
    F=0.5*(erf(x/sqrt(2))+1);
  else
    F=1-0.5*(erf(-x/sqrt(2))+1);
  end
end
if nargin==2,
    F=ncdf(x-m);
end
if nargin==3,
    F=ncdf((x-m)/s);
end
