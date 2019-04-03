function circle(M,deg)
%
% Plots 
%
% CALL: circle(x,deg)
%
% where
%
%     x  = column vector,
% Copyright 1993, Bjorn Holmquist, Dept of Math. Stat., University of Lund.
if (nargin>0)
%%  disp(['  At least one parameter!'])
%%else 
%  if (nargin==3)
%    clg, hold off, subplot(1,1,1)
%   else
%    clg, hold off, subplot(1,2,1)
%  end
%  subplot(1,2,1)
%  hold off
  X=cos(2*pi*[0:360]/360);
  Y=sin(2*pi*[0:360]/360);
  hold on
  axis([-1.1,1.1,-1.1,1.1]);
  axis('off')
  axis('equal') %axis('square') 
  plot(X,Y) %plot(X,Y,'w--')
  hold on
%  if (nargin==2)
    if (deg(1:3)=='rad')
      plot(cos(M(:,1)),sin(M(:,1)),'wo')
    else
     plot(1.05*cos(pi*(90-M(:,1))/180),1.05*sin(pi*(90-M(:,1))/180),'wo')
    end
%    text(0,0,'*','Color','w')
%    gtext('*')
%    text(0,0,'*','Color','k')
    text(0,1.03,'^','HorizontalAlignment','center') 
    text(0,1.2,'N','HorizontalAlignment','center') %,'Rotation',90)
    text(1.2,0,'E','VerticalAlignment','middle','HorizontalAlignment','center')
    text(0,-1.2,'S','HorizontalAlignment','center')
    text(-1.2,0,'W','VerticalAlignment','middle','HorizontalAlignment','center')
%%    set(gca,'Xlabel',text(0,0,'und text'))
%  end
%%  if (nargin==3)
%%    axis([-5.5,5.5,-1.25,1.25]); axis('square')
%%    title(T)
%%  end
%  subplot(1,2,1)
end
hold
%end
