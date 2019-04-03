function [d]=exppdf(x,m)
%
% CALL: [d]=exppdf(x,m) 
%
  [r,c]=size(x);
  for i=1:r,
    for j=1:c,
      x0=x(i,j);
      if (x0>0), 
      d(i,j)=exp(-x0/m)/m;
      else 
      d(i,j)=0;
      end
    end
  end
end
