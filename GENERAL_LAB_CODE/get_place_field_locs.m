function [pfDets, prefLoc, prefLocInterpFr] = get_place_field_locs(rateMap, spBinSize)
% function [pfDets, prefLoc, prefLocInterpFr] = get_place_field_locs(rateMap, spBinSize)
%
% PURPOSE: 
%   Find locations of any preferred firing fields where firing rate > 1.5 SDs
%     and not returning to mean for at least 8cm width
%
%   Intentionally inclusive!
%    -- Point is not to define 'place fields', per se, but areas of preferred firing
%
% INPUT: 
%     rateMap = vector of 1 x numSpatialBins containing the rate map for the neuron
%   spBinSize = spatial bin size, in cm
%   
% OUTPUT:
%     pfDets = matrix, #PFs x 4, columns = [startEdgeBin peakBin endEdgeBin pkFr]; 
%              these are indices!
%    prefLoc = preferred spatial bin, weighted average of place field peak locations
%
% JBT 9/2016
% Colgin Lab



zRm = zscore(rateMap);
minWid = round(8/spBinSize);

pfDets = [];

pfChunks = bwconncomp(zRm>=1.5);
cntr = 1;
for c = 1:length(pfChunks.PixelIdxList);
    tmpInds = pfChunks.PixelIdxList{c};
    [~,maxInd] = max(zRm(tmpInds));
    maxInd = maxInd + pfChunks.PixelIdxList{c}(1) - 1; %resest max ind to full zRm vector
    startInd = find(zRm(1:maxInd)<.5, 1, 'Last');
    if isempty(startInd)
        startInd = 1;
    end
    endInd = find(zRm(maxInd:end)<.5, 1, 'First');
    endInd = endInd + maxInd - 1;
    if isempty(endInd)
        endInd = length(zRm);
    end
    if length(startInd:endInd) >= minWid
        pfDets(cntr,:) = [startInd maxInd endInd rateMap(maxInd)]; %#ok
        cntr = cntr + 1;
    end
    
end

prefLoc = [];
prefLocInterpFr = []; 
if length(pfDets) ~= 0 %#ok 
    mid = 1/size(pfDets,1);
    weightRatio = pfDets(:,4) ./ sum(pfDets(:,4));
    weightFctrs = 1 + (weightRatio - mid);
    prefLoc = mean(weightFctrs .* pfDets(:,2));
    prefLocInterpFr = mean(weightFctrs .* pfDets(:,4));
end



