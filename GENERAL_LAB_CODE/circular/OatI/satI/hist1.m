function [un,ux]=hist1(z,level,b)
% 
% CALL: hist1(y)
%       hist1(y,nb)
%       hist1(y,x)
%       [n,x]=hist1(y,...)
%
[n,p]=size(z); % assume y and level have the same size
if (nargin<2), 
 level=1*ones(n,p);
end
[nl,pl]=size(level);
%if (pl==1),
% level=level*ones(1,p);
%end
%s=[];
for u=1:p,
  grps=0;
  for i=1:n,
    l=level(i,u);
    defok='false';
    for k=1:grps,
      if (l==grp(k)), defok='true'; end
    end
    if (defok(1:4)=='fals'),
      grps=grps+1;
      grp(grps)=l;
    end
  end
  [rm cm]=size(z);
%  for j=1:grps,
%     C(j,1)=0.0;
%  end
%  for i=1:rm,
%    if (finite(x(i,u))),
%      for j=1:grps,
%         if level(i,u)==grp(j),
%           C(j,1)=C(j,1)+x(i,u); 
%         end
%      end
%    end
%  end;
%  for i=1:grps,
%    m(i,u)=C(i,1);
%  end;
%  s1=sqrt((C2-C.*C./N)./(N-1));
%  s=[s,s1];
%  Nn=[Nn,N];
end % u
%end
z
grps
for j0=1:grps,
  j1=0;
  for i=1:rm,
    if (finite(z(i,1))),
      if level(i,1)==grp(j0),
        j1=j1+1;
        y(j1,1)=z(i,1);
      end
    end
  end
%if nargin==1,
  [n,x]=hist(y);
%end
%if nargin==2,
%  [n,x]=hist(y,b);
%end
  [rx,cx]=size(x);
  if rx>cx, nx=rx; 
  else 
    nx=cx;
  end
  x=[x,x(nx)+x(nx)-x(nx-1)];
  x=[x(1)-(x(2)-x(1)),x];
  n=[0,n,0];
  if nargout==0,
    [rx,cx]=size(x);
    if rx>cx, nx=rx;
    else 
      nx=cx;
    end  
    for j=1:nx,
      d=(x(2)-x(1))/2;
      plot3([x(j)-d;x(j)-d],[j0;j0],[0;n(j)],'-') 
      hold on
      plot3([x(j)+d;x(j)+d],[j0;j0],[0;n(j)],'-') 
      plot3([x(j)-d;x(j)+d],[j0,j0],[n(j);n(j)],'-')
    end 
  else
    un=n; ux=x;
  end
end
end

