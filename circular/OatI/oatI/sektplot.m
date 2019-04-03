function sectplot(n,e)
%
% Plots 
%
% CALL: sectplot(n,e)
%
% where
%
%     n  = column vector of variable number,
%     e  = directions of circle sectors.
%
% Copyright 1993, Bjorn Holmquist, Dept of Math. Stat., University of Lund.
if (nargin>0)
  X=cos(2*pi*[0:360]/360);
  Y=sin(2*pi*[0:360]/360);
  hold on
  axis([-1.1,1.1,-1.1,1.1]);
  axis('off')
  axis('equal') 
  plot(X,Y) 
  hold on
  nt=sum(n);
  [re,ce]=size(e);
  d=[e,e(1)+360];
  for j=1:ce,
    plot([0;cos(pi*(90-d(j))/180)],[0;sin(pi*(90-d(j))/180)],'-')
%    for r0=0:0.01:n(j,1)/nt,
%     plot([r0*cos(pi*(90-d(j))/180);r0*cos(pi*(90-d(j+1))/180)],[r0*sin(pi*(90-d(j))/180);r0*sin(pi*(90-d(j+1))/180)],'-')
%    end
     r0=n(j,1)/nt;
    for k=0:0.01:1,
      plot([0;r0*cos(pi*(90-d(j)-k*(d(j+1)-d(j)))/180)],[0;r0*sin(pi*(90-d(j)-k*(d(j+1)-d(j)))/180)],'-')
    end
  end
%  text(0,1.03,'^','HorizontalAlignment','center') 
%    text(0,1.2,'N','HorizontalAlignment','center') %,'Rotation',90)
    text(1.2,0,'E','VerticalAlignment','middle','HorizontalAlignment','center')
    text(0,-1.2,'S','HorizontalAlignment','center')
    text(-1.2,0,'W','VerticalAlignment','middle','HorizontalAlignment','center')
 for j=1:ce,
  dpos=(d(j)+d(j+1))/2;
% change color here !!!!!  
% y= yellow
% m=mangenta, c=cyan, r=red, g=green, b=blue, w=white, k=blacks
    r0=0.20;
    for k=0:0.005:1,
      plot([0.7*cos(pi*(90-dpos)/180);0.7*cos(pi*(90-dpos)/180)+r0*cos(pi*(90-dpos-k*360)/180)],[0.7*sin(pi*(90-dpos)/180);0.7*sin(pi*(90-dpos)/180)+r0*sin(pi*(90-dpos-k*360)/180)],'k-')
    end
  text(0.7*cos(pi*(90-dpos)/180),0.7*sin(pi*(90-dpos)/180),[num2str(100*n(j,1)/nt),'%'],'VerticalAlignment','middle','HorizontalAlignment','center','Color','y')
  end
end
hold
end
