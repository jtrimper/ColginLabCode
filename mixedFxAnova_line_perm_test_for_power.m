function [sigData, origData] = mixedFxAnova_line_perm_test_for_power(metric,fpass_opts,allF, desNumRandos, valFlag)
% function sigPts = mixedFxAnova_line_perm_test_for_power(metric,fpass_opts,allF, desNumRandos, valFlag)
%
% Function tests for an interaction and main effects for subregions (between) and conditions (within) using a mixed-effects ANOVA
%
% valFlag = 'abs' or 'dif' --> indicates whether to use abs values for the spectral measure input or zScored/detrended (whichever is in the 'values' structure)
%
% Function analyzes power ONLY
%   see function 'mixedFxAnova_line_perm_test_for_ud_intxn_mets' for interaction metrics (e.g., coherence, cross spec)
%
% A cluster based stats approach, using a mixed-effects ANOVA for each point on the line
%
% See employment in 'analyze_iviic_lfps_3.m' for usage.
%
% JBT 1/16

fprintf ('\n\nTesting data for statistical significance...\n');

%% SET OPTIONAL PARAMETERS

minClustLen = [2 4];
fCuts = fpass_opts; %these should be the freq ranges that line up with each taper, and each minClustLen
plotData = 0; %set plotData to 1 to do optional plotting (for visually checking statistically significant line segments)
statThreshAlpha = .025; %statistical threshold (because therea are two fRanges, split .05 in two)
initClustAlpha = 0.1; %alpha level for initial cluster detection



%% GET A FEW RE-OCCURING VARIABLES DEFINED/PRE-ALLOCATED

if strcmpi(valFlag, 'abs');
    valType = 'absValues';
elseif strcmpi(valFlag, 'dif');
    valType = 'values';
else
    error('Unknown valFlag input');
end

numRats = size(metric(1).(valType),2); %# of rats
numConds = size(metric(1).(valType),4); %# of conditions
numRegs = 4; %# of subregions

alphaFlip = 1 - initClustAlpha; %flip the alpha - dont' touch this line


%% GET P VALUES FOR THE ORIGINAL DATA
fprintf ('   Getting p values for actual data...\n');

%These vectors index where the power values for each subregion are found
%-entirely based on output from analysis function that creates input for this function
mInds = [4 5 4 5]; %metric
pInds = [1 1 6 6]; %reg combo
for reg = 1:4
    tmpM = mInds(reg);
    tmpP = pInds(reg);
    origData(:,:,reg,:) = squeeze(metric(tmpM).(valType)(:,:,tmpP,:));%#ok -- %get stored power vals -- OP = vals x rat x subreg x condn
end


origPVals = zeros(size(origData,1),3); %pre-allocate array for p values from the original data  - fBins x effects (2 mains + 1 intxn)
for v = 1:size(origData,1);
    ipData = permute(origData(v,:,:,:), [2 4 3 1]); %flip tmpVals around to be rat x condn x subreg x vals, and get only the data for one of the values
    [me, int] = mixed_anova(ipData);
    origPVals(v,1) = me.A.p; %main effect of between groups factor (subreg)
    origPVals(v,2) = me.B.p; %main effect of within groups factor (condition)
    origPVals(v,3) = int.p; %interaction of between and within
end

origPVals = 1 - origPVals; %flip p values





%% GET INDICES FOR EACH SHUFFLE

fprintf ('   Getting indices for each shuffle...\n');

numRandosSubreg = factorial(numRegs)^numRats; %this many different ways to randomly assign the subregion combos are possible
numRandosCondn = factorial(numConds)^numRats; %this many different ways to randomly assign the conditions are possible

numRandosInt = numRandosSubreg * numRandosCondn; %this many different ways to randomly assign the conditions are possible
if numRandosInt > desNumRandos
    numRandosInt = desNumRandos; %if we can do more than desNumRandos, just do desNumRandos. Otherwise, do max possible
end
fprintf ('      # of randomizations = %d\n', numRandosInt);

subregShufInds = zeros(numRats,numRegs);%pre-allocate for first shuffle's indices
condnShufInds = zeros(numRats,numConds); 
for r = 1:numRats
    subregShufInds(r,:) = randperm(numRegs); %get the indices for the first shuffle
    condnShufInds(r,:) = randperm(numConds);
end
intShufInds = cat(2, subregShufInds, condnShufInds); %to make sure we have unique indices, we've gotta concatenate the two shuffle matrices temporarily, then separate them later


%go get all them shuffle inds
tmpSubregInds = zeros(numRats, numRegs); %pre-allocate 
tmpCondnInds = zeros(numRats, numConds); 
while size(intShufInds,3) < numRandosInt
    for r = 1:numRats
        tmpSubregInds(r,:) = randperm(numRegs); %generate a new matrix of inds
        tmpCondnInds(r,:) = randperm(numConds);
    end
    tmpIntInds = cat(2, tmpSubregInds, tmpCondnInds); 
    
    check = 0;
    for i = 1:size(intShufInds,3);
        check = isequal(tmpIntInds,intShufInds(:,:,i)); %check to see if this shuffle's inds equal any of the already existing ones
        if check %if it equals any of the already made ones
            break %get out of this loop and don't add it in
        end
    end
    if ~check %if it's a new one
        intShufInds = cat(3,intShufInds,tmpIntInds); %add it in
    end
