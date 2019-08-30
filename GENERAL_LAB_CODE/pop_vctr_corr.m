function corrMat = pop_vctr_corr(rateMapStack1, rateMapStack2)
% function corrMat = pop_vctr_corr(rateMapStack1, rateMapStack2)
%
% PURPOSE: 
%  Function calculates the population vector correlation for two sets of rate-maps. 
%
% INPUT: 
%   rateMapStack1 = matrix of rate maps from environment/context 1
%                   size = xBins x yBins x units
%   rateMapStack2 = same as above but for environment/context 2
%
% OUTPUT: 
%     corrMat = a matrix of population vector correlation values for each x & y bin in 
%               the inputted rate-map stacks. 
%
% JB Trimper
% 08/2019
% Colgin Lab


%Check sizes of input matrices
if ~isequal(size(rateMapStack1), size(rateMapStack2))
    error('Input matrices must be the same size (same units for both stacks)');
end


corrMat = nan(size(rateMapStack1,1), size(rateMapStack1,2));
for x = 1:size(rateMapStack1,1)
    for y = 1:size(rateMapStack1,2)
        popVctr1 = squeeze(rateMapStack1(x,y,:));
        popVctr2 = squeeze(rateMapStack2(x,y,:));
        if sum(isnan(popVctr1))==0 & sum(isnan(popVctr2))==0
            corrMat(x,y) = corr(popVctr1, popVctr2);
        end
    end %y bins
end %x bins



end %fnctn