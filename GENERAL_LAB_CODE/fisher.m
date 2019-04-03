function z = fisher(r)
% function z = fisher(r)
%
% PURPOSE:
%  To computer Fisher's r to z transformation, which normalizes the distribution of rho (correlation, r)
%
%Copied directly from
%   http://www.mathworks.com/matlabcentral/fileexchange/25367-homogeneity-test-for-multiple-correlation-coefficients/content/fisherz.m
%
% JB Trimper
% 8/15
% Manns Lab


z=.5.*log((1+r)./(1-r));