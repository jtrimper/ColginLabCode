function [d]=classify(x,f,typ)
%
% CALL: [d]=classify(x,f,type)
%
  n=length(x);
  [m,two]=size(f);
  if ((m==1)&(two>1)),
    f=f';
    [m,two]=size(f);
  end
  if (two==1),
    if (typ(1:5)=='equal'), g=[f-10^3*eps,f]; end
    if (typ(1:5)=='split'), g=[[-Inf;f],[f;Inf]]; end
  end
  [m,two]=size(g);
  d=zeros(1,m);
  for j=1:m,
    for i=1:n,
      if ((g(j,1)<x(i))&(x(i)<=g(j,2))),
        d(i)=j;
    end
  end
%  dstar=n-sum(d);
end
