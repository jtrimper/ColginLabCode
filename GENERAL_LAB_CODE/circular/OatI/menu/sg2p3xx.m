xcoord=str2num(get(hedit1,'String')); 
ycoord=str2num(get(hedit2,'String')); 
close(ff2p3)
figure(f1)
htextcount=0;
htext=[];
htextcount=htextcount+1;
htext(htextcount)=text(xcoord,ycoord,['n=',num2str(n)],'HorizontalAlignment','left');
htextcount=htextcount+1;
htext(htextcount)=text(xcoord,ycoord+0.1,['r=',num2str(c)],'HorizontalAlignment','left');
htextcount=htextcount+1;
%htext(htextcount)=text(xcoord,ycoord+0.2,['@=',num2str(180*a/pi)],'HorizontalAlignment','left');
alpha(xcoord,ycoord+0.2-0.03,0.07);
htext(htextcount)=text(xcoord+0.1,ycoord+0.2,['=',num2str(180*a/pi)],'HorizontalAlignment','left');
htextcount=htextcount+1;
htext(htextcount)=text(xcoord,ycoord-0.1,['P<',num2str(exp(-n*c*c))],'HorizontalAlignment','left');
set(htext,'FontSize',FontSize);


