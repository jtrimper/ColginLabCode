function [d]=maxwell(x,a)
%
% CALL: [d]=maxwell(x,a) 
%
  [r,c]=size(x);
  for i=1:r,
    for j=1:c,
      x0=x(i,j);
      if (x0>0), 
      d(i,j)=4*x0^2*exp(-x0^2/a^2)/(a^2*sqrt(pi));
      else 
      d(i,j)=0;
      end
    end
  end
end
