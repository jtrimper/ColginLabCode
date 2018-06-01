function sigPts = rmAnova_line_perm_test(metric,fpass_opts,allF, desNumRandos, metNums)
% function sigPts = rmAnova_line_perm_test(metric,fpass_opts,allF, desNumRandos, metNums)
%
% Function to test for statistical significance of spectral estimates when there are more than two conditions.
%
% Employs one-way RM anova. For two-way RM Anova, use factRmAnova_line_perm_test
%
% Function asks if there is a difference across any of the conditions within a subregion/subregion combo, for all metrics
%
% A cluster based stats approach, using a RM ANOVA for each point on the line
%
% See employment in 'analyze_iviic_lfps_3.m' for usage.
%
% JBT 1/16

fprintf ('\n\nTesting data for statistical significance...\n'); 

%% SET OPTIONAL PARAMETERS

minClustLen = [2 4];
fCuts = fpass_opts; %these should be the freq ranges that line up with each taper, and each minClustLen
% desNumRandos = 100; %max desired number of randomizations
plotData = 1; %set plotData to 1 to do optional plotting (for visually checking statistically significant line segments)
numC = size(metric(1).absValues,4); %# of conditions
numR = size(metric(1).absValues,2); %# of rats
statThreshAlpha = .025; %statistical threshold (because therea are two fRanges, split .05 in two)
initClustAlpha = 0.1; %alpha level for initial cluster detection
numMets = length(metric); %because if we just have one, we're testing WPLI
if nargin == 4
    if numMets == 6 %if phase is one of the metric, we're not gonna test that
        numMets = 5;
    end
    metNums = 1:numMets;
end
    

%% GET THE F RATIO FOR THE ORIGINAL DATA
fprintf ('   Getting error ratios for actual data...\n');

mCntr = 0; 
for m = metNums
    mCntr = mCntr + 1; 
    for p = 1:6
        tmpVals = squeeze(metric(m).absValues(:,:,p,:));%get the values for this metric/regCombo --> IP = vals x rat x combo x condn; OP = vals x rat x condn
        wiCondnAvg = squeeze(mean(tmpVals,2));%average across rats, within condition --> OP = vals x condn
        wiSubjXCondnAvg = squeeze(mean(tmpVals,3));%average across conditions, for each rat --> OP = vals x rat
        grandAvg = mean(wiCondnAvg,2); %grand average, x Condns, x Subjs --> OP = vals
        
        %calculate sum of squares between (AKA: SStime)
        %--sum of squared differences between condn mean & grand mean, multipled by # of subjects
        for c = 1:numC
            SSb(:,c) = (wiCondnAvg(:,c) - grandAvg).^2; %#ok -- 
        end
        SSb = sum(SSb,2) .* numR; %sum of squared differences across conditions x # of rats
        
        
        %calculate sum of squares within
        %--sum of squared differences between subj vals & condn mean, summed across conditions
        for r = 1:numR;
            difValsSq(:,:,r) = (squeeze(tmpVals(:,r,:)) - wiCondnAvg).^2;%#ok
        end
        SSw = sum(sum(difValsSq,3),2); %add 'em up across rats, then add 'em up across conditions
            
        
        %calculate sum of squares subjects
        %--product of # of condns multipled by sum of squared difference between each subject's average across conditions and the grand avg
        for r = 1:numR;
            SSs(:,r) = (wiSubjXCondnAvg(:,r) - grandAvg).^2;%#ok
        end
        SSs = numC * sum(SSs,2); 
        
        
        %calculate sum of squares error
        SSe = SSw - SSs; 
        
        %calculate mean squares between and mean squares error
        MSb = SSb ./ (numC-1); 
        MSe = SSe ./ ((numR-1)*(numC-1)); 
        
        %calculate F Ratio
        origFRatio(:,p,mCntr) = MSb ./ MSe; %#ok 
        
    end
end

origPVals = fcdf(origFRatio, numC-1, (numC-1)*(numR-1)); %calculate p values given the dfs -- OP: vals x combo x metric





