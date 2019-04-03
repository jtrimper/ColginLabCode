function [r,p,test]=vtest(x,m)
% 
% CALL: 
%       [r,p,test]=vtest(x)
%
%   where   x    = a vector of directions (in degrees),
%           m    = mode direction (in degrees)
%           r    = vector length,
%           p    = extreme probability of vector length under uniformity,
%           test = significance of vector length. 
%
  [A,r,n]=circmean(x)
  c=r*(A(1)*cos(m*pi/180)+A(2)*sin(m*pi/180));
  if (n<=50), 
%    if (c>vpct(0.001,n)), test='***'; p=0.001; 
%    else
    if (c>vpct(0.01,n)), test='**'; p=0.01;
    elseif (c>vpct(0.05,n)), test='*'; p=0.05;
    else test='NS';
    end
  else p=2*min(ncdf(sqrt(2*n)*c),1-ncdf(sqrt(2*n)*c)); test=dotest(p);
  end
end
