function [R,N,p,H,test,SR,C]=kruswall(y,level)
%
% CALL : 
%          [R,N,p,H,test]=kruswall(y,level)
%
%   where   
%           y    = vector of values
%           level= vector of categories
%           R    = vector of rank sums for different categories
%           p    = the extreme probability for the actual configuration
%           test = NS,*,**,*** depending on the extreme probability
[r,k]=size(y);
n=length(y);
z=y;
grps=0;
for i=1:n,
 l=level(i);
 defok='false';
 for k=1:grps,
   if (l==grp(k)), defok='true'; end
 end
 if (defok(1:4)=='fals'),
   grps=grps+1;
   grp(grps)=l;
 end
end
[a,i]=sort(z);
%grp
for l=1:grps,
  Rx(l)=0;
  N(l)=0;
end
%%941123
a=rank1(z);
for k=1:length(z),
  for l=1:grps,
    if level(k)==grp(l),
      Rx(l)=Rx(l)+a(k);
      N(l)=N(l)+1;
    end
  end
end
H=0; Q=0;
%SR=0;
for l=1:grps,
  Q=Q+N(l)*(Rx(l)/N(l)-(n+1)/2)^2;
  H=H+Rx(l)^2/N(l);
%  SR=SR+sum(Rx(l).^2)
end
SR=sum(a.^2);
C=n*(n+1)^2/4;
H=H*12/(n*(n+1));
H=H-3*(n+1);
df=grps-1;
p=1-chi2cdf(H,df);
test=dotest(p);
%end

                                   

