z=[0:0.1:0.9];
y=[0:0.1:0.9];
[Z,Y]=meshgrid(z,y);
f=t(sqrt(Z.^2+Y.^2))-t(Z);
mesh(y,z,f)
hold on
g=(Z+2).^(0+0.5*Y).*Y.^(2+0.7*Z);
mesh(y,z,g)
