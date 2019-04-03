function [yesOrNo] = is_place_cell(rateMap)
% function [yesOrNo] = is_place_cell(rateMap);
%
% PURPOSE:
%   Uses method described in Bieri et al., 2014 to evaluate whether or not a cell is a place cell
%   based on the inputted smoothed rate map. Function assumes you're only inputting a rate map
%   for the portion of the track you want to consider (i.e., you've already cut off the ends of the track).
%   This is for LINEAR TRACK data, not for open field data.
%
% OUTPUT:
%   yesOrNo = logical indicating
%
% INPUT:
%   rateMap = smoothed vector rate map [1 x #Bins]
%
% NOTES:
%   - The smoothing method applied will have a big impact. Bieri et al. used 5 cm bins with a
%   25cm (5 bin) SD Gaussian centered on each bin.
%   - Option at top of function to exclude place cells not completed by the end of the track
%
% JB Trimper
% 9/2016
% Colgin Lab

%% OPTION
excIncomp = 0; %set to 1 to exclude place cells that were not completed by the end of the bins


avgFrCrit = 2.5; %Avg FR must be at least 2.5 Hz across rate map according to Bieri
%                 ... but is this typo? Should it have been 0.25?
contBinCrit = 3; %At least 3 contiguous bins with a FR above the lower of either a firing rate of...
minContBinFr = 1; %Hz or a...
minPercOfPeak = 10; % percent of the peak firing rate of the cell


rm = rateMap; %shorten the variable name
yesOrNo = 1; %assume at first that it is a place cell then try to disprove that

pkFr = max(rm); %peak FR in the rate map
avgFr = mean(rm); %average FR across the rate map

if yesOrNo == 1
    if avgFr < avgFrCrit %if average isn't high enough, answer no
        yesOrNo = 0;
        reason = ['Average firing rate (' num2str(round(avgFr,2)) ' Hz) is too low'];
    end
end

if yesOrNo == 1 %if still assuming it's place cell..
    
    contBinCheck = 0; %assume we don't have 3 contiguous points
    
    
    %look for 3 contigous points where FR > minContBinFr
    rmBin = rm>=minContBinFr;
    contigPtClusts = bwconncomp(rmBin,4);
    for c = 1:length(contigPtClusts.PixelIdxList)
        tmpClust = contigPtClusts.PixelIdxList{c};
        if length(tmpClust>contBinCrit) >= contBinCrit
            contBinCheck = 1;
            break
        end
    end
    
    %if we haven't found 3 contigous points yet, look for 3 points where FR > minPercOfPeak % of peak
    if contBinCheck ~= 1
        minContBinFr = pkFr * (minPercOfPeak/100);
        rmBin = rm>=minContBinFr;
        contigPtClusts = bwconncomp(rmBin,4);
        for c = 1:length(contigPtClusts.PixelIdxList)
            tmpClust = contigPtClusts.PixelIdxList{c};
            if length(tmpClust>contBinCrit) >= contBinCrit
                contBinCheck = 1;
                break
            end
        end
    end
    
    if contBinCheck == 1
        yesOrNo = 1;
    else
        yesOrNo = 0;
        reason = ['Did not detect three contiguous points with firing rate above ' num2str(minContBinFr) ' Hz'];
    end
    
end

if yesOrNo == 1 %if we passed the checks, define the place field
    cntr = 1;
    fldStartEnd = [];
    for c = 1:length(contigPtClusts.PixelIdxList)
        tmpClust = contigPtClusts.PixelIdxList{c};
        if length(tmpClust>contBinCrit) >= contBinCrit
            startClustInd = tmpClust(1);
            endClustInd = tmpClust(end);
            startFldInd = find(rm(1:startClustInd)==0, 1, 'Last');
            if ~isempty(startFldInd)
                fldStartEnd(cntr,1) = startFldInd;%#ok
            else
                fldStartEnd(cntr,1) = 1;%#ok
            end
            endFldInd = find(rm(endClustInd:end)==0, 1, 'First');
            if ~isempty(endFldInd)
                fldStartEnd(cntr,2) = endFldInd; %#ok
            else
                fldStartEnd(cntr,2) = length(rm);%#ok
            end
            cntr = cntr + 1;
        end
    end
    
    if ~isempty(fldStartEnd)
        fldStartEnd = unique(fldStartEnd, 'rows');
        if excIncomp == 1
            startAt1 = find(fldStartEnd(:,1) == 1);
            for si = 1:length(startAt1)
                fldStartEnd(si,:) = [];
            end
            endAtEnd = find(fldStartEnd(:,2) == length(rm));
            for ei = 1:length(endAtEnd)
                fldStartEnd(ei,:) = [];
            end
        end
    end
    
    if ~isempty(fldStartEnd)
        yesOrNo = 1;
    else
        yesOrNo = 0;
        reason = 'Place field did not end within track boundaries';
    end
end

if yesOrNo == 1
    fprintf('Yes\n');
else
    fprintf('No: %s\n', reason);
end

