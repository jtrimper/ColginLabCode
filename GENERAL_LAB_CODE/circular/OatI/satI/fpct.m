function [fp]=fpct(p,nu1,nu2);
%
% CALL: fpct(p,nu1,nu2)
% WARNING: This routine is not working so well
%disp('WARNING: This routine is not working so well')
if ((nu1>2)&(nu2>2)),
xp=npct(p);
a=nu2/2;
b=nu1/2;
h=2/(1/(2*a-1)+1/(2*b-1));
lambda=(xp^2-3)/6;
w=xp*sqrt(h+lambda)/h-(1/(2*b-1)-1/(2*a-1))*(lambda+5/6-2/(3*h));
fp=exp(2*w);
else
 fp=finv(1-p,nu1,nu2);
end
end

