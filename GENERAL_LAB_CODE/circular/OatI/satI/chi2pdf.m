function [d]=chi2pdf(x,nu)
%
% CALL: [d]=chi2pdf(x,nu) 
%
  [r,c]=size(x);
  for i=1:r,
    for j=1:c,
      x0=x(i,j);
      if (x0>0), 
      d(i,j)=x0^(nu/2-1)*exp(-0.5*x0)/(2^(nu/2)*gamma(nu/2));
      else 
      d(i,j)=0;
      end
    end
  end
end
