[A,r2,n]=circaxis(M); 
plot([A(2);(1+r2)*A(2)],[A(1);(1+r2)*A(1)],'w'); 
psi=3*pi/4;
l1=cos(psi)*r2*A(2)-sin(psi)*r2*A(1);
l2=sin(psi)*r2*A(2)+cos(psi)*r2*A(1);
plot([(1+r2)*A(2);(1+r2)*A(2)+0.07*l1],[(1+r2)*A(1);(1+r2)*A(1)+0.07*l2],'w');
psi=-3*pi/4;
l1=cos(psi)*r2*A(2)-sin(psi)*r2*A(1);
l2=sin(psi)*r2*A(2)+cos(psi)*r2*A(1);
plot([(1+r2)*A(2);(1+r2)*A(2)+0.07*l1],[(1+r2)*A(1);(1+r2)*A(1)+0.07*l2],'w');
plot([-A(2);-(1+r2)*A(2)],[-A(1);-(1+r2)*A(1)],'w');
psi=3*pi/4;
l1=-cos(psi)*r2*A(2)+sin(psi)*r2*A(1);
l2=-sin(psi)*r2*A(2)-cos(psi)*r2*A(1);
plot([-(1+r2)*A(2);-(1+r2)*A(2)+0.07*l1],[-(1+r2)*A(1);-(1+r2)*A(1)+0.07*l2],'w');
psi=-3*pi/4;
l1=-cos(psi)*r2*A(2)+sin(psi)*r2*A(1);
l2=-sin(psi)*r2*A(2)-cos(psi)*r2*A(1);
plot([-(1+r2)*A(2);-(1+r2)*A(2)+0.07*l1],[-(1+r2)*A(1);-(1+r2)*A(1)+0.07*l2],'w');
%A(1)=Cc/(n*r2); A(2)=Ss/(n*r2); 
a=atan2(A(2),A(1));
%a=a/2.0; 
A(1)=cos(a); A(2)=sin(a);   
if (a<0), a=a+2*pi;  
end
if (a>pi), a=a-pi;
end
%global htextcount
%global htext
htextcount=htextcount+1;
htext(htextcount)=text(0.9,-1.0,['r2=',num2str(r2)],'HorizontalAlignment','left');
htextcount=htextcount+1;
htext(htextcount)=text(0.9,-0.9,['@2=',num2str(180*a/pi),'-',num2str(180*(a+pi)/pi)],'HorizontalAlignment','left');
htextcount=htextcount+1;
htext(htextcount)=text(0.9,-1.2,['P2<',num2str(exp(-n*r2*r2))],'HorizontalAlignment','left');
htextcount=htextcount+1;
htext(htextcount)=text(0.9,-1.1,['n=',num2str(n)],'HorizontalAlignment','left');
