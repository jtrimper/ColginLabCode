function meanplot(X,Y,C)
%
% CALL: meanplot(y,c)
%       meanplot(x,y,c)
%
if (nargin==1),
 x=[1:length(X)]';
 y=X;
 c=0*ones(length(X),1);
end
if (nargin==2),
 x=[1:length(X)]';
 y=X;
 c=Y;
end
if (nargin==3),
 x=X;
 y=Y;
 c=C;
end
plot([x';x'],[y'-c';y'+c'],'w-');
hold
plot(x,y,'w+');
hold
end
