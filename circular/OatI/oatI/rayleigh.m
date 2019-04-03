function [d]=rayleigh(x,a)
%
% CALL: [d]=rayleigh(x,a) 
%
  [r,c]=size(x);
  for i=1:r,
    for j=1:c,
      x0=x(i,j);
      if (x0>0), 
      d(i,j)=2*x0*exp(-x0^2/a^2)/(a^2);
      else 
      d(i,j)=0;
      end
    end
  end
end
