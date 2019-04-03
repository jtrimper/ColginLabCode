[B,c]=circmean(M);
%global htextcount
%global htext
%if (txt(1)=='t'), 
htextcount=htextcount+1;
htext(htextcount)=text(1,-1.3,['(r1=',num2str(c),')'],'HorizontalAlignment','left');