%% GET INDICES FOR EACH RANDOM SHUFFLE

fprintf ('   Getting indices for each random shuffle...\n');

numRats = size(metric(1).absValues,2);
numConds = size(metric(1).absValues,4);

numRandos = factorial(numConds)^numRats; %this many different ways to randomly assign the conditions are possible
if numRandos > desNumRandos
    numRandos = desNumRandos; %if we can do more than desNumRandos, just do desNumRandos. Otherwise, do max possible
end
fprintf ('      # of randomizations = %d\n', numRandos);

shufInds = zeros(numRats,numConds); %pre-allocate for first shuffle's indices
tmpInds = shufInds;
for r = 1:numRats
    shufInds(r,:) = randperm(numConds); %get the indices for the first shuffle
end

%go get all them shuffle inds
while size(shufInds,3) < numRandos
    for r = 1:numRats
        tmpInds(r,:) = randperm(numConds);%generate a new matrix of inds
    end
    check = 0;
    for i = 1:size(shufInds,3);
        check = isequal(tmpInds,shufInds(:,:,i)); %if it equals any of the already made ones
        if check == 1
            break%get out of this loop and don't add it in
        end
    end
    if check ~= 1%if it's a new one
        shufInds = cat(3,shufInds,tmpInds); %add it in
    end
end





%% GET ERROR RATIO FOR EACH RANDOM SHUFFLE
fprintf ('   Getting error ratio for each random shuffle and establishing statistical threshold...\n'); 
    
alphaFlip = 1 - initClustAlpha; %flip the alpha
clustMaxs = zeros(2,6,length(metNums),numRandos); %fRange x combos x metric x 

clear tmpVals
for s = 1:numRandos;
    tmpInds = shufInds(:,:,s);
    mCntr = 0;
    for m = metNums
        mCntr = mCntr + 1;
        for r = 1:numRats
            tmpVals(:,r,:,:,mCntr) = metric(m).absValues(:,r,:,tmpInds(r,:)); %OUTPUT: values x rat x combo x condn x metric
        end
    end
    
    wiCondnAvg = squeeze(mean(tmpVals,2));%average across rats, within condition -- OP: values x combo x condn x metric
    wiSubjXCondnAvg = squeeze(mean(tmpVals,4));%average across conditions, for each rat -- OP: values x rat x combo x metric
    grandAvg = squeeze(mean(wiCondnAvg,3)); %average across conditions -- OP: values x combo x metric
    
    
    %calculate sum of squares between (AKA: SStime)
    %--sum of squared differences between condn mean & grand mean, multipled by # of subjects
    clear SSb & difVals & SSw & SSs & SSe & MSb & MSe
    for c = 1:numC
        SSb(:,:,:,c) = (squeeze(wiCondnAvg(:,:,c,:)) - grandAvg).^2; %OP = vals x combo x metric x condn
    end
    SSb = sum(SSb,4) .* numR; %add 'em up across conditions & multiply by # of rats -- OP: vals x combo x metric
    
    
    %calculate sum of squares within
    %--sum of squared differences between subj vals & condn mean, summed across conditions
    for r = 1:numR; 
        difVals(:,:,:,:,r) = (squeeze(tmpVals(:,r,:,:,:)) - wiCondnAvg).^2; %#ok -- OP = vals x combo x condn x metric x rat
    end
    SSw = squeeze(sum(sum(difVals,5),3)); %add 'em up across rats, then add 'em up across conditions -- OP = vals x combo x metric
 
    
    %calculate sum of square subjects
    %--product of # of condns multipled by sum of squared difference between each subject's average across conditions and the grand avg
    for r = 1:numR; 
        SSs(:,:,:,r) = (squeeze(wiSubjXCondnAvg(:,r,:,:)) - grandAvg) .^ 2; 
    end
    SSs = numC * sum(SSs,4); %add 'em up across rats, and multiply by # of conditions -- OP: vals x combo x metric
    
    %calculate sum of squares error
    SSe = SSw - SSs;
    
    %calculate mean squares between and mean squares error
    MSb = SSb ./ (numC-1);
    MSe = SSe ./ ((numR-1)*(numC-1));
    
    %calculate F Ratio
    fRatio = MSb ./ MSe; %OP: vals x combo x metric x shuffle
    
    %calculate probability of value falling between 0 and F (lower end of the distribution! = higher is better)
    pVals = fcdf(fRatio, numC-1, (numC-1)*(numR-1));
    
    ptsAbThresh = zeros(size(pVals));
    ptsAbThresh(pVals >= alphaFlip) = 1;
    for m = 1:length(metNums)
        for p = 1:6
            for f = 1:2
                tmpFRange = fCuts(f,:);
                tmpPtsAbThresh = ptsAbThresh(allF>=tmpFRange(1) & allF<=tmpFRange(2),p,m);
                tmpPVals = pVals(allF>=tmpFRange(1) & allF<=tmpFRange(2),p,m);
                clusts = bwconncomp(tmpPtsAbThresh, 4);%2nd input doesn't matter; have to check length below
                for j = 1:length(clusts.PixelIdxList)
                    tmpInds = clusts.PixelIdxList{j};
                    if length(tmpInds) >= minClustLen(f)%if the cluster is long enough
                        clustSum = sum(tmpPVals(tmpInds)); %add up all the p values within it
                        if clustSum > clustMaxs(f,p,m,s); %and if it's greater than zero or the other clusters within this fRange/p/m/shuffle, then save it
                            clustMaxs(f,p,m,s) = clustSum;
                        end
                    end
                end
            end
        end
    end
    
