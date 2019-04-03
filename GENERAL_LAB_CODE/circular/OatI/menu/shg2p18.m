[rk,k,n,a1,a2,a,ak]=broken(M)
htextcount=0;
%[A,r2,n]=circaxis(M); 
%a=atan2(a1(2),a1(1)); 
if (a<0), a=a+2*pi; end;
%1999-02-15
plot([0;rk*sin(pi*(ak/k)/180)],[0;rk*cos(pi*(ak/k)/180)],'g');
plot([0;rk*sin(ak*pi/180)],[0;rk*cos(ak*pi/180)],'b');
ak
ak/k
%1999-02-15
plot([0;rk*a1(2)],[0;rk*a1(1)],'r'); 
psi=3*pi/4;
l1=cos(psi)*rk*a1(2)-sin(psi)*rk*a1(1);
l2=sin(psi)*rk*a1(2)+cos(psi)*rk*a1(1);
plot([rk*a1(2);rk*a1(2)+0.07*l1],[rk*a1(1);rk*a1(1)+0.07*l2],'r');
psi=-3*pi/4;
l1=cos(psi)*rk*a1(2)-sin(psi)*rk*a1(1);
l2=sin(psi)*rk*a1(2)+cos(psi)*rk*a1(1);
plot([rk*a1(2);rk*a1(2)+0.07*l1],[rk*a1(1);rk*a1(1)+0.07*l2],'r');
%
plot([0;rk*a2(2)],[0;rk*a2(1)],'r');
psi=3*pi/4;
l1=cos(psi)*rk*a2(2)-sin(psi)*rk*a2(1);
l2=sin(psi)*rk*a2(2)+cos(psi)*rk*a2(1);
plot([rk*a2(2);rk*a2(2)+0.07*l1],[rk*a2(1);rk*a2(1)+0.07*l2],'r');
psi=-3*pi/4;
l1=cos(psi)*rk*a2(2)-sin(psi)*rk*a2(1);
l2=sin(psi)*rk*a2(2)+cos(psi)*rk*a2(1);
plot([rk*a2(2);rk*a2(2)+0.07*l1],[rk*a2(1);rk*a2(1)+0.07*l2],'r');
%%%if (a>pi), a=a-pi; end
%global htextcount
%global htext
global FontSize
htextcount=htextcount+1;
if a(1,1)<0, a(1,1)=a(1,1)+360; end
if a(1,2)<0, a(1,2)=a(1,2)+360; end
%htext(htextcount)=text(0.9,-0.9,['@1=',num2str(a(1,1)),', @2=',num2str(a(1,2))],'HorizontalAlignment','left');
%htext(htextcount)=text(0.9,-0.9,['@1=',num2str(a(1,1)),', @2=',num2str(a(1,2))],'HorizontalAlignment','left');
xcoord=0.9; ycoord=1.3;
xcoord
ycoord
%alfa(xcoord,ycoord-0.03,0.07,'r') 
alpha(xcoord,ycoord-0.03,0.07,'r') %970427
%alfa(xcoord,ycoord,0.07)
alfa(xcoord+0.5,ycoord-0.03,0.07,'r')
htext(htextcount)=text(xcoord+0.1,ycoord,['1=',num2str(a(1,1)),'           2=',num2str(a(1,2))],'HorizontalAlignment','left');
set(htext(htextcount),'Color','r');
%shtext(htextcount)=text(0.9,-0.9,['@2=',num2str(a(1,1)),'-',num2str(a(1,2))],'HorizontalAlignment','left');
htextcount=htextcount+1;
htext(htextcount)=text(0.9,ycoord-0.1,['rmax=',num2str(rk)],'HorizontalAlignment','left');
set(htext(htextcount),'Color','r');
htextcount=htextcount+1;
htext(htextcount)=text(0.9,ycoord-0.4,['k*=',num2str(k)],'HorizontalAlignment','left');
set(htext(htextcount),'Color','r');
htextcount=htextcount+1;
htext(htextcount)=text(0.9,ycoord-0.3,['Pk<',num2str(exp(-n*rk*rk))],'HorizontalAlignment','left');
set(htext(htextcount),'Color','r');
htextcount=htextcount+1;
htext(htextcount)=text(0.9,ycoord-0.2,['n=',num2str(n)],'HorizontalAlignment','left');
set(htext(htextcount),'Color','r');
set(htext,'FontSize',FontSize);
%set(htext,'FontSize',16);


