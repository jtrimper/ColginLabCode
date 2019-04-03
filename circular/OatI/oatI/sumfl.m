function [b]=sumfl(b,conc,dir,len)
%
%
a=b;
[ra,ca]=size(a);
b=[b,a(:,ca)+flight(conc,dir,len)];
end
