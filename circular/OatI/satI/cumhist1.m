function [un,ux]=cumhist1(y,b)
% 
% CALL: hist1(y)
%       hist1(y,nb)
%       hist1(y,x)
%       [n,x]=hist1(y,...)
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
  n=[0,n,0]; n=cumsum(n);
  if nargout==0,
    [rx,cx]=size(x);
    if rx>cx, nx=rx;
    else 
      nx=cx;
    end  
    for j=1:nx,
      d=(x(2)-x(1))/2;
      plot([x(j)-d;x(j)-d],[0;n(j)],'-') 
      hold on
      plot([x(j)+d;x(j)+d],[0;n(j)],'-') 
      plot([x(j)-d;x(j)+d],[n(j);n(j)],'-')
    end 
  else
    un=n; ux=x;
  end
%lineplot(y,y)
end

