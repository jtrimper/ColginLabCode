function [t,df]=ttest(a,b,c)
% 
% CALL: 
%       [t,df]=ttest(x,m0)
%       [t,df]=ttest(x,y,mdiff)
%       [t,df]=ttest(Y);
%
%   where   x     = a vector of real valued numbers
%           m0    = a scalar hypothetical value
%           y     = another vector of real valued numbers
%           mdiff = a scalar hypothetical value 
%           Y     = a matrix real-valued number whose columns are variables
%                   to be compared pairwise in a paired t-test
%
if (nargin==1),
  [ra,ca]=size(a);
  [m,s,n]=mean1(a);
  for j1=1:ca-1,
    for j2=j1+1:ca,
       [t1,df1]=ttest(a(:,j1)-a(:,j2),0);
       t(j1,j2)=t1; df(j1,j2)=df1;
    end
  end
end
if (nargin==2), 
  x=a; m0=b;
  [m,s,n]=mean1(x);
  t=sqrt(n)*(m-m0)/s;
  df=n-1;
  %p=tqnt(t,n-1);
end
if (nargin==3),
  x=a(:); y=b(:); mdiff=c;
  [m1,s1,n1]=mean1(x);
  [m2,s2,n2]=mean1(y);
  sp=sqrt(((n1-1)*s1^2+(n2-1)*s2^2)/(n1+n2-2));
  t=(m1-m2-mdiff)/(sp*sqrt(1/n1+1/n2));
  df=n1+n2-2;
  %p=tqnt(t,n-1);
end                         
%end



