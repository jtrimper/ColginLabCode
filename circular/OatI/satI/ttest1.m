function [t,df]=ttest(x,m0)
% 
% CALL: [t,df]=ttest(x,m0)
%
%   where   x  = a vector of real valued numbers
%           m0 = a scalar hypothetical value
%
[m,s,n]=medel(x);
t=sqrt(n)*(m-m0)/s;
if (abs(t)>tqnt(0.025,n-1)),
% disp('* significant')
end
if (abs(t)>tqnt(0.005,n-1)),
% disp('** significant')
end
if (abs(t)>tqnt(0.0005,n-1)),
% disp('*** significant')
end
df=n-1;
%p=tqnt(t,n-1);
end
