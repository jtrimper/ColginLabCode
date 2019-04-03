function bprobplot(x,typ,symb,y)
%
% CALL:
%       bprobplot(x,typ,symb)   plots the values of x in a probability paper given by typ
%                               using symbols specified by symb.
%
%                               typ may be 'norm', weib', 'gumb', giving a normal
%                               probability paper, a Weibull probability paper and a Gumbel
%                               probability paper respectively.
%
%                               symb may be color and symbol specifying combinations.
%
% Example: 
%       probplot(x,'norm')      plots the values of x in a normal probability paper.
%       probplot(x,'norm','r*') plots the values of x using red * symbols in a normal
%                               probability paper.
%
%
%       probplot(x,'weib')      plots the values of x in a Weibull probability paper.
%       probplot(x,'weib','r*') plots the values of x using red * symbols in a Weibull
%                               probability paper.
%
%       probplot(x,'gumb')      plots the values of x in a Gumbel probability paper.
%
%       probplot([],'norm')     produces an empty normal probability paper.%
%       probplot([],'weib')     generates an empty Weibull probability paper.
%       probplot([],'gumb')     generates an empty Gumbel probability paper.
%
%
if nargin>0, [a,b]=size(x); if a==1, x=x(:); end,end
holdstate=ishold;
color=['r';'g';'w';'b';'m';'r';'g';'w';'b';'m';'r';'g';'w';'b';'m';'r';'g';'w';'b';'m'];
color=[color;color];
if nargin<3,
  plotsymb='+';
else
  plotsymb=symb;
  nocol=0;
  if strcmp(symb(1),'y'), color=['y']; nocol=1; end
  if strcmp(symb(1),'m'), color=['m']; nocol=1;end
  if strcmp(symb(1),'c'), color=['c']; nocol=1;end
  if strcmp(symb(1),'r'), color=['r']; nocol=1;end
  if strcmp(symb(1),'g'), color=['g']; nocol=1;end
  if strcmp(symb(1),'b'), color=['b'];nocol=1; end
  if strcmp(symb(1),'w'), color=['w']; nocol=1;end
  if strcmp(symb(1),'k'), color=['k']; nocol=1;end
  for i=1:10, color=[color,color]; end
  if nocol==1, plotsymb=symb(2:length(symb)); end
