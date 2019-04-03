function [origPVals, sigPts] = line_perm_test_rmAnova(data, allF, desNumRandos, plotOrNot)
% function [origPVals, sigPts] = line_perm_test_rmAnova(data, allF, desNumRandos, plotOrNot)
%
% PURPOSE:
%   A cluster based line-permutation statistical evaluation approach where averages per condition are shuffled
%   across conditions within a rat.
%
% INPUT:
%          data = data to be tested in the format samples x subject x condn (e.g., freqency x rat x behavioralState)
%          allF = vector of frequency values corresponding to each sample in data
%  desNumRandos = desired # of randomizations;
%                  maximum = numCondns! ^ numRats -- function will adjust desNumRandos accordingly if need be
%     plotOrNot = optional binary input indicating whether or not to plot the statistical outcome (pValues with asterisks indicating significant points)
%                 If left out, plotOrNot defaults to 0.
%
% OUTPUT:
%   origPVals = p values for the observed data (samples x 1)
%   sigPts = binary vector indicating which p values are significant (samples x 1)
%
% NOTES:
%   This function can be adjusted to work for any line but it is currently built for metrics by broad frequency range, from 2-100Hz.
%   - The reason this is significant is because different minimum cluster lengths are required for 20Hz and below vs. 20Hz and above
%
% JB Trimper
% 12/2016
% Colgin Lab*
%           *but adapted from very similar code developed in Manns Lab


%% SET OPTIONAL PARAMETERS
%
minClustLen = [2 4];
fCuts = [3 20; 21 100]; %these should be the freq ranges that line up with each taper, and each minClustLen
if length(allF) ~= size(data,1)
    error('Assumed frequency range does not match actual');
end
numC = size(data,3); %# of conditions
numR = size(data,2); %# of rats
statThreshAlpha = .025; %statistical threshold (because therea are two fRanges, split .05 in two)
initClustAlpha = 0.1; %alpha level for initial cluster detection


%% DEFAULT PLOTTING PREFERENCE, IF NEED BE

if nargin == 3
    plotOrNot = 0; %set plotOrNot to 1 to do optional plotting (for visually checking statistically significant line segments)
end

%% GET THE F RATIO FOR THE ORIGINAL DATA

wiCondnAvg = squeeze(mean(data,2));%average across rats, within condition --> OP = vals x condn
wiSubjXCondnAvg = squeeze(mean(data,3));%average across conditions, for each rat --> OP = vals x rat
grandAvg = mean(wiCondnAvg,2); %grand average, x Condns, x Subjs --> OP = vals

%calculate sum of squares between (AKA: SStime)
%--sum of squared differences between condn mean & grand mean, multipled by # of subjects
for c = 1:numC
    SSb(:,c) = (wiCondnAvg(:,c) - grandAvg).^2; %#ok --
end
SSb = sum(SSb,2) .* numR; %sum of squared differences across conditions x # of rats

%calculate sum of squares within
%--sum of squared differences between subj vals & condn mean, summed across conditions
for r = 1:numR
    difValsSq(:,:,r) = (squeeze(data(:,r,:)) - wiCondnAvg).^2;%#ok
end
SSw = sum(sum(difValsSq,3),2); %add 'em up across rats, then add 'em up across conditions

%calculate sum of squares subjects
%--product of # of condns multipled by sum of squared difference between each subject's average across conditions and the grand avg
for r = 1:numR
    SSs(:,r) = (wiSubjXCondnAvg(:,r) - grandAvg).^2;%#ok
end
SSs = numC * sum(SSs,2);

%calculate sum of squares error
SSe = SSw - SSs;

%calculate mean squares between and mean squares error
MSb = SSb ./ (numC-1);
MSe = SSe ./ ((numR-1)*(numC-1));

%calculate F Ratio
origFRatio = MSb ./ MSe;

origPVals = fcdf(origFRatio, numC-1, (numC-1)*(numR-1)); %calculate p values given the dfs -- OP: vals x combo x metric





%% GET INDICES FOR EACH RANDOM SHUFFLE

fprintf ('   Getting indices for each random shuffle...\n');

numRats = size(data,2);
numConds = size(data,3);

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
    for i = 1:size(shufInds,3)
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
clustMaxs = zeros(2,numRandos); %fRange x numRandos

