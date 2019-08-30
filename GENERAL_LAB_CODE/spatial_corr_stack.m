function [spatCorr, spatCorrByUnit, pVal, critVals, randRmCorrs] = spatial_corr_stack(rateMapStack1, rateMapStack2, sigTest, numRandos)
% function rho = spatial_corr_stack(rateMap1, rateMap2)
%
% PURPOSE:
%  To calculate the spatial correlation for ratemaps from the same cells across
%  two separate contexts and statistically evaluate the correlations for significance.
%   - To just calculate the spatial correlation for a single pair of rate-maps (same
%     cell or otherwise), use function 'spatial_corr'
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
%         spatCorr = average spatial correlation value for the population of units
%   spatCorrByUnit = spatial correlation value for each unit
%             pVal = p-value for stats testing. Will be empty if sigTest == 0
%                   - pVal is proportion of randomizations below spatCorr unless
%                     spatCorr is significantly below chance, in which case
%                     pVal is proportion of randomizations above spatCorr
%        critVals = high and low critical values for statistical evaluation (1 x 2)
%                   - will be empty if sigTest == 0
%     randRmCorrs = all spatial correlations from the randomizations (1 x numRandos)
%
%
% JB Trimper
% 08/2019
% Colgin Lab


alpha = 0.05; %alpha level for stats testing (two-tailed)

%Check sizes of input matrices
if ~isequal(size(rateMapStack1), size(rateMapStack2))
    error('Input matrices must be the same size (same units for both stacks)');
end

numU = size(rateMapStack1,3); % #Units

% Get average spatial correlation
spatCorrByUnit = zeros(1,numU); % initialize vector
for u = 1:numU %each unit
    rm1 = rateMapStack1(:,:,u); %ratemap for unit in 1st environment/context
    rm2 = rateMapStack1(:,:,u);  %ratemap for unit in 2nd environment/context
    spatCorrByUnit(u) = spatial_corr(rm1, rm2);
end
spatCorr = mean(spatCorrByUnit); %Average across units


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
    randRmCorrs = zeros(1,numRandos);
    for r = 1:numRandos
        
        randInds1 = randperm(numU);
        randStack1 = rateMapStack1(:,:,randInds1);
        
        randInds2 = randperm(numU);
        randStack2 = rateMapStack2(:,:,randInds2);
        
        tmpRandCorr = zeros(1,numU);
        for u = 1:numU
            rm1 = randStack1(:,:,u);
            rm2 = randStack2(:,:,u);
            tmpRandCorr(u) = spatial_corr(rm1, rm2);
        end
        randRmCorrs(r) = mean(tmpRandCorr);
        
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
    randRmCorrs = sort(randRmCorrs);
    critVals(1) = randRmCorrs(lowInd);
    critVals(2) = randRmCorrs(highInd);
    
    % Compare rate-map correlation to distribution and calculate pVal
    if spatCorr < critVals(1)
        pVal = sum(randRmCorrs<spatCorr)/numRandos;
    else
        pVal = sum(randRmCorrs>spatCorr)/numRandos;
    end
    
    
else %no stats testing so return empty variables
    
    pVal = [];
    randRmCorrs = [];
    critVals = [];
    
end %sigTest











end %fnctn