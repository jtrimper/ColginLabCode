function [d]=weibcdf(x,c,a)
%
% CALL: [d]=weibcdf(x,c,a) 
%
  [r,c]=size(x);
  for i=1:r,
    for j=1:c,
      x0=x(i,j);
      if (x0>0), 
      d(i,j)=1-exp(-(x0/a)^c);
      else 
      d(i,j)=0;
      end
    end
  end
end