clear tmpVals
for s = 1:numRandos
    tmpInds = shufInds(:,:,s);
    
    for r = 1:numRats
        tmpVals(:,r,:) = data(:,r,tmpInds(r,:)); %OUTPUT: values x rat  x condn
    end
    
    wiCondnAvg = squeeze(mean(tmpVals,2));%average across rats, within condition -- OP: values x condn
    wiSubjXCondnAvg = squeeze(mean(tmpVals,3));%average across conditions, for each rat -- OP: values x rat
    grandAvg = squeeze(mean(wiCondnAvg,2)); %average across conditions -- OP: values
    
    
    %calculate sum of squares between (AKA: SStime)
    %--sum of squared differences between condn mean & grand mean, multipled by # of subjects
    clear SSb & difVals & SSw & SSs & SSe & MSb & MSe
    for c = 1:numC
        SSb(:,c) = (squeeze(wiCondnAvg(:,c)) - grandAvg).^2; %OP = vals x  condn
    end
    SSb = sum(SSb,2) .* numR; %add 'em up across conditions & multiply by # of rats -- OP: vals
    
    
    %calculate sum of squares within
    %--sum of squared differences between subj vals & condn mean, summed across conditions
    for r = 1:numR
        difVals(:,:,r) = (squeeze(tmpVals(:,r,:)) - wiCondnAvg).^2; %#ok -- OP = vals x condn x rat
    end
    SSw = squeeze(sum(sum(difVals,3),2)); %add 'em up across rats, then add 'em up across conditions -- OP = vals x combo x metric
    
    
    %calculate sum of square subjects
    %--product of # of condns multipled by sum of squared difference between each subject's average across conditions and the grand avg
    for r = 1:numR
        SSs(:,r) = (squeeze(wiSubjXCondnAvg(:,r)) - grandAvg) .^ 2;
    end
    SSs = numC * sum(SSs,2); %add 'em up across rats, and multiply by # of conditions -- OP: vals
    
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
    for f = 1:2
        tmpFRange = fCuts(f,:);
        tmpPtsAbThresh = ptsAbThresh(allF>=tmpFRange(1) & allF<=tmpFRange(2));
        tmpPVals = pVals(allF>=tmpFRange(1) & allF<=tmpFRange(2));
        clusts = bwconncomp(tmpPtsAbThresh, 4);%2nd input doesn't matter; have to check length below
        for j = 1:length(clusts.PixelIdxList)
            tmpInds = clusts.PixelIdxList{j};
            if length(tmpInds) >= minClustLen(f)%if the cluster is long enough
                clustSum = sum(tmpPVals(tmpInds)); %add up all the p values within it
                if clustSum > clustMaxs(f,s) %and if it's greater than zero or the other clusters within this fRange/p/m/shuffle, then save it
                    clustMaxs(f,s) = clustSum;
                end
            end
        end
    end
end

clustMaxs = sort(clustMaxs,2);
statThreshInd = round((1-statThreshAlpha)*numRandos); %establish index for statistical cutoff
statThresh = clustMaxs(:,statThreshInd); %find the statistical threshold for each freq range/p/m/shuffle




%% RETURN TO THE ORIGINAL P VALUES AND FIND CLUSTERS ABOVE THRESHOLD
fprintf ('   Identifying points in actual data above threshold...\n');
sigClusts = cell(1,2);
for f = 1:2
    tmpFRange = fCuts(f,:);
    tmpFVctr = tmpFRange(1):tmpFRange(2);
    tmpPVals = origPVals(allF>=tmpFRange(1) & allF<=tmpFRange(2));
    fRange(f).sigPts = zeros(size(tmpPVals)); %#ok
    ptsAbThresh = zeros(size(tmpPVals,1),1);
    ptsAbThresh(tmpPVals >= alphaFlip) = 1;
    
    clusts = bwconncomp(ptsAbThresh, 4);%2nd input doesn't matter; have to check length below
    for j = 1:length(clusts.PixelIdxList)
        tmpInds = clusts.PixelIdxList{j};
        if length(tmpInds) >= minClustLen(f)%if the cluster is long enough
            clustSum = sum(tmpPVals(tmpInds)); %add up all the p values within it
            if clustSum > statThresh(f) %and if it's greater than zero or the other clusters within this fRange/p/m/shuffle, then save it
                fRange(f).sigPts(tmpInds) = 1;
                pctile = (find(clustMaxs(f,:)<=clustSum, 1, 'Last') / size(clustMaxs,2)) * 100;
                sigClusts{f} = [sigClusts{f}; clustSum length(tmpInds) tmpFVctr(tmpInds(1)) tmpFVctr(tmpInds(end)) pctile];
            end
        end
    end
end

sigPts = cat(1,fRange(1).sigPts, fRange(2).sigPts);



%% OPTIONAL - CHECK DATA BY PLOTTING
if plotOrNot == 1
    figure
    hold on;
    plot(allF, origPVals);
    if sum(sigPts) > 0
        plot(allF(sigPts==1), origPVals(sigPts==1), 'k*');
    end
end


%% REPORT STATS
fprintf('STATISTICS:\n');
for f = 1:2
    fprintf('Freq Range %d\n', f);
    fprintf('\tChance Distribution Avg +/- STD: %0.03g +/- %0.03g\n', mean(clustMaxs(f,:),2), std(clustMaxs(f,:),[],2));
    fprintf('\t          Cluster Max Threshold: %0.03g\n\n', statThresh(f));
    fprintf('\tSignificant Clusters: \n');
    if ~isempty(sigClusts{f})
        for c = 1:size(sigClusts{f},1)
            fprintf('\t\t#%d\n', c);
            fprintf('\t\t\t  Cluster Sum: %0.04g\n', sigClusts{f}(c,1));
            fprintf('\t\t\t      Num Pts: %d\n', sigClusts{f}(c,2));
            fprintf('\t\t\tCluster Range: %d\n', sigClusts{f}(c,3), sigClusts{f}(c,4));
            fprintf('\t\t\t   Percentile: %0.04g\n', sigClusts{f}(c,5));
        end
    else
        fprintf('\t\tNone.\n') ;
    end
end



end%function

