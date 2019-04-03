function [t,df]=ttest2(x,y,mdiff)
% 
% CALL: [t,df]=ttest2(x,y,mdiff)
%
%   where   x     = a vector of real valued numbers
%           y     = another vector of real valued numbers
%           mdiff = a scalar hypothetical value
%
[m1,s1,n1]=medel(x);
[m2,s2,n2]=medel(y);
sp=sqrt(((n1-1)*s1^2+(n2-1)*s2^2)/(n1+n2-2));
t=(m1-m2-mdiff)/(sp*sqrt(1/n1+1/n2))
if (abs(t)>tqnt(0.025,n1+n2-2)),
% disp('* significant')
end
if (abs(t)>tqnt(0.005,n1+n2-2)),
% disp('** significant')
end
if (abs(t)>tqnt(0.0005,n1+n2-2)),
% disp('*** significant')
end
df=n1+n2-2;
%p=tqnt(t,n-1);
end                         
