[B,c]=circmean(M); 
plot([0;c*B(2)],[0;c*B(1)],'k');
psi=3*pi/4;
l1=cos(psi)*c*B(2)-sin(psi)*c*B(1);
l2=sin(psi)*c*B(2)+cos(psi)*c*B(1);
plot([c*B(2);c*B(2)+0.07*l1],[c*B(1);c*B(1)+0.07*l2],'k');
psi=-3*pi/4;
l1=cos(psi)*c*B(2)-sin(psi)*c*B(1);
l2=sin(psi)*c*B(2)+cos(psi)*c*B(1);
plot([c*B(2);c*B(2)+0.07*l1],[c*B(1);c*B(1)+0.07*l2],'k');
%global htextcount
%global htext
%if ((txt(1)=='y')|(txt(1)=='s')), 
%  htextcount=htextcount+1;
%  htext(htextcount)=text(-1.2,-1.1,['n=',num2str(n)],'HorizontalAlignment','left');
%  htextcount=htextcount+1;
%  htext(htextcount)=text(-1.2,-1.0,['r=',num2str(r)],'HorizontalAlignment','left');
%  htextcount=htextcount+1;
%  htext(htextcount)=text(-1.2,-0.9,['@=',num2str(180*a/pi)],'HorizontalAlignment','left');
%  htextcount=htextcount+1;
%  htext(htextcount)=text(-1.2,-1.2,['P<',num2str(exp(-n*r*r))],'HorizontalAlignment','left');
