function [d,dstar]=sectclfy(x,f,typ)
%
%
  n=length(x);
  [m,two]=size(f);
  if ((m==1)&(two>1)),
    f=f';
    [m,two]=size(f);
  end
  if (two==1),
    if (typ(1:5)=='equal'), g=[f-10^3*eps,f]; end
    if (typ(1:5)=='split'), g=[[f(m);f(1:m-1)],f], end
  end
  [m,two]=size(g);
  d=zeros(1,m);
  for j=1:m,
    for i=1:n,
      if ((sin(x(i)-g(j,1))>0)&(sin(x(i)-g(j,2))<=0)),
        d(i)=j;
    end
  end
  dstar=n-sum(d);
end
