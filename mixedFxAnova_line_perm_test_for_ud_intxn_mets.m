function [sigData, origData] = mixedFxAnova_line_perm_test_for_ud_intxn_mets(metric,fpass_opts,allF, desNumRandos, combosOfInt, valFlag)
% function [sigData, origData] = mixedFxAnova_line_perm_test_for_ud_intxn_mets(metric,fpass_opts,allF, desNumRandos, combosOfInt, valFlag)
%
% Function tests for an interaction and main effects for subregions (between) and conditions (within) using a mixed-effects ANOVA
%
% valFlag = 'abs' or 'dif' --> indicates whether to use abs values for the spectral measure input or zScored/detrended (whichever is in the 'values' structure)
%
% Function analyzes the undirected interaction metrics only (i.e., coherence, phase coherence, cross spectrum)
%   i.e., NOT single region metrics, like power (see omnibus_mixedFx_line_perm_test_for_power)
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

numRats = size(metric(1).(valType),2);
numConds = size(metric(1).(valType),4);
numCombos = length(combosOfInt); 

alphaFlip = 1 - initClustAlpha; %flip the alpha - dont' touch this line




%% GET THE F RATIO FOR THE ORIGINAL DATA
fprintf ('   Getting p values for actual data...\n');

origPVals = zeros(size(metric(1).(valType),1), 3, 3); %pre-allocate array for p values from the original data
for m = 1:3
    tmpVals = squeeze(metric(m).(valType)(:,:,combosOfInt,:));%get the values for this metric/regCombo --> IP = vals x rat x combo x condn; OP = vals x rat x combos x condn
    origData(:,:,:,:,m) = tmpVals; %for plotting
    for v = 1:size(tmpVals,1);
        ipData = permute(tmpVals(v,:,:,:), [2 4 3 1]); %permute the data so it's in the right format for 'mixed_anova' (i.e., rats x condns x combos)
        [me, int] = mixed_anova(ipData);
        origPVals(v,m,1) = me.A.p; %main effect of between groups factor (subreg combo)
        origPVals(v,m,2) = me.B.p; %main effect of within groups factor (condn)
        origPVals(v,m,3) = int.p; %interaction of between and within
    end
end
origPVals = 1 - origPVals; %flip p values



%% GET INDICES FOR EACH SHUFFLE

fprintf ('   Getting indices for each shuffle...\n');

numRandosSubreg = factorial(numCombos)^numRats; %this many different ways to randomly assign the subregion combos are possible
numRandosCondn = factorial(numConds)^numRats; %this many different ways to randomly assign the conditions are possible

numRandosInt = numRandosSubreg * numRandosCondn; %this many different ways to randomly assign the conditions are possible
if numRandosInt > desNumRandos
    numRandosInt = desNumRandos; %if we can do more than desNumRandos, just do desNumRandos. Otherwise, do max possible
end
fprintf ('      # of randomizations = %d\n', numRandosInt);

subregShufInds = zeros(numRats,numCombos);%pre-allocate for first shuffle's indices
condnShufInds = zeros(numRats,numConds); 
for r = 1:numRats
    subregShufInds(r,:) = combosOfInt(randperm(numCombos)); %get the indices for the first shuffle
    condnShufInds(r,:) = randperm(numConds);
end
intShufInds = cat(2,subregShufInds,condnShufInds); %to make sure we have unique indices, we've gotta concatenate the two shuffle matrices temporarily, then separate them later


%go get all them shuffle inds
tmpSubregInds = zeros(numRats, numCombos); %pre-allocate 
tmpCondnInds = zeros(numRats, numConds); 
while size(intShufInds,3) < numRandosInt
    for r = 1:numRats
        tmpSubregInds(r,:) = combosOfInt(randperm(numCombos)); %generate a new matrix of inds
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
comboInds = intShufInds(:,1:numCombos,:);
condnInds = intShufInds(:,numCombos+1:end,:);




%% GET STATISTICAL THRESHOLDS
fprintf ('   Establishing statistical threshold...\n');

