function [F]=pocdf(x,m)
%
% CALL: [F]=pocdf(x,m)
%
%
[rx,cx]=size(x);
for j1=1:rx,
for j2=1:cx,
f=0;
x0=x(j1,j2);
%for i=0:x(j1,j2),
%    f=f+po(i,m);
%end
f=sum(exp(-m)*m.^([0:x0])./fac([0:x0]));
F(j1,j2)=f;
end
end
end

