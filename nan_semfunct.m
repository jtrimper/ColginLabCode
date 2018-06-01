function sem = nan_semfunct(x,dim)
% function sem = nan_semfunct(x,dim)
%
% SUMMARY: 
%   Function to calculate the standard error of the sample mean along the dimension specified. 
%    *This version ignores NaNs (and does not count them in the denominator)
% 
% INPUT: 
%   x = vector or matrix of values
%   dim = the dimension along which the standard error should be calculated
%
%
% JB Trimper
% 8/15
% Manns Lab

if nargin == 1
    allDims = size(x);
    dim = find(allDims > 1, 1, 'First');
end

sem = nanstd(x,0,dim) ./ sqrt(sum(~isnan(x),dim));

end

