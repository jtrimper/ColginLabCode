function [p0,test,p]=fishxact(X)
%
%  Fisher's exact test
%  A test for homogeneity or independence in 2 by 2 tables.
%
% CALL : 
%        [P]=fishxact(X)
%        [P,test]=fishxact(X)
%        [P,test,p]=fishxact(X)
%
%   where   
%           X    = 2x2 table of frequencies,
%           P    = the extreme probability for the actual table X,
%           test = NS,*,**,*** depending on the extreme probability,
%           p    = a vector of probabilities for the possible tables.
%
nc=sum(X);
nr=sum(X');
n=sum(nr');
i=0;
for k=0:nr(1),
  a=k; b=nr(1)-a; c=nc(1)-a; d=nr(2)-c;
  if ((a>=0)&(b>=0)&(c>=0)&(d>=0)),
    i=i+1;
    p(i)=hyp(a,nr(1),nc(1),n);
    if (a==X(1,1)), i0=i; end  
  end
end
%p0=hyp(X(1,1),nr(1),nc(1),n);
[a,j]=sort(p);
b=cumsum(a);
for k=1:length(j),
  if (j(k)==i0), j0=k; end
end
p0=b(j0);
if (b(j0)>0.05), test='NS'; end
if (b(j0)<0.05), test='*'; end
if (b(j0)<0.01), test='**'; end
if (b(j0)<0.001), test='***'; end
end

                                   