end

clustMaxs = sort(clustMaxs,4); 
statThreshInd = round((1-statThreshAlpha)*numRandos); %establish index for statistical cutoff
statThresh = clustMaxs(:,:,:,statThreshInd); %find the statistical threshold for each freq range/p/m/shuffle




%% RETURN TO THE ORIGINAL P VALUES AND FIND CLUSTERS ABOVE THRESHOLD
fprintf ('   Identifying points in actual data above threshold...\n'); 

for f = 1:2
    tmpFRange = fCuts(f,:);
    tmpPVals = origPVals(allF>=tmpFRange(1) & allF<=tmpFRange(2),:,:);
    fRange(f).sigPts = zeros(size(tmpPVals)); %#ok 
    for m = 1:length(metNums)
        for p = 1:6
            ptsAbThresh = zeros(size(tmpPVals,1),1);
            ptsAbThresh(tmpPVals(:,p,m) >= alphaFlip) = 1;
            
            clusts = bwconncomp(ptsAbThresh, 4);%2nd input doesn't matter; have to check length below
            for j = 1:length(clusts.PixelIdxList)
                tmpInds = clusts.PixelIdxList{j};
                if length(tmpInds) >= minClustLen(f)%if the cluster is long enough
                    clustSum = sum(tmpPVals(tmpInds,p,m)); %add up all the p values within it
                    if clustSum > statThresh(f,p,m); %and if it's greater than zero or the other clusters within this fRange/p/m/shuffle, then save it
                        fRange(f).sigPts(tmpInds,p,m) = 1; 
                    end
                end
            end
        end
    end
end
sigPts = cat(1,fRange(1).sigPts, fRange(2).sigPts); 



%% OPTIONAL - CHECK DATA BY PLOTTING
if plotData == 1
    comboNames = {'DGCA3', 'DGCA1', 'DGSUB', 'CA3CA1', 'CA3SUB', 'CA1SUB'};
    for p = 1:6
        figure('name', comboNames{p})
        for m = 1:length(metNums); 
            subplot(2,3,m);
            hold on;
            plot(allF, origPVals(:,p,m));
            if sum(sigPts(:,p,m)) > 0
                plot(allF(sigPts(:,p,m)==1), origPVals(sigPts(:,p,m)==1,p,m), 'k*'); 
            end
            ylabel (['Metric #' num2str(m)]);
        end
    end
end


