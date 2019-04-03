function [b]=banana(a)
global f
z=[0:0.1:0.9];
y=[0:0.1:0.9];
[Z,Y]=meshgrid(z,y);
%f=t(sqrt(Z.^2+Y.^2))-t(Z);
%f
%mesh(y,z,f)
%hold on
g=a(5)*(a(4)*Z+2).^(a(1)+a(2)*Y).*Y.^(2+a(3)*Z);
%b=trace((f-g)'*(f-g));
b=sum(sum(abs(f-g))');
%mesh(y,z,g)
end
