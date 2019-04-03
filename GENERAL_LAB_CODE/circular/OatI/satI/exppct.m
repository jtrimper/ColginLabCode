function [xp]=exppct(p,m);
%
%
  if (nargin==2),
    mu=m;
  else
    mu=1;
  end
  xp=-mu*log(p);
end

