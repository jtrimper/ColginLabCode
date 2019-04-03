function [F]=tcdf(x,nu)
%
% CALL: tcdf(x,nu)
%
th=atan(x/sqrt(nu));
if (fix(nu/2)*2==nu), 
  even=1;
else 
  even=0;
end
if (even==1),
 sum=1;
 p=(nu-2)/2;
 pr=1;
 for i=1:p,
  pr=pr*(2*i-1)/(2*i);
  sum=sum+pr*(cos(th))^(2*i);
 end
 sum=sum*sin(th);
else
 sum=0;
 p=(nu-3)/2;
 if p>0,
  pr=1;
  sum=1;
  for i=1:p,
   pr=pr*(2*i)/(2*i+1);
   sum=sum+pr*(cos(th))^(2*i);
  end
 end
 sum=2*(th+sum*sin(th)*cos(th))/pi;
end
F=sum+(1.0-sum)/2;
%end
