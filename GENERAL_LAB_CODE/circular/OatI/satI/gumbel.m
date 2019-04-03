function [d]=gumbel(x,a,u)
%
% CALL: [d]=gumbel(x,a,u) 
%
  [r,c]=size(x);
  for i=1:r,
    for j=1:c,
      x0=x(i,j);
%      if (x0>0), 
      d(i,j)=a*exp(-exp(-a*(x0-u))-a*(x0-u));
%      else 
%      d(i,j)=0;
%      end
    end
  end
end
