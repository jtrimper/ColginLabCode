function [t,df]=corrtest(x,y)
% 
% CALL: 
%       [t,df]=corrtest(x,y)
%
%   where   x     = a vector of real valued numbers
%           y     = another vector of real valued numbers
%
 [m,s,n]=medel(x);
t=sqrt(n)*(m-m0)/s;
df=n-1;         
p=tqnt(t,n-2);
end
[m1,s1,n1]=medel(x);
[m2,s2,n2]=medel(y);
sp=sqrt(((n1-1)*s1^2+(n2-1)*s2^2)/(n1+n2-2));
t=(m1-m2-mdiff)/(sp*sqrt(1/n1+1/n2));


%if (abs(t)>tqnt(0.025,n1+n2-2)),
% disp('* significant')
%end
%if (abs(t)>tqnt(0.005,n1+n2-2)),
% disp('** significant')
%end
%if (abs(t)>tqnt(0.0005,n1+n2-2)),
% disp('*** significant')
%end
df=n1+n2-2;
%p=tqnt(t,n-1);
end                         
end
