function [d]=weibull(x,k,a)
%
% CALL: [d]=weibull(x,k,a) 
%
  [r,c]=size(x);
  for i=1:r,
    for j=1:c,
      x0=x(i,j);
      if (x0>0), 
      d(i,j)=k*x0^(k-1)*exp(-(x0/a)^k)/a^k;
      else 
      d(i,j)=0;
      end
    end
  end
end
