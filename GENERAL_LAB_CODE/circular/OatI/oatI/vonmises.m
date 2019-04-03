function [d]=vonmises(x,kappa,degmu)
%
% CALL: [d]=vonmises(x,kappa,degmu) 
%
  [r,c]=size(x);
  for i=1:r,
    for j=1:c,
      x0=x(i,j);
      d(i,j)=exp(kappa*cos((x0-degmu)*pi/180))/(2*pi*i0(kappa));
    end
  end
end
