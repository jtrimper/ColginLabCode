function [d]=classify(x,f)
%
%
  n=length(x);
  m=length(f);
  for i=1:n,
    for j=1:m,
      if (x(i)==f(j)),
        d(i)=j;
      end;
    end
  end
  dstar=n-sum(d);
end
