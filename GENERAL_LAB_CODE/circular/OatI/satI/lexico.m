function [d]=lexico(i,p)
%
%
r=length(i);
v=vander(p*ones(1,r));
y=v*(i-ones(1,r))';
d=1+y(1);
end


