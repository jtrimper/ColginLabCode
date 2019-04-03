function orient(M,deg)
% 
% Calculates the orientogram
%
% CALL: orient(x,deg);
%
% where 
%  
%     x   = vector of circular directions,
%     deg = 'deg' if directions are in degrees.
%
% Copyright (C) 1993, Bjorn Holmquist, Dept of Math. Stat., University of Lund.
%
if (nargin>0)
  if (nargin==1)
    torad=pi/180.0;
  end
  if (nargin==2)
    if (deg(1:3)=='rad')
      torad=1.0; 
    else
      torad=pi/180.0;
    end
  end
  [ro,co]=size(M);
  subplot(2,2,1)
  circplot(M,deg)
  subplot(2,2,2)
  axis([0,5,0,1]);
%  axis('off')
  axis('equal') %axis('square') 
  k=[0:0.1:5]; 
  ettn=ones(ro,1);
  C=cos(torad*k'*M')*ettn; 
  S=sin(torad*k'*M')*ettn; 
  r=sqrt(C.*C+S.*S)/ro;
  plot(k,r);
  title('Orientogram')
%%    set(gca,'Xlabel',text(0,0,'und text'))
%end fcn


