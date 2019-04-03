function [P,test]=signtest(a,b,c)
% 
% CALL: 
%       [P,test]=signtest(x,m0)
%       [P,test]=signtest(x,y,diff)
%
%   where   x     = a vector of real valued numbers,
%           m0    = a scalar hypothetical value,
%           y     = another vector of real valued numbers,
%           diff  = a scalar hypothetical value,
%           P     = the extreme probability of the actual outcome,
%           test  = number of negative differences.
%
if (nargin==2), 
x=a; m0=b;
%[m,s,n]=medel(x);
%t=sqrt(n)*(m-m0)/s;
t=sum(sign(x-m0)<0);
P=bincdf(t,length(x),0.5);
%if (abs(t)>tqnt(0.025,n-1)),
% disp('* significant')
%end
%if (abs(t)>tqnt(0.005,n-1)),
% disp('** significant')
%end
%if (abs(t)>tqnt(0.0005,n-1)),
% disp('*** significant')
%end
df=length(x);
%p=tqnt(t,n-1);
end
%function [t,df]=ttest2(x,y,mdiff)
% 
% CALL: [t,df]=ttest2(x,y,mdiff)
%
%   where   x     = a vector of real valued numbers
%           y     = another vector of real valued numbers
%           mdiff = a scalar hypothetical value
%
if (nargin==3),
x=a; y=b; mdiff=c;
%[m1,s1,n1]=medel(x);
%[m2,s2,n2]=medel(y);
%sp=sqrt(((n1-1)*s1^2+(n2-1)*s2^2)/(n1+n2-2));
%t=(m1-m2-mdiff)/(sp*sqrt(1/n1+1/n2));
t=sum(sign(x-y-mdiff)<0);
P=bincdf(t,length(x),0.5);
%if (abs(t)>tqnt(0.025,n1+n2-2)),
% disp('* significant')
%end
%if (abs(t)>tqnt(0.005,n1+n2-2)),
% disp('** significant')
%end
%if (abs(t)>tqnt(0.0005,n1+n2-2)),
% disp('*** significant')
%end
df=length(x);
%p=tqnt(t,n-1);
end                         
if (P>0.05), test='NS'; end
if (P<0.05), test='*'; end
if (P<0.01), test='**'; end
if (P<0.001), test='***'; end
end
