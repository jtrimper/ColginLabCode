function [xp]=exppct(p,c,a);
%
%
  if (nargin<3), a=1; end
  if (nargin<2(, c=1; end
  xp=a*(-log(p))^(1/c);
end

