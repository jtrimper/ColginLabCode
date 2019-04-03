function [d]=gumbcdf(x,a,u)
%
% CALL: [d]=gumbcdf(x,a,u) 
%
  [r,c]=size(x);
  for i=1:r,
    for j=1:c,
      x0=x(i,j);
%      if (x0>0), 
      d(i,j)=exp(-exp(-a*(x0-u)));
%      else 
%      d(i,j)=0;
%      end
    end
  end
end
