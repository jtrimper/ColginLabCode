function [un,ux]=polygon(y,b)
% 
% CALL: polygon(y)
%       polygon(y,nb)
%       polygon(y,x)
%       [n,x]=polygon(y,...)
%
if nargin==1,
  [n,x]=hist(y);
end
if nargin==2,
  [n,x]=hist(y,b);
end
  [rx,cx]=size(x);
  if rx>cx, nx=rx; 
  else 
    nx=cx;
  end
  x=[x,x(nx)+x(nx)-x(nx-1)];
  x=[x(1)-(x(2)-x(1)),x];
  n=[0,n,0]; 
  if nargout==0,
     plot(x,n,'-');
  else
    un=n; ux=x;
  end
end

