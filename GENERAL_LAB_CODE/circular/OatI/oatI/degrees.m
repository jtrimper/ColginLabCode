function degrees(xpos,ypos,r)
%
% CALL: degrees(xpos,ypos,size) 
%
X=cos(2*pi*[0:5:360]/360);
Y=sin(2*pi*[0:5:360]/360);
plot(xpos+r*X,ypos+r*Y)
%end fcn
