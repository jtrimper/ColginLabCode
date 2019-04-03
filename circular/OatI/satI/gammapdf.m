function [d]=gammapdf(x,r,a)
%
% CALL: [d]=gammapdf(x,r,a) 
%
  [r0,c]=size(x);
  for i=1:r0,
    for j=1:c,
      x0=x(i,j);
      if (x0>0), 
      d(i,j)=x0^(r-1)*exp(-x0/a)/(a^(r)*gamma(r));
      else 
      d(i,j)=0;
      end
    end
  end
end
