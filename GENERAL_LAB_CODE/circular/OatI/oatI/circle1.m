function circle(M,T,U)
% Plot column 1 against column 2 in the two column matrix M. The second
% argument is optional and contains text.
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., University of Lund.

if (nargin==0)
  disp(['  At least one parameter!'])
else 
  [rows cols]=size(M);
  if (nargin==3)
    clg, hold off, subplot(1,1,1)
  else
    clg, hold off, subplot(1,2,1)
  end
  subplot(1,2,1)
  for i=1:37,
    X(i)=cos(2*pi*(i-1)/36);
    Y(i)=sin(2*pi*(i-1)/36);
  end
  xskala=-1.5:0.5:1.5;
  yskala=-1.25:0.25:1.25;
  hold on
  axis([-1.1,1.1,-1.1,1.1]);
  axis('off')
  axis('equal') %axis('square') 
  plot(X,Y) %plot(X,Y,'w--')
  hold on
  if (nargin==2)
    if (cols==2)
      plot(M(:,1),M(:,2),'w*')
    end
  end
  if (nargin==3)
    if (U=='radians')
      plot(cos(M(:,1)),sin(M(:,1)),'wo')
    else
      plot(0.95*cos(pi*M(:,1)/180),0.95*sin(pi*M(:,1)/180),'wo')
    end
%  text('Rotation',90)
%rect=[0 0.4 0.7 0.4]
    text(0,0,'*','Color','w')
    gtext('*')
    text(0,0,'*','Color','k')
    text(0,1.03,'^','HorizontalAlignment','center') 
    text(0,1.2,'N','HorizontalAlignment','center') %,'Rotation',90)
    text(1.2,0,'E','VerticalAlignment','middle','HorizontalAlignment','center')
    text(0,-1.2,'S','HorizontalAlignment','center')
    text(-1.2,0,'W','VerticalAlignment','middle','HorizontalAlignment','center')
    set(gca,'Xlabel',text(0,0,'und text'))
  end
  if (nargin==3)
    subplot(1,2,2)
    hold on
    axis([-5.5,5.5,-1.25,1.25]); axis('square')
    if (cols==2)
      plot(M(:,1),M(:,2),'wo')
    end
    title(T)
  end
  subplot(1,2,1)
  hold on
end


















