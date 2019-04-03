function [xp]=npct(P,m,s);
%
% CALL:
%
%     [xp]=npct(p)
%     [xp]=npct(p,m)
%     [xp]=npct(p,m,s)
%
[rp,cp]=size(P);
for j1=1:rp,
for j2=1:cp,
p=P(j1,j2);
c0=2.51;
c1=0.80;
c2=0.01;
d1=1.43;
d2=0.189;
d3=0.001308;
if (p>0),
if (p<0.5),
  q=p;
else 
  q=1.0-p;
end
t=sqrt(-2.0*log(q));
x=t-(c0+c1*t+c2*t^2)/(1+d1*t+d2*t^2+d3*t^3);
if (p<0.5),
  xq=x;
else 
  xq=-x;
end
end
if (nargin<2), m=0; end
if (nargin<3), s=1; end
xp(j1,j2)=m+s*xq;
end
end
%end fcn

