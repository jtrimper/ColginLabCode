function [rmOvlp, rmOvlpByUnit, pVal, critVals, randRmOvlps]  = rate_overlap(rateMapStack1, rateMapStack2, sigTest, numRandos)
% function [rmOvlp, rmOvlpByUnit, pVal, critVals, randRmOvlps]  = rate_overlap(rateMapStack1, rateMapStack2, sigTest, numRandos)
%
% PURPOSE:
%  Function to calculate the rate-map overlap between two environments/contexts for all
%  active cells a la Colgin et al. (2010, JNeurophys). Optional inclusion of significance
%  testing using nonparametric permutation approach.
%
% INPUT:
%   rateMapStack1 = matrix of rate maps from environment/context 1
%                   size = xBins x yBins x units
%   rateMapStack2 = same as above but for environment/context 2
%         sigTest = optional binary indicating whether(1) or not(0) to run stat test
%                   - Default is 0, do not run statistical test
%                   - Two-tailed alpha of 0.05 is assumed (alpha can be adjusted within function)
%       numRandos = # of randomizations for statistical test (suggestion/default = 1000)
%                    - if sigTest == 0, numRandos is ignored (and doesn't need to be inputted)
%                    - if sigTest == 1 and numRandos is not inputted, default is 1000
%
% OUTPUT:
%        rmOvlp = rate-map overlap ratio averaged across active neurons
%  rmOvlpByUnit = rate-map overlap ratio for each unit (NaNs for inactive units)
%          pVal = p-value for stats testing. Will be empty if sigTest == 0
%                 - pVal is proportion of randomizations below spatCorr unless
%                   spatCorr is significantly below chance, in which case
%                   pVal is proportion of randomizations above spatCorr
 %     critVals = high and low critical values for statistical evaluation (1 x 2)
%                 - will be empty if sigTest == 0
%   randRmCorrs = all spatial correlations from the randomizations (1 x numRandos)
%
%
% JB Trimper
% 08/2019
% Colgin Lab


activeThreshold = 0.25; %Hz - minimum average FR in at least 1/2 environments for cell to be included
%                             Per Colgin et al. (2010, JNeurophys)

alpha = 0.05; %alpha level for stats testing (two-tailed)

%Check sizes of input matrices
if ~isequal(size(rateMapStack1), size(rateMapStack2))
    error('Input matrices must be the same size (same units for both stacks)');
end

numU = size(rateMapStack1,3); % #Units


%Calculate rate map overlap for each active unit
rmOvlpByUnit = nan(1,numU);
for u = 1:numU
    
    % Find the mean FR, ignoring Nans, from the vectorized rate-map for this unit
    avgFr1 = nanmean(reshape(rateMapStack1(:,:,u), [1 numel(rateMapStack1(:,:,u))]));
    avgFr2 = nanmean(reshape(rateMapStack2(:,:,u), [1 numel(rateMapStack2(:,:,u))]));
    
    % If unit was active in at least one environment, calculate overlap ratio
    if avgFr1>activeThreshold | avgFr2>activeThreshold
        rmOvlpByUnit(u) = min([avgFr1 avgFr2]) / max([avgFr1 avgFr2]);
    end
    
end
rmOvlp = nanmean(rmOvlpByUnit);




% Run stats or not
if ~exist('sigTest', 'var')
    sigTest = 0;
else
    if ~exist('numRandos', 'var')
        numRandos = 1000;
    end
end




% If running stats
if sigTest == 1
    
    % Get test distribution
    randRmOvlps = zeros(1,numRandos);
    for r = 1:numRandos
        randInds1 = randperm(numU);
        randStack1 = rateMapStack1(:,:,randInds1);
        
        randInds2 = randperm(numU);
        randStack2 = rateMapStack2(:,:,randInds2);
        
        
        tmpRandRmOvlp = zeros(1,numU);
        for u = 1:numU
            
            % Find the mean FR, ignoring Nans, from the vectorized rate-map for this unit
            avgFr1 = nanmean(reshape(randStack1(:,:,u), [1 numel(randStack1(:,:,u))]));
            avgFr2 = nanmean(reshape(randStack2(:,:,u), [1 numel(randStack2(:,:,u))]));
            
            % If unit was active in at least one environment, calculate overlap ratio
            if avgFr1>activeThreshold | avgFr2>activeThreshold
                tmpRandRmOvlp(u) = min([avgFr1 avgFr2]) / max([avgFr1 avgFr2]);
            end
        end
        randRmOvlps(r) = nanmean(tmpRandRmOvlp);
    end
    
    % Indices for critical values
    lowInd = floor(numRandos*(alpha/2)); %Ind for bottom alpha/2 percentile
    %                            Rounding down because if numRandos*(alpha/2) is not
    %                            an integer, then indexing will not work. Rounding down
    %                            is more stringent than rounding up.
    if lowInd == 0
        lowInd = 1; %Index needs to be non-zero
    end
    highInd = ceil(numRandos - lowInd); %Ind for top alpha/2 percentile
    %                            Rounding up for same reason as stated above. Here,
    %                            rounding up is more stringent.
    
    
    % Get critical values
    randRmOvlps = sort(randRmOvlps);
    critVals(1) = randRmOvlps(lowInd);
    critVals(2) = randRmOvlps(highInd);
    
    % Compare rate-map correlation to distribution and calculate pVal
    if rmOvlp < critVals(1)
        pVal = sum(randRmOvlps<rmOvlp)/numRandos;
    else
        pVal = sum(randRmOvlps>rmOvlp)/numRandos;
    end
    
    
else %no stats testing so return empty variables
    
    pVal = [];
    randRmOvlps = [];
    critVals = [];
    
end




end %fnctn