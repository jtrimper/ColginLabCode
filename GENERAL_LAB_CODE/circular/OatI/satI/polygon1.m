function [un,ux]=polygon1(z,level,b)
% 
% CALL: hist1(y)
%       hist1(y,nb)
%       hist1(y,x)
%       [n,x]=hist1(y,...)
%
[n,p]=size(z); % assume y and level have the same size
[nl,pl]=size(level);
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
end % u
%z
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
  end % i
  [n,x]=hist(y);
  [rx,cx]=size(x);
  if rx>cx, nx=rx; 
  else 
    nx=cx;
  end
  x=[x,x(nx)+x(nx)-x(nx-1)];
  x=[x(1)-(x(2)-x(1)),x];
  n=[0,n,0];
  if nargout==0,
   % [rx,cx]=size(x);
   % if rx>cx, 
   %   nx=rx;
   % else 
   %   nx=cx;
   % end  
   % for j=1:nx,
     for j=2:nx+2,
   %   d=(x(2)-x(1))/2;
   %   plot3([x(j)-d;x(j)-d],[j0;j0],[0;n(j)],'-') 
   %   hold on
   %   plot3([x(j)+d;x(j)+d],[j0;j0],[0;n(j)],'-') 
   %   plot3([x(j)-d;x(j)+d],[j0,j0],[n(j);n(j)],'-')
   % end 
      d=(x(2)-x(1))/2;
      plot3([x(j)-d;x(j)+d],[j0;j0],[n(j-1);n(j)],'-') 
      hold on
   %   plot3([x(j)+d;x(j)+d],[j0;j0],[0;n(j)],'-') 
   %   plot3([x(j)-d;x(j)+d],[j0,j0],[n(j);n(j)],'-')
    end 
%   plot3(x,j0*ones(size(x)),n,'-');
% drawnow
%  hold on
%  j0
  else
    un=n; ux=x;
  end
end
end

