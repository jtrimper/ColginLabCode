function [n]=s2hist(x,e)
%
%  Calculates the number of observations in different sectors
%
% CALL: [n]=s2hist(x,e);
%
% where
%
%     x  = a vector of directions (in degrees),
%     e  = a vector of sector directions (in degrees).
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., University of Lund.
[re ce]=size(e);
[rx,cx]=size(x);
if e(1)>0, e(1)=e(1)-360;
end
d=[e,e(1)+360];
if d(1)>360, d(1)=d(1)-360;
end
for j=1:ce,
  n(j,1)=0;
end
for i=1:rx,
  for j=1:ce,
if (sin(pi*(x(i,1)-d(j))/180)>0)&(sin(pi*(x(i,1)-d(j+1))/180)<=0)
     n(j,1)=n(j,1)+1; 
    end
  end
end
  X=cos(2*pi*[0:360]/360);
  Y=sin(2*pi*[0:360]/360);
  hold on
%  axis([-1.1,1.1,-1.1,1.1]);
  axis([-2.1,2.1,-2.1,2.1]);
   axis('off')
  axis('equal') 
  plot(X,Y) 
  hold on
  nt=sum(n);
  [re,ce]=size(e);
  d=[e,e(1)+360];
  for j=1:ce,
    r0=sqrt(n(j,1)/nt)
    a1=cos(pi*(90-d(j))/180);
    b1=(1+r0)*cos(pi*(90-d(j))/180);
    c1=sin(pi*(90-d(j))/180);
    d1=(1+r0)*sin(pi*(90-d(j))/180);
    plot([a1;b1],[c1;d1],'-')
    a1=cos(pi*(90-d(j+1))/180);
    b1=(1+r0)*cos(pi*(90-d(j+1))/180);
    c1=sin(pi*(90-d(j+1))/180);
    d1=(1+r0)*sin(pi*(90-d(j+1))/180);
    plot([a1;b1],[c1;d1],'-')
%    plot([0;cos(pi*(90-d(j))/180)],[0;sin(pi*(90-d(j))/180)],'-')
    r0=sqrt(n(j,1)/nt)
%    for k=0:0.008:1,
      if r0>0,
      k0=0; k1=1;
      a0=(1+r0)*cos(pi*(90-d(j)-k0*(d(j+1)-d(j)))/180);
      c0=(1+r0)*sin(pi*(90-d(j)-k0*(d(j+1)-d(j)))/180);
      b0=(1+r0)*cos(pi*(90-d(j)-k1*(d(j+1)-d(j)))/180);
      d0=(1+r0)*sin(pi*(90-d(j)-k1*(d(j+1)-d(j)))/180);
      plot([a0;b0],[c0;d0],'-')
      end
%     plot([0;r0*cos(pi*(90-d(j)-k*(d(j+1)-d(j)))/180)],[0;r0*sin(pi*(90-d(j)-k*(d(j+1)-d(j)))/180)],'-')
%    end
  end
 for j=1:ce,
  dpos=(d(j)+d(j+1))/2;
% y= yellow, m=mangenta, c=cyan, r=red, g=green, b=blue, w=white, k=black
%    r0=0.20;
%    for k=0:0.004:1,
%      a0=0.7*cos(pi*(90-dpos)/180);
%      b0=0.7*cos(pi*(90-dpos)/180)+r0*cos(pi*(90-dpos-k*360)/180)
%      c0=0.7*sin(pi*(90-dpos)/180);
%      d0=0.7*sin(pi*(90-dpos)/180)+r0*sin(pi*(90-dpos-k*360)/180);
%      plot([a0;b0],[c0;d0],'k-')
%      plot([0.7*cos(pi*(90-dpos)/180);0.7*cos(pi*(90-dpos)/180)+r0*cos(pi*(90-dpos-k*360)/180)],[0.7*sin(pi*(90-dpos)/180);0.7*sin(pi*(90-dpos)/180)+r0*sin(pi*(90-dpos-k*360)/180)],'k-')
    end
%text(0.7*cos(pi*(90-dpos)/180),0.7*sin(pi*(90-dpos)/180),[num2str(100*n(j,1)/nt),'%'],'VerticalAlignment','middle','HorizontalAlignment','center','Color','y')
  end
end
