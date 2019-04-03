function [y]=zero2nan(x,u)
%
% CALL  y=zero2nan(x,u)
%
n=length(x);
for k=1:n,
  if (u(k)==0),
     y(k)=NaN;
  else
     y(k)=x(k);
  end
end
end
