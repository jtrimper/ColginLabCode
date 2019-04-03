function [U,p1,p2]=mannwhit(x,y)
%
% CALL: [U,p1,p2]=mannwhit(x,y)
%
m=length(x); n=length(y);
U=0;
for i=1:m,
  U=U+sum(y<x(i));
end
if U<m*n/2,
  p2=2*sum(MWprob([0:U],m,n));
  p1=sum(MWprob([0:U],m,n));
end
if U>=m*n/2,
  p2=2*sum(MWprob([U:m+n],m,n));
  p1=sum(MWprob([U:m+n],m,n));
end
