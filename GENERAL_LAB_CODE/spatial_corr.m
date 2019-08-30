function rho = spatial_corr(rateMap1, rateMap2)
% function rho = spatial_corr(rateMap1, rateMap2)
%
% PURPOSE:
%  To calculate the spatial correlation for two rate-maps, ignoring
%  NaNs (spaces where the rat didn't visit) in either rate-map.
%  - To calculate spatial correlation for a population of cells and
%    evaluate statistical significance, use 'spatial_corr_stack'
%
% INPUT:
%  rateMap1 = rate-map for 1st cell
%  rateMap2 = rate-map for 2nd cell
%             - rate-maps must be the same size
%
% OUTPUT:
%    rho = spatial correlation coefficient
%
% JB Trimper
% 08/2019
% Colgin Lab


% Find NaNs in either rate-map
nanInds = isnan(rateMap1) | isnan(rateMap2);

% Remove those NaNs
rateMap1(nanInds) = [];
rateMap2(nanInds) = [];

% Vectorize the rate-maps (i.e., go from two dimensions to one)
rm1Vctr = rateMap1(:);
rm2Vctr = rateMap2(:);

% Calculate the spatial correlation coefficient
rho = corr(rm1Vctr, rm2Vctr);


end %fnctn