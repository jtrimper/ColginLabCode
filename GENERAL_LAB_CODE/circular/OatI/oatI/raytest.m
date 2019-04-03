function [r,p,test]=raytest(x)
% 
% CALL: 
%       [r,p,test]=raytest(x)
%
%   where   x    = a vector of directions (in degrees),
%           r    = vector length,
%           p    = extreme probability of vector length under uniformity,
%           test = significance of vector length. 
%
  [A,r,n]=circmean(x);
  if (n<=100), 
    if (r>raypct(0.001,n)), test='***'; p=0.001; 
    elseif (r>raypct(0.01,n)), test='**'; p=0.01;
    elseif (r>raypct(0.05,n)), test='*'; p=0.05;
    else test='NS';
    end
  else p=exp(-n*r*r); test=dotest(p);
  end
end