end

%separate the shuffled indices for conditions and region combinations
subregInds = intShufInds(:,1:numRegs,:);
condnInds = intShufInds(:,numRegs+1:end,:);




%% GET STATISTICAL THRESHOLDS
fprintf ('   Establishing statistical threshold...\n');

clustMaxs = zeros(2,3,numRandosInt); %pre-allocate for within group cluster maxes -- fRange x effect x shuffles

clear tmpVals

fprintf ('\t\tShuffle #: ');
for s = 1:numRandosInt;
    
    %print shuffle iteration number in a manageable way
    if s == 1, fprintf ('1');
    elseif (s > 1) && (mod(s,100) == 1); fprintf ('\n\t\t\t\t  '); end
    if (s > 1) && (mod(s,100)~=1) && (mod(s,10) == 0), fprintf (',  %d', s); elseif s>1 && (mod(s,100) == 1), fprintf ('%d',s); end
    if s == numRandosInt; fprintf ('\n'); end
    
    %actually run through this shuffle
    tmpRegInds = subregInds(:,:,s);
    tmpCondnInds = condnInds(:,:,s);
        for r = 1:numRats
            tmpVals(:,r,:,:) = origData(:,r,tmpRegInds(r,:),tmpCondnInds(r,:)); %IP/OP: values x rat x combo x condn
        end
        shufPVals = zeros(size(tmpVals,1),1); %pre-allocate array for p values for this shuffle
        for v = 1:size(tmpVals,1); %for each of the values (freq points)
            ipData = permute(tmpVals(v,:,:,:), [2 4 3 1]);%flip the data so it's rats x condns x reg combos, for just this value/fBin
            [me, int] = fact_rm_anova(ipData); %do a mixed-effects anova
            shufPVals(1,v) = me.A.p; %p value for the main effect of subregion
            shufPVals(2,v) = me.B.p; %p value for the main effect of condition
            shufPVals(3,v) = int.p; %p value for the interaction
        end
        shufPVals = 1 - shufPVals; %flip shuffled p values (so higher is better)
        
        for ef = 1:3 %for each of the three effects
            ptsAbThresh = zeros(size(shufPVals,2),1); %pre-allocate binary array for points above initial cluster detection threshold
            ptsAbThresh(shufPVals(ef,:) >= alphaFlip) = 1; %find those points
            for f = 1:2
                tmpFRange = fCuts(f,:); %get the temp freq range
                tmpPtsAbThresh = ptsAbThresh(allF>=tmpFRange(1) & allF<=tmpFRange(2)); %and the binary for which points within the fRange are above init clust detection
                tmpPVals = shufPVals(ef,allF>=tmpFRange(1) & allF<=tmpFRange(2)); %get the p values for this fRange
                clusts = bwconncomp(tmpPtsAbThresh, 4);%find clusters of points above threshold -- FYI: 2nd input doesn't matter; have to check length below
                for j = 1:length(clusts.PixelIdxList)%for each cluster
                    tmpInds = clusts.PixelIdxList{j};%get the indices
                    if length(tmpInds) >= minClustLen(f)%if the cluster is long enough
                        clustSum = sum(tmpPVals(tmpInds)); %add up all the p values within it
                        if clustSum > clustMaxs(f,ef,s); %and if it's greater than zero or the other clusters within this fRange/metric/shuffle
                            clustMaxs(f,ef,s) = clustSum; %then save it
                        end
                    end
                end
            end
        end
end

clustMaxs = sort(clustMaxs,3); 
statThreshInd = round((1-statThreshAlpha)*numRandosInt); %establish index for statistical cutoff
statThresh = clustMaxs(:,:,statThreshInd); %find the statistical threshold for the interaction -- freqRange x metric x effect






%% RETURN TO THE ORIGINAL P VALUES AND FIND CLUSTERS ABOVE THRESHOLD
fprintf ('   Identifying points in actual data above threshold...\n');


for f = 1:2
    tmpFRange = fCuts(f,:);
    tmpPVals = origPVals(allF>=tmpFRange(1) & allF<=tmpFRange(2),:); %get the p values within this fRange  -- vals x effect
    fRange(f).sigPts = zeros(size(tmpPVals)); %#ok - for catching binaries within f ranges, then concatenating across
    for ef = 1:3 %for each of the statistical effects: (1)Between, (2)Within, (3)Interaction
        ptsAbThresh = zeros(size(tmpPVals,1),1); %make a binary for pValues above threshold for this fRange/effect
        ptsAbThresh(tmpPVals(:,ef) >= alphaFlip) = 1; %identify pValues for this effect/metric above initial cluster detectionthreshold
        clusts = bwconncomp(ptsAbThresh, 4);%find clusters of points above threshold -- 2nd input doesn't matter; have to check length below
        for j = 1:length(clusts.PixelIdxList)
            tmpInds = clusts.PixelIdxList{j};
            if length(tmpInds) >= minClustLen(f)%if the cluster is long enough
                clustSum = sum(tmpPVals(tmpInds,ef)); %add up all the p values within it
                if clustSum > statThresh(f,ef); %and if it's greater than the statistical threshold
                    fRange(f).sigPts(tmpInds,ef) = 1;
                end
            end
        end
    end
