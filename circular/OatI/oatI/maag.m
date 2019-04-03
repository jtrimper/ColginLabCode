function [Uk]=maag(x,b,c,d,e,f,g,h,i,j); %varargin) %gingroup,c,d,e,f,g,h)
%
% CALL: [Uk]=maag(x,group)
%       [Uk]=maag(x1,x2,x3,...)

%if nargin>2,
%  group=ones(length(x),1);
%  antgrps=nargin;
%  for i=2:antgrps,
% varargin
%  varargin(1,i-1)
 %   x=[x;varargin(i-1,:)]
%  end
%end %else
if nargin>2,
  group=ones(length(x),1);
  x=[x;b]; group=[group;2*ones(length(b),1)];
else
  group=b;
end
if nargin>=3, x=[x;c]; group=[group;3*ones(length(d),1)];end
if nargin>=4, x=[x;d]; group=[group;4*ones(length(d),1)];end
if nargin>=5, x=[x;e]; group=[group;5*ones(length(e),1)];end
if nargin>=6, x=[x;f]; group=[group;6*ones(length(f),1)];end
if nargin>=6, x=[x;g]; group=[group;7*ones(length(g),1)];end
if nargin>=6, x=[x;h]; group=[group;8*ones(length(h),1)];end
if nargin>=6, x=[x;i]; group=[group;9*ones(length(i),1)];end
if nargin>=6, x=[x;j]; group=[group;10*ones(length(j),1)];end
%x
%group
[z,I]=sort(x);
vv=valuesof(group);
gr=group(I); N=length(z);
s=zeros(N,1);
vn=length(vv);
for jn=1:vn,
  j=vv(jn);
  J=find(gr==j);
  y=z(J); nj=length(y);
  d=ecdf(z,y);
  s=s+(nj/N)*d;
end
%s
Uk=0;
for jn=1:vn,
  j=vv(jn);
  J=find(gr==j);
  y=z(J); nj=length(y);
  Uj=nj*(sum((ecdf(z,y)-s).^2)-(sum(ecdf(z,y)-s)).^2/N)/N;
  Uk=Uk+Uj;
end %for j
%end
%Uk=varargin;


