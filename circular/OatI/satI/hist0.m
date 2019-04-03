function [un,ux,p1,p2,p3]=hist0(y,b,normera)
% 
% CALL: hist0(y)
%       hist0(y,nb)
%       hist0(y,x)
%       [n,x]=hist0(y,...)
%
%       n=hist0(y) bins the elements of y into 10 equally spaced
%       containers and returns the number of elements in each container.
% 
%       n=hist0(y,m), where m is a scalar, uses m bins.
%
%       n=hist0(y,x), where x is a vector, returns the distribution of x
%       among bins with centers specified by x.
% 
%       [n,x]=hist0(...) also returns the position of the bin centers in X.
% 
%       hist0(...) without output arguments produces a histogram bar plot of
%       the results.

holdstate=ishold;
if nargin==1,
  [n,x]=hist(y);
end
if nargin>1,
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
if normera==1, n=n/(sum(n)*(x(2)-x(1))); end
%  if nargout==0,
  if nargout~=2,
    [rx,cx]=size(x);
    if rx>cx, nx=rx;
    else 
      nx=cx;
    end  
    for j=1:nx,
      d=(x(2)-x(1))/2;
      p1(j)=plot([x(j)-d;x(j)-d],[0;n(j)],'-');
      hold on
      p2(j)=plot([x(j)+d;x(j)+d],[0;n(j)],'-');
      p3(j)=plot([x(j)-d;x(j)+d],[n(j);n(j)],'-');
    end 
  else
    un=n; ux=x;
  end
%lineplot(y,y)
if holdstate==0; hold off, end
%end fcn