end
sigPts = cat(1,fRange(1).sigPts, fRange(2).sigPts);

sigData.sigPts = sigPts; 
sigData.pVals = origPVals; 

%% OPTIONAL - CHECK DATA BY PLOTTING

if plotData == 1
    efNames = {'Main Effect: Subregion', 'Main Effect: Conditions', 'Interaction'};
    regNames = {'DG', 'CA3', 'CA1', 'SUB'}; 
    efCols = [1 0 0; 0 1 0; 0 0 1];
    condnCols = {'Red', 'Green', 'Blue', 'Purple'}; 
    
    %get the values that went into each main effect for visual inspection
    %--for main effect A (between subregions)
    avgXCondns = mean(origData,4); %average across conditions
    axcAvgXRegs = mean(avgXCondns,3); %average that ^ across regions
    for reg = 1:4
        difVals(:,:,reg) = avgXCondns(:,:,reg) - axcAvgXRegs; %for each region, how much does its own avg x condns differ from the average across regions?
    end
    axcAVG = squeeze(mean(difVals,2));%average across rats
    axcERR = squeeze(semfunct(difVals,2));%error across rats
    
    avgXRegs = squeeze(mean(origData,3)); %average across regions
    axrAvgXConds = mean(avgXRegs,3); %average that ^ across conditions
    for c = 1:numConds
        difVals(:,:,c) = avgXRegs(:,:,c) - axrAvgXConds; %for each region, how much does its own avg x condns differ from the average across regions?
    end
    axrAVG = squeeze(mean(difVals,2));
    axrERR = squeeze(semfunct(difVals,2));
    
    %plot significance
    figure;
    for ef = 1:3
        subplot(2,3,ef);
        hold on;
        plot(allF, origPVals(:,ef), 'Color', efCols(ef,:));
        if sum(sigPts(:,ef)) > 0
            efLineY = repmat(.5, size(allF));
            plot(allF(sigPts(:,ef)==1), origPVals(sigPts(:,ef)==1,ef), '*', 'Color', [0 0 0]);
        end
        ylabel('p Values for the original data'); 
        title (efNames{ef});
        ylim([.5 1]);
    end
    
    subplot(2,3,4)
    for reg = 1:4
        tmpH(reg) = error_fill_plot(allF, axcAVG(:,reg), axcERR(:,reg), condnCols{reg});
    end
    legend(tmpH, 'DG', 'CA3', 'CA1', 'SUB')
    yRange = get(gca, 'YLim');
    yMax = max(abs(yRange));
    ylim([-yMax yMax]);
    ln = line([allF(1) allF(end)], [0 0]);
    set(ln, 'Color', [0 0 0], 'LineStyle', '--');
    title ('Values for Each Subregion, Averaged Across Conditions'); 
    ylabel ('Power (Dif From Average)'); 
    
    subplot(2,3,5)
    for c = 1:4
        tmpH(c) = error_fill_plot(allF, axrAVG(:,c), axrERR(:,c), condnCols{c});
    end
    legend(tmpH, 'Stat', 'Move', 'Exp', 'App')
    yRange = get(gca, 'YLim');
    yMax = max(abs(yRange));
    ylim([-yMax yMax]);
    ln = line([allF(1) allF(end)], [0 0]);
    set(ln, 'Color', [0 0 0], 'LineStyle', '--');
    ylabel ('Power (Dif From Average)'); 
    title ('Values for Each Condition, Averaged Across Subregions'); 
    
    
    
    %plot data
    figure; 
    avgXCondns = squeeze(mean(origData,4)); 
    for c = 1:numConds
        difVals(:,:,:,c) = origData(:,:,:,c) - avgXCondns; 
    end
    difAvg = squeeze(mean(difVals,2)); 
    difErr = squeeze(semfunct(difVals,2)); 
    for reg = 1:4
        subplot(1,4,reg); 
        hold on; 
        for c = 1:numConds
           error_fill_plot(allF, difAvg(:,reg,c), difErr(:,reg,c), condnCols{c}); 
        end
        ln = line([allF(1) allF(end)], [0 0]); 
        set(ln, 'Color', [0 0 0], 'LineStyle', '--'); 
        yRange = get(gca, 'YLim'); 
        yMax = max(abs(yRange)); 
        ylim([-yMax yMax]); 
        title(regNames{reg}); 
        ylabel ('Power (Dif From Mean Across Condns)'); 
    end
    
end





end%function