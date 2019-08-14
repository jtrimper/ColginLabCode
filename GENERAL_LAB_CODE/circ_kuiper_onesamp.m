function [pVal, k, K] = circ_kuiper_onesamp(angles)
% function [pVal, k, K] = circ_kuiper_onesamp(angles)
%
% PURPOSE:
%  Function asks if set of angles conform to a circular Gaussian distribution
%  (i.e., von Mises distribution) by estimating the parameters of a von Mises
%  distribution using the angles provided, creating a sample of angles from
%  those parameters, then comparing the von Mises set of angles to the original
%  set of angles using a Kuiper Test. A p value > 0.05 indicates test angles
%  do not differ significantly from a von Mises (i.e., normality assumption is met).
%
%  n must be >= 5
%
%
%
% INPUT:
%  angles = a vector of angles
%
% OUTPUT:
%  pVal = p value for Kuiper test
%     k = test statistic for Kuiper test
%     K = critical value for Kuiper test
%
%   NOTE: 
%    pVal will equal 1 and K will be empty if test statistic (k) is > max critical value
%       - if n = 5, max K = 1.97
%       - if n >= 501 (max), max K = 2.30
%
% JB Trimper
% 8/2019
% Colgin Lab



%Estimate parameters of a von mises distribution from set of angle differences
[mu, kappa] = circ_vmpar(angles); %mu = preferredDirection; kappa = concentration param

% Create random von Mises distribution from parameters
vonMis = circ_randvm(mu, kappa, length(angles));

% Run Kuiper Test comparing distribution of angles to von Mises distribution
[pVal, k, K] = circ_kuipertest(angles, vonMis); %pValue, test statistic, critical value


end %fnctn