end
if nargin<1,  x=[]; typ='norm'; end
h=gcf;
hold on
if isempty(x), bb=1; else [aa,bb]=size(x); end
if aa==1, x=x(:); end
for kk=1:bb, % for each column in x do ...
  if isempty(x), z=[]; else  z=sort(x(:,kk)); end
  colo=color(kk);
  n=length(z);           
  if (nargin<2), typ='norm'; end
  pltpos=[1:n]'/(n+1); %pltpos=([1:n]'-0.5)/n; %pltpos=([1:n]'-3/8)/(n+1/4);
if (typ=='norm'),
  if isempty(z), %z==[], % empty probability plot
    ul=15.78; %chosen to give tick marks 1 cm apart 
    plot([1:ul-1:ul],npct(1-([1:ul-1:ul]'-0.5)/2),'w');
    hold on
    tt=text(ul+.1,npct(1-0.5),'0'); set(tt,'FontSize',6);
    tt=text(ul+.1,npct(1-0.8413),'1'); set(tt,'FontSize',6);
    tt=text(ul+.1,npct(1-0.97725),'2'); set(tt,'FontSize',6);
    tt=text(ul+.1,npct(0.8413),'1'); set(tt,'FontSize',6);
    tt=text(ul+.1,npct(0.97725),'2'); set(tt,'FontSize',6);
    plot([0,ul],[npct(1-0.97725),npct(1-0.97725)],'--')
    plot([0,ul],[npct(0.97725),npct(0.97725)],'--')
    plot([0,ul],[npct(1-0.8413),npct(1-0.8413)],'--')
    plot([0,ul],[npct(0.8413),npct(0.8413)],'--')
    set(gca,'Xtick',0:1:ul);
    XTickLabels=[' '];
    set(gca,'XtickLabels',XTickLabels);
    axis([0,ul,npct(1-0.001),npct(1-0.999)])
    set(gca,'FontSize',10)
    title('Normalfördelningspapper')
    hold off
  else
    plot(z,npct(1-pltpos),[colo plotsymb]);
   title('Normal Probability Plot'); 
  end
%  text(z(1)-(z(n)-z(1))/10,pltpos(1),'10%');
%  Yticks=npct(1-[0.01,0.05,0.10,0.20,0.30,0.40,0.50,0.60,0.70,0.80,0.90,0.95,0.99]');
  Yticks=npct(1-[0.005,0.01,0.05,0.10,0.20,0.30,0.40,0.50,0.60,0.70,0.80,0.90,0.95,0.99,0.995]');
%  YticLab=[' 1%';' 5%';'10%';'20%';'30%';'40%';'50%';'60%';'70%';'80%';'90%';'95%';'99%'];
%  YticLab=['0.01';'0.05';'0.10';'0.20';'0.30';'0.40';'0.50';'0.60';'0.70';'0.80';'0.90';'0.95';'0.99'];
  YticLab=['0.005';' 0.01';' 0.05';' 0.10';' 0.20';' 0.30';' 0.40';' 0.50';' 0.60';' 0.70';' 0.80';' 0.90';' 0.95';' 0.99';'0.995'];
end
if (typ=='logn'), 
  plot(log(z),npct(1-pltpos),plotsymb); 
  title('Logarithmic Normal Probability Plot');
  Yticks=npct(1-[0.01,0.05,0.10,0.20,0.30,0.40,0.50,0.60,0.70,0.80,0.90,0.95,0.99]');
  YticLab=[' 1%';' 5%';'10%';'20%';'30%';'40%';'50%';'60%';'70%';'80%';'90%';'95%';'99%'];
end
if (typ=='weib'),
  if isempty(z), %z==[], % empty probability plot
    ul=100; 
    plot(log([0.88:ul-1:ul]),log(-log(1-([0.88:ul-1:ul]'-0.5)/2)),'k*');
    hold on
    y0=1-exp(-exp(0));
    x0=exp(1);
    % plus
    plot(log([x0,x0]),log(-log(1-[y0,0.9*y0])),'r-');
    plot(log([x0,x0]),log(-log(1-[y0,1.1*y0])),'r-');
    plot(log([x0,0.9*x0]),log(-log(1-[y0,y0])),'r-');
    plot(log([x0,1.1*x0]),log(-log(1-[y0,y0])),'r-');
    %
    for kk=-4:1,
      y1=1-exp(-exp(kk)); x1=exp(4.62);
      plot(log([x1,0.9*x1]),log(-log(1-[y1,y1])),'r-');
      plot(log([x1,1.1*x1]),log(-log(1-[y1,y1])),'r-');
    end
    for kk=0:4,
      y1=1-exp(-exp(1.6)); x1=exp(kk);
      plot(log([x1,x1]),log(-log(1-[y1,1.1*y1])),'r-');
    end
    hp=18;
    tt(1)=text(log(ul+hp),1,' 1'); 
    tt(2)=text(log(ul+hp),log(-log(1-y0)),' 0');
    tt(3)=text(log(ul+hp),-1,'-1'); 
    tt(4)=text(log(ul+hp),-2,'-2'); 
    tt(5)=text(log(ul+hp),-3,'-3'); 
    tt(6)=text(log(ul+hp),-4,'-4');
    set(tt,'FontSize',6);
    set(tt,'HorizontalAlignment','right');
    vp=0.9935;
    tt(1)=text(log(x0),log(-log(1-vp)),'1'); 
    tt(2)=text(2,log(-log(1-vp)),'2'); 
    tt(3)=text(4,log(-log(1-vp)),'4'); 
    tt(4)=text(3,log(-log(1-vp)),'3'); 
    tt(5)=text(0,log(-log(1-vp)),'0'); 
    set(tt,'FontSize',6);
    set(tt,'VerticalAlignment','middle');
    r=0.6; a=r; b=r*11.9/8.15;a0=0.2*a; b0=0.2*b; 
    for k=[0.05,0.2,0.4,0.7,1,1.4,2,3,5,11], 
      th=atan(k);
      plot([a0*cos(th),a*cos(th)],[b0*sin(th),b*sin(th)],'r-');
      tt=text(1.1*a*cos(th),1.1*b*sin(th),num2str(k));
      set(tt,'FontSize',6);
      %set(tt,'HorizontalAlignment','center');
      set(tt,'rotation',180*th/pi);
    end
    set(gca,'Xtick',log([[1:0.5:10],[14:2:50],[60:10:ul]]));
    XTickLabels=[];
    xtl=[[1:0.5:10],[14:2:50],[60:10:ul]]';
    xtskip=[[1.5:1:9.5],16,18,[22:2:28],[32:2:38],[42:2:48],60,80,100]';
    for kk=1:length(xtl),
      xxx=num2str(xtl(kk));
      xxl=length(xxx);
      if xxl<2,
        for kkk=1:2-xxl, xxx=[xxx,' ']; end
      else xxx=xxx(1:2);
      end
      for kkk=1:length(xtskip),
        if xtl(kk)==xtskip(kkk), xxx=['  ']; end
      end
      XTickLabels=[XTickLabels;xxx];
    end
    set(gca,'XtickLabels',XTickLabels);
    axis([log(0.5),log(ul),log(-log(1-0.01)),log(-log(1-0.99))])
    set(gca,'FontSize',10)
    title('Weibullpapper')
    hold off
  else
    plot(log(z),log(-log(1-pltpos)),plotsymb);
    title('Weibull Probability Plot');
  end
  Yticks=log(-log(1-[0.01,0.05,0.10,0.20,0.30,0.40,0.50,0.60,0.70,0.80,0.90,0.95,0.99]'));
  YticLab=[' 1%';' 5%';'10%';'20%';'30%';'40%';'50%';'60%';'70%';'80%';'90%';'95%';'99%'];
end
if (typ=='expo'), 
  plot(z,-log(1-pltpos),plotsymb); 
  title('Exponential Probability Plot');
  Yticks=-log(1-[0.01,0.05,0.10,0.20,0.30,0.40,0.50,0.60,0.70,0.80,0.90,0.95,0.99]');
%  YticLab=[' 1%';' 5%';'10%';'20%';'30%';'40%';'50%';'60%';'70%';'80%';'90%';'95%';'99%'];
end
if (typ=='gumb'),
  if isempty(z), %z==[], % empty probability plot
    ul=20; 
    hold on
    x0=exp(1);
    for kk=-2:6,
      y1=exp(-exp(-kk));
      x1=exp(4.62); x1=ul;
      plot(([x1,0.97*x1]),-log(-log([y1,y1])),'r-');
      plot(([x1,1.03*x1]),-log(-log([y1,y1])),'r-');
    end
    hp=0.5; y0=exp(-exp(-0));   
    tt(1)=text((ul+hp),7,' 7');
    tt(2)=text((ul+hp),6,' 6');
    tt(3)=text((ul+hp),5,' 5');
    tt(4)=text((ul+hp),4,' 4');
    tt(5)=text((ul+hp),3,' 3');
    tt(6)=text((ul+hp),2,' 2');
    tt(7)=text((ul+hp),1,' 1'); 
    tt(8)=text((ul+hp),-log(-log(y0)),' 0');
    tt(9)=text((ul+hp),-1,'-1'); 
    tt(10)=text((ul+hp),-2,'-2'); 
    set(tt,'FontSize',6); set(tt,'HorizontalAlignment','right');
    set(gca,'Xtick',[1:20]);
    XTickLabels=[];
    xtl=[1:20]'; xtskip=[1:20]';
    for kk=1:length(xtl),
      xxx=num2str(xtl(kk));
      xxl=length(xxx);
      if xxl<2,
          for kkk=1:2-xxl, xxx=[xxx,' ']; end
      else xxx=xxx(1:2);
      end
      for kkk=1:length(xtskip),
         if xtl(kk)==xtskip(kkk), xxx=['  ']; end
      end
      XTickLabels=[XTickLabels;xxx];
    end
    set(gca,'XtickLabels',XTickLabels);
    axis([1,ul,-log(-log(0.001)),-log(-log(0.999))]);
    set(gca,'FontSize',10);
    title('Extremvärdespapper F(t)=exp(-e^{-t})')
    Yticks=-log(-log([0.001,0.01,0.05,0.10,0.20,0.30,0.40,0.50,0.60,0.70,0.80,0.90,0.95,0.99,0.999]'));
  YticLab=['.1%';' 1%';' 5%';'10%';'20%';'30%';'40%';'50%';'60%';'70%';'80%';'90%';'95%';'99%';'999'];
    hold off
  else
    plot(z,-log(-log(pltpos)),plotsymb); 
    title('Gumbel Probability Plot');
    Yticks=-log(-log([0.01,0.05,0.10,0.20,0.30,0.40,0.50,0.60,0.70,0.80,0.90,0.95,0.99]'));
    YticLab=[' 1%';' 5%';'10%';'20%';'30%';'40%';'50%';'60%';'70%';'80%';'90%';'95%';'99%'];
  end %else
end
grid on
%set(gca,'Ygrid','off');
%%%Xl=get(gca,'XLim');Xl=1.05*Xl;
Yl=get(gca,'YLim');
%set(gca,'YLim',npct(1-[0.005,0.995]));
%%%%set(gca,'YLim',npct(1-[0.003,0.997]));
set(gca,'Ytick',Yticks);
set(gca,'YtickLabels',YticLab);
%ylabel('Probability')
%ylabel('Kumulativ sannolikhet')
%xlabel('Data')
%hold off
 end %kk
if holdstate==0; hold off, end;
% end fcn




