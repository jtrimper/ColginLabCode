function [d]=raycdf(x,a)
%
% CALL: [d]=raycdf(x,a) 
%
  [r,c]=size(x);
  for i=1:r,
    for j=1:c,
      x0=x(i,j);
      if (x0>0), 
      d(i,j)=1-exp(-x0^2/a^2);
      else 
      d(i,j)=0;
      end
    end
  end
end
