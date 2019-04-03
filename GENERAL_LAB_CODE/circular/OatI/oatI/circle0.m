for i=1:360,
 X(i)=cos(2*pi*(i-1)/360);
 Y(i)=sin(2*pi*(i-1)/360);
end
plot(X,Y)
axis([-1.5 1.5 -1.25 1.25])
title('Circular Case plot diagram')
hold on

