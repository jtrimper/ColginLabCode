function degrees(xpos,ypos,r)
%
% CALL: degrees(xpos,ypos,size) 
%
X=cos(2*pi*[0:5:360]/360);
Y=sin(2*pi*[0:5:360]/360);
%for i=1:5:360,
% X(i)=cos(2*pi*(i-1)/360);
% Y(i)=sin(2*pi*(i-1)/360);
%end
plot(xpos+r*X,ypos+r*Y)
%axis([-1.5 1.5 -1.25 1.25])
end
