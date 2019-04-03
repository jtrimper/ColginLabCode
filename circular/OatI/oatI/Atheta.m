function [s]=Atheta(x,theta0)
%
% CALL  [s]=Atheta(x,theta0)
%
%  where
%
%     x  = directions (i radians).
%
n=length(x); 
x1=abs(x-theta0); x2=abs(2*pi-(x-theta0));
s=0;
for k=1:n,
  if x1(k)<x2(k),
    s=s+x1(k);
  else
    s=s+x2(k);
  end
end
%s=0.0;
%for k=1:n,
xp=mod(x-theta0,2*pi)
s=sum(pi-abs(pi-xp));
%end
%end