clustMaxs = zeros(2,3,3,numRandosInt); %pre-allocate for within group cluster maxes -- fRange x metric x effect x shuffles

clear tmpVals

fprintf ('\t\tShuffle #: ');
for s = 1:numRandosInt;
    
    %print shuffle iteration number in a manageable way
    if s == 1, fprintf ('1');
    elseif (s > 1) && (mod(s,100) == 1); fprintf ('\n\t\t\t\t  '); end
    if (s > 1) && (mod(s,100)~=1) && (mod(s,10) == 0), fprintf (',  %d', s); elseif s>1 && (mod(s,100) == 1), fprintf ('%d',s); end
    if s == numRandosInt; fprintf ('\n'); end
    
    %actually run through this shuffle for each of the three spectral interaction metrics
    tmpComboInds = comboInds(:,:,s);
    tmpCondnInds = condnInds(:,:,s);
    for m = 1:3
        for r = 1:numRats
            tmpVals(:,r,:,:) = metric(m).(valType)(:,r,tmpComboInds(r,:),tmpCondnInds(r,:)); %IP/OP: values x rat x combo x condn
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
                        if clustSum > clustMaxs(f,m,ef,s); %and if it's greater than zero or the other clusters within this fRange/metric/shuffle
                            clustMaxs(f,m,ef,s) = clustSum; %then save it
                        end
                    end
                end
            end
        end
    end
end

clustMaxs = sort(clustMaxs,4);
statThreshInd = round((1-statThreshAlpha)*numRandosInt); %establish index for statistical cutoff
statThresh = clustMaxs(:,:,:,statThreshInd); %find the statistical threshold for the interaction -- freqRange x metric x effect





%% RETURN TO THE ORIGINAL P VALUES AND FIND CLUSTERS ABOVE THRESHOLD
fprintf ('   Identifying points in actual data above threshold...\n');


