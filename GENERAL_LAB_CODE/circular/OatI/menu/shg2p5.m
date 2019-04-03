[B,c,n]=circmean(M); 
plot([B(2);(1+c)*B(2)],[B(1);(1+c)*B(1)],'w');
psi=3*pi/4;
l1=cos(psi)*c*B(2)-sin(psi)*c*B(1);
l2=sin(psi)*c*B(2)+cos(psi)*c*B(1);
plot([(1+c)*B(2);(1+c)*B(2)+0.07*l1],[(1+c)*B(1);(1+c)*B(1)+0.07*l2],'w');
psi=-3*pi/4;
l1=cos(psi)*c*B(2)-sin(psi)*c*B(1);
l2=sin(psi)*c*B(2)+cos(psi)*c*B(1);
plot([(1+c)*B(2);(1+c)*B(2)+0.07*l1],[(1+c)*B(1);(1+c)*B(1)+0.07*l2],'w');
a=atan2(B(2),B(1));
if (a<0), a=a+2*pi;
end
%global htextcount
%global htext
%if ((txt(1)=='y')|(txt(1)=='s')), 
htextcount=htextcount+1;
htext(htextcount)=text(-1.2,-1.1,['n=',num2str(n)],'HorizontalAlignment','left');
htextcount=htextcount+1;
htext(htextcount)=text(-1.2,-1.0,['r=',num2str(c)],'HorizontalAlignment','left');
htextcount=htextcount+1;
htext(htextcount)=text(-1.2,-0.9,['@=',num2str(180*a/pi)],'HorizontalAlignment','left');
htextcount=htextcount+1;
htext(htextcount)=text(-1.2,-1.2,['P<',num2str(exp(-n*c*c))],'HorizontalAlignment','left');
set(htext,'FontSize',FontSize);
