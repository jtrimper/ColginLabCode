function [Q,df,O,E]=chi2(x,p)
%
% CALL: [Q,f,O,E]=chi2(x,p)
%       [Q,f,O,E]=chi2(X)
%
%   where  x = a vector of outcomes in different categories,
%          p = a vector of hypothetical probabilities in different categories,
%          X = a matrix of outcomes in differens categories for different
%              populations.
%
%          Q = Pearson's chi-square statistic,
%          f = number of categories minus 1,
%          O = observed outcomes,
%          E = expected outcomes under hypothesis.
%
[rx,cx]=size(x);
if ((rx==1)|(cx==1)),
if (rx*cx==rx),
  y=x';
  r=rx;
else
  y=x;
  r=cx;
end
if (nargin==1), 
  q=ones(1,r)/r;
else
  [rp,cp]=size(p);
  if (rp>cp),
    q=p';
  else
    q=p;
  end
end
n=y*ones(r,1);
v=(y-n*q).^2./(n*q);
O=y;
E=n*q;
X=v*ones(r,1);
df=r-1;
Q=sum(sum(v)');
else
y=x;
[ry,cy]=size(y);
ps=ones(1,ry)*y;
ns=y*ones(cy,1);
v=(y-ns*ps/sum(ns)).^2./(ns*ps/sum(ns));
O=y;
E=ns*ps/sum(ns);
Q=sum(sum(v)');
df=(ry-1)*(cy-1);
end
%end