for f = 1:2
    tmpFRange = fCuts(f,:);
    tmpPVals = origPVals(allF>=tmpFRange(1) & allF<=tmpFRange(2),:,:); %get the p values within this fRange  -- vals x metric x effect
    fRange(f).sigPts = zeros(size(tmpPVals)); %#ok - for catching binaries within f ranges, then concatenating across
    for m = 1:3 %for each metric
        for ef = 1:3 %for each of the statistical effects (2 mains and an intxn)
            ptsAbThresh = zeros(size(tmpPVals,1),1); %make a binary for pValues above threshold for this metric/fRange
            ptsAbThresh(tmpPVals(:,m,ef) >= alphaFlip) = 1; %identify pValues for this effect/metric above initial cluster detectionthreshold
            
            clusts = bwconncomp(ptsAbThresh, 4);%find clusters of points above threshold -- 2nd input doesn't matter; have to check length below
            for j = 1:length(clusts.PixelIdxList)
                tmpInds = clusts.PixelIdxList{j};
                if length(tmpInds) >= minClustLen(f)%if the cluster is long enough
                    clustSum = sum(tmpPVals(tmpInds,m,ef)); %add up all the p values within it
                    if clustSum > statThresh(f,m,ef); %and if it's greater than the statistical threshold
                        fRange(f).sigPts(tmpInds,m,ef) = 1;
                    end
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
    
    %PLOT ALL STATISTICAL RESULTS ON ONE FIGURE
    efNames = {'Main Effect: Subreg Combo', 'Main Effect: Conditions', 'Interaction'}; 
    metNames = {'Coher', 'Phi Coher', 'Cross Spec'};
    efCols = [1 0 0; 0 1 0; 0 0 1];
    figure;
    for m = 1:3
        for ef = 1:3
            subplot(3,3,(ef-1)*3+m);
            hold on;
            ln = line([allF(1) allF(end)], [.5 .5]);
            set(ln, 'LineStyle', ':');
            plot(allF, origPVals(:,m,ef), 'Color', efCols(ef,:));
            if sum(sigPts(:,m,ef)) > 0
                efLineY = repmat(.5, size(allF));
                plot(allF(sigPts(:,m,ef)==1), efLineY(sigPts(:,m,ef)==1), '*', 'Color', efCols(ef,:));
            end
            title (metNames{m});
            
            ln = line([allF(1) allF(end)], [1.5 1.5]);
            set(ln, 'Color', [0 0 0], 'LineStyle', '--');
            
            ln = line([allF(1) allF(end)], [2.5 2.5]);
            set(ln, 'Color', [0 0 0], 'LineStyle', '--');
            
            ylabel (efNames{ef});
            ylim([0 1]);
        end
    end
    
    
    % MAKE A SEPARATE FIGURE FOR EACH SPECTRAL MEASURE
    efNames = {'Main Effect: Region Pairing', 'Main Effect: Conditions', 'Interaction'};
    comboNames = {'DG/CA3', 'CA3/CA1', 'CA1/SUB'};
    efCols = [1 0 0; 0 1 0; 0 0 1];
    condnCols = {'Red', 'Green', 'Blue', 'Purple'}; 
    
    for m = 1:3
        %get the values that went into each main effect for visual inspection
        %--for main effect A (between subregions)
        avgXCondns = mean(origData(:,:,:,:,m),4); %average across conditions
        axcAvgXRegs = mean(avgXCondns,3); %average that ^ across region combos
        for p = 1:3
            difVals(:,:,p) = avgXCondns(:,:,p) - axcAvgXRegs; %for each region combo, how much does its own avg x condns differ from the average across regions?
        end
        axcAVG = squeeze(mean(difVals,2));%average across rats
        axcERR = squeeze(semfunct(difVals,2));%error across rats
        
        avgXRegs = squeeze(mean(origData(:,:,:,:,m),3)); %average across region combos
        axrAvgXConds = mean(avgXRegs,3); %average that ^ across conditions
        for c = 1:numConds
            difVals(:,:,c) = avgXRegs(:,:,c) - axrAvgXConds; %for each region, how much does its own avg x condns differ from the average across regions?
        end
        axrAVG = squeeze(mean(difVals,2));
        axrERR = squeeze(semfunct(difVals,2));
        
        %plot significance
        figure('name', metNames{m}); 
        for ef = 1:3
            subplot(2,3,ef);
            hold on;
            plot(allF, origPVals(:,m,ef), 'Color', efCols(ef,:));
            if sum(sigPts(:,m,ef)) > 0
                efLineY = repmat(.5, size(allF));
                plot(allF(sigPts(:,m,ef)==1), origPVals(sigPts(:,m,ef)==1,m,ef), '*', 'Color', [0 0 0]);
            end
            ylabel('p Values for the original data');
            title (efNames{ef});
            ylim([.5 1]);
        end
        
        subplot(2,3,4)
        clear tmpH
        for p = 1:3
            tmpH(p) = error_fill_plot(allF, axcAVG(:,p), axcERR(:,p), condnCols{p});
        end
        legend(tmpH, 'DG/CA3', 'CA3/CA1', 'CA1/SUB')
        yRange = get(gca, 'YLim');
        yMax = max(abs(yRange));
        ylim([-yMax yMax]);
        ln = line([allF(1) allF(end)], [0 0]);
        set(ln, 'Color', [0 0 0], 'LineStyle', '--');
        title ('Values for Each Region Pair, Averaged Across Conditions');
        ylabel ([metNames{m} ' (Dif From Average)']);
        
        subplot(2,3,5)
        clear tmpH
        for c = 1:4
            tmpH(c) = error_fill_plot(allF, axrAVG(:,c), axrERR(:,c), condnCols{c});
        end
        legend(tmpH, 'Stat', 'Move', 'Exp', 'App')
        yRange = get(gca, 'YLim');
        yMax = max(abs(yRange));
        ylim([-yMax yMax]);
        ln = line([allF(1) allF(end)], [0 0]);
        set(ln, 'Color', [0 0 0], 'LineStyle', '--');
        ylabel ([metNames{m} ' (Dif From Average)']);
        title ('Values for Each Condition, Averaged Across Region Pairs');
    end
    
    
    
end





