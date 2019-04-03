function [d,dstar,v]=nofcases(x,f,typ,y)
%
% CALL: nofcases(x,f,type)
%       [d,dc,v]=nofcases(x,f,type)
%
% where   x  = variable of values
%         f  = vector of values
%         type = 'equal' or 'split'
%         d  = vector of frequency of the values of f in x. Same dim as f.
%         dc = number of values in x not in f.
%         v  = the values of x, represented in f.  
%
tol=exp(-20);
  n=length(x);
  [m,two]=size(f);
  if ((m==1)&(two>1)),
    f=f';
    [m,two]=size(f);
  end
  if (two==1),
    if (typ(1:5)=='equal'), g=[f-10^3*eps,f]; end
%   if (typ(1:5)=='equal'), g=[f-10^3*eps,f+10^3*eps]; end %970404
   if (typ(1:5)=='equal'), g=[f-tol,f+tol]; end %970509
    if (typ(1:5)=='split'), g=[[-Inf;f],[f;Inf]]; end
  end
  [m,two]=size(g);
  d=zeros(1,m); v=NaN*zeros(1,m);
%g
%x
  for j=1:m,
    for i=1:n,
%     i
%     g(j,1)
%g(j,2)
%x(i)
%g(j,1)-x(i)
%x(i)-g(j,2)
%x(1)-x(2)
      if ((g(j,1)<x(i))&(x(i)<=g(j,2))), d(j)=d(j)+1; end
        if nargin>3, v(j)=y(i); end
    end %i
  end %j
  dstar=n-sum(d);
%end %function




