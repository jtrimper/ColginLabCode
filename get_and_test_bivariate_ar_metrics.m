function [metric, allF] = get_and_test_bivariate_ar_metrics(rat, desNumOrigIts, varargin)
%function metric = get_and_test_spec_bivariate_ar_metrics(rat, desNumOrigIts, numStatShufs, runStats, plotResults, condnNames)
%
% Uses MVGC/BIOSIG to calculate bivariate AR model and directed transfer function, and tests data
% within regPairion pairing/subregion for statistically significant differences in each metric across conditions.
%
% Uses subsampling procedure to equate number of trials within each condition. Specify number of subsampling iterations
% with desNumOrigIts.
%
% Uses randomization and cluster-based approach to test for statistical significane. See optional input below.
%
% Uses a repeated measures ANOVA for each frequency bin to calculate a p-value, then tests are run on the pValues.
%
% Uses default parameters provided by 'calc_bivariate_AR_metrics_via_mvgc'
%
% *NOTE: If desNumOrigIts == 1, no subsampling will take place*
%
% INPUTS:
%               rat = structure containing EEG data for each condition
%                     rat.condn.eegData = samples x sweeps x numRegs
%     desNumOrigIts = desired number of subsampling iterations for estimating spectral measures
%
%     OPTIONAL FLAGS & THEIR RESPECTIVE KEYS:
%              runStats: enter flag 'runStats' and follow with binary indicating whether or not to run statistical tests
%                           e.g., if varargin{x} = 'runStats', varargin{x+1} should be binary indicating whether or not to
%                                 run stats, and if varargin{x+1} == 1, varargin{x+2} should designate desired number of statistical
%                                 randomizations (see example call below)
%                        DEFAULT: runStats = 0; %no stat tests performed
%
%             plotStats: enter flag 'plotStats' followed by binary key indicating whether or not to plot stats
%                        DEFAULT: plotStats = 0; %stats not plotted
%
%             saveFigs: enter flag 'saveFigs', followed by string indicating which directory to save figures in. Directory MUST already exist!
%                       DEFAULT: saveFigs = 0; %figures not saved automatically
%
%          plotResults: enter flag 'plotResults' followed by binary key indicating whether or not to plot results
%                       DEFAULT: plotResults = 1; %figures of results are created
%
%           condnNames: enter flag 'condnNames' followed by cell array containing names for each condition entered.
%                       These are used in the plot legends.
%                       DEFAULT: condnNames = {'Condn1', 'Condn2', ... 'CondnN'};
%
%         runFactorial: enter flag 'runFactorial' followed by binary key indicating whether or not to run a full factorial looking for
%                       a main effect of subregion/subregion pairing, main effect of condition, and interaction
%                          - WARNING: This will make the function take MUCH longer. It requires four more randomization calculation loops, and
%                            dependent on the number of desired statistical shuffles/number of sweeps/etc, this could take days.
%                       DEFAULT: runFactorial = 0; %do NOT run factorial
%
%
% OUTPUT:
%        metric = data structure containing fields:
%                      absValues = actual values for each rat (freqBin x rat x regPair x condition)
%                         absSEM = standard error across rats for absolute scores (freqBin x regPair x condition)
%                         absAVG = average across rats for absolute scores (freqBin x regPair x condition)
%
%                         values = difference values, relative to the mean across condtiions, for each rat (freqBin x rat x regPair x condition)
%                            AVG = average across rats for difference scores (freqBin x regPair x condition)
%                            SEM = standard error across rats for difference scores (freqBin x regPair x condition)
%
%                         sigPts = binary array where ones indicate statistically significant
%                                   sigPts will only be a field if 'runStats' is set to one, or 'runStats' input is left out
%
%         allF = frequency values (Hz) for each frequency bin (freqBin x regPair)
%
%
% EXAMPLE CALL WITH ALL OPTIONAL INPUTS:
%  [metric, allF] = get_and_test_bivariate_ar_metrics(rat, 8, 'plotStats', 1, 'plotResults', 1, 'saveFigs', 'C:\MySaveFolder', 'runStats', 1, 13, 'condnNames', {'Stat', 'Move', 'Explore', 'Approach'})
%
% JBT 4/7/16




%% SET UP SOME OF THE BASICS
numRats = 0;
for r = 1:length(rat);
    numRats = numRats + isfield(rat(r).condn, 'eegData');
end
numSamps = size(rat(1).condn(1).eegData,1);
numCondns = length(rat(1).condn);
numRegs = size(rat(1).condn(1).eegData,3);
if numRegs > 4
    error('Function can currently handle up to four subregions only.\n')
end

%which region combos are of interest (assuming projections are unilateral from 1->2->...n
if numRegs == 2, combos = [1 2];
elseif numRegs == 3, combos = [1 2; 2 3];
elseif numRegs == 4, combos = [1 2; 2 3; 3 4];
end

numPairs = size(combos,1); %# of possible pairs of subregions

%suppress warning messages from 'nchoosek'
id = 'MATLAB:nchoosek:LargeCoefficient';
warning('off', id);

initClustAlpha = .1; %for initial cluster detection
statsAlpha = .025; %.05 for each of the two frequency ranges
minClustLen = [2 4]; %minClustLen(x) consecutive points for each fRange



%% SET DEFAULTS, THEN CHECK FOR OPTIONAL INPUTS TO OVER-RIDE
runStats = 0;
plotStats = 0;
plotResults = 1;
runFactorial = 0;
for c = 1:numCondns;
    condnNames{c} = ['Condn ' num2str(c)]; %#ok
end
saveFigs = 0;


% CHECK OPTIONAL INPUTS
if nargin > 3
    for v = 1:length(varargin)
        
        if strcmpi(varargin{v}, 'runStats');
            runStats = varargin{v+1};
            if runStats == 1
                numStatShufs = varargin{v+2};
            end
        elseif strcmpi(varargin{v}, 'plotStats')
            plotStats = varargin{v+1};
        elseif strcmpi(varargin{v}, 'plotResults')
            plotResults = varargin{v+1};
        elseif strcmpi(varargin{v}, 'saveFigs');
            saveFigs = 1;
            saveFolder = varargin{v+1};
            curDir = pwd;
        elseif strcmpi(varargin{v}, 'condnNames')
            condnNames = varargin{v+1};
        elseif strcmpi(varargin{v}, 'runFactorial')
            runFactorial = varargin{v+1};
            runStats = 1;
        end
        
    end
end


if plotStats == 1 && runStats ~= 1;
    fprintf('\n\n ~~~~~~> Can not plot statistical results without also running stats!\n\n\tStat figures will not be created\n\tCancel function [ctrl + c] and revise input, or hit any button to continue...\n');
    pause
end

%% CHECK SAVE FOLDER
if saveFigs
    cwd = pwd;
    try
        cd (saveFolder);
    catch
        error('Save folder string does not lead to good directory.');
    end
    cd (cwd);
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                                           %
%                CALCULATE BIVARIATE AR METRICS VIA SUBSAMPLING FOR THE ORIGINAL DATA                       %
%                      THEN CALCULATE SPECTRAL MEASURES FOR EACH RANDOMIZATION                              %
%                                                                                                           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
maxPossibleCondnStatShufs = zeros(1,numRats);
maxPossibleRegPairStatShufs = zeros(1,numRats);
maxPossiblePairxCondnShufs = zeros(1,numRats);

for r = 1:numRats;
    fprintf('\tRat %d\n', r);
    numSwps = arrayfun(@(x) size(x.eegData,2), rat(r).condn); %num swps / condn
    minNumSwps = min(numSwps);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                                                                                 %
    %                  CALCULATE BIVARIATE AR METRICS FOR THE ACTUAL DATA                             %
    %                                                                                                 %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    fprintf('\t  Calculating spectral estimates for subsampled original data...\n');
    for c = 1:numCondns;
        fprintf('\t    Condn %d\n', c);
        
        %% CLEAR AR METRIC VARIABLES
        clear DTF & S & COH
        
        %% HOW MANY SUBSAMPLING ITERATIONS ARE POSSIBLE FOR ESTIMATING ACTUAL SPECTRAL ESTIMATES FOR EACH CONDITION?
        maxPossibleIts = nchoosek(numSwps(c), minNumSwps);
        if maxPossibleIts > desNumOrigIts
            maxPossibleIts = desNumOrigIts;
        end
        
        
        %% FIND INDICES FOR EACH SUBSAMPLING ITERATION
        condn(c).ssInds = []; %#ok
        if maxPossibleIts == 1
            condn(c).ssInds = 1:numSwps(c);%#ok
        else
            allSwpInds = randperm(numSwps(c));
            condn(c).ssInds(1,:) = allSwpInds(1:minNumSwps);%#ok
            while size(condn(c).ssInds,1) < maxPossibleIts
                check = 0;
                allSwpInds = randperm(numSwps(c));
                tmpOrder = allSwpInds(1:minNumSwps);
                for i = 1:size(condn(c).ssInds,1)
                    check = isequal(tmpOrder, condn(c).ssInds(i,:));
                    if check
                        break
                    end
                end
                if ~check
                    condn(c).ssInds = cat(1,condn(c).ssInds, tmpOrder);
                end
            end
        end
        
        
        %% RUN THROUGH SUBSAMPLING ITERATIONS AND CALCULATE KEY METRICS
        
        clear tmpCondn
        
        for s = 1:maxPossibleIts;
            fprintf ('\t      Iteration #%d\n', s)
            
            tmpSsInds = condn(c).ssInds(s,:);
            
            for p = 1:numPairs;
                fprintf('\t        *** Region Pair #%d ***\n', p);
                reg1 = combos(p,1);
                reg2 = combos(p,2);
                
                %get subsampled eeg data
                eegData = rat(r).condn(c).eegData(:,tmpSsInds, [reg1 reg2]);
                
                
                %calculate metrics
                [DTF(:,p,s), S(:,p,s), COH(:,p,s), allF, params] = get_bivar_AR_mets_from_eeg_data(eegData);%#ok
                
            end %combos
        end%shuffle iteration
        
        %% AVERAGE ACROSS SHUFFLES
        
        metric(1).absValues(:,r,:,c) = mean(DTF,3);
        metric(2).absValues(:,r,:,c) = mean(S,3);
        metric(3).absValues(:,r,:,c) = mean(COH,3);
        
        
    end%conditions
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                                                                                 %
    %                     CALCULATE SPECTRAL ESTIMATES FOR THE RANDOMIZED DATA                        %
    %                                                                                                 %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if runStats == 1;
        
        
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %                  ACROSS CONDITION RANDOMIZATIONS                     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        fprintf('\n\t\tCalculating spectral estimates for randomizations across conditions...\n');
        %% HOW MANY ACROSS CONDITION RANDOMIZATION SHUFFLES ARE POSSIBLE?
        maxPossibleCondnStatShufs(r) = nchoosek(minNumSwps * numCondns, minNumSwps);
        if maxPossibleCondnStatShufs(r) > numStatShufs
            maxPossibleCondnStatShufs(r) = numStatShufs;
        end
        
        
        %% GET SWEEP INDICES FOR EACH STATISTICAL SHUFFLE
        condnStatShufInds = [];
        condnStatShufInds(1,:) = randperm(minNumSwps * numCondns);
        
        while size(condnStatShufInds,1) < maxPossibleCondnStatShufs(r)
            check = 0;
            tmpOrder = randperm(minNumSwps * numCondns);
            for i = 1:size(condnStatShufInds,1)
                check = isequal(tmpOrder, condnStatShufInds(i,:));
                if check
                    break
                end
            end
            if ~check
                condnStatShufInds = cat(1,condnStatShufInds, tmpOrder);
            end
        end
        
        
        %% MAKE SURE YOU HAVE ENOUGH SWEEP SUBSAMPLING INDS FOR EACH ACROSS CONDITION RANDOMIZATION
        %   Because they're pulled from above portion for calculating spec estimates from original data
        %   and, for at least one of the conditions for each rat, there is only one subsampling iteration
        %   (Because we subsample each condition down to the lowest # of sweeps across conditions)
        
        numCondnShufs = arrayfun(@(x) size(x.ssInds,1), condn);
        for c = 1:numCondns;
            difBtw = maxPossibleCondnStatShufs(r) - numCondnShufs(c);
            if difBtw >= 0
                numReps = ceil(difBtw/size(condn(c).ssInds,1));
                tmpNewReps = repmat(condn(c).ssInds, numReps,1);
                tmpNewReps = tmpNewReps(randperm(size(tmpNewReps,1)),:);
                randCondn(c).ssInds = [condn(c).ssInds; tmpNewReps(1:difBtw,:)]; %#ok
            else
                randCondn(c).ssInds = condn(c).ssInds; %#ok
            end
        end
        
        
        %% GO THROUGH ALL THE SHUFFLE ITERATIONS, CALCULATING SPECTRAL MEASURES FOR DATA RANDOMIZED ACROSS CONDITIONS
        
        for s = 1:maxPossibleCondnStatShufs(r);
            fprintf ('\t      Iteration #%d\n', s)
            
            allCondnData = rat(r).condn(1).eegData(:,randCondn(1).ssInds(s,:),:);
            for c = 2:numCondns;
                allCondnData = cat(2, allCondnData, rat(r).condn(c).eegData(:,randCondn(c).ssInds(s,:),:));
            end
            newOrder = condnStatShufInds(s,:);
            allCondnData = allCondnData(:,newOrder,:);
            
            for c = 1:numCondns;
                fprintf('\t        CONDN %d\n', c);
                startInd = (c-1)*minNumSwps+1;
                for p = 1:numPairs;
                    fprintf('\t        *** Region Pair #%d ***\n', p);
                    reg1 = combos(p,1);
                    reg2 = combos(p,2);
                    
                    %get subsampled eeg data
                    eegData = allCondnData(:,startInd:startInd + minNumSwps - 1, [reg1 reg2]);
                    
                    %calculate metrics
                    [tmpDtf, tmpS, tmpCoh] = get_bivar_AR_mets_from_eeg_data(eegData);
                    
                    %store
                    condnRandRat(r).metric(1).values(:,s,p,c) = tmpDtf;
                    condnRandRat(r).metric(2).values(:,s,p,c) = tmpS;
                    condnRandRat(r).metric(3).values(:,s,p,c) = tmpCoh;
                    
                end%combo
            end %condn
        end %shuffles
        
        
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %    CALCULATE SPECTRAL ESTIMATES REQUIRED FOR FACTORIAL ANALYSIS     %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        if runFactorial == 1;
            
            
            
            %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %          ACROSS REG PAIRING X CONDITION RANDOMIZATIONS               %
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            fprintf('\n\t\tCalculating interaction metrics for randomizations across region pairings AND conditions...\n');
            
            
            %% HOW MANY CONDITION X REGION PAIRING RANDOMIZATION SHUFFLES ARE POSSIBLE?
            maxPossibleRegPairStatShufs(r) = nchoosek(minNumSwps * numPairs, minNumSwps);
            maxPossiblePairxCondnShufs(r) = maxPossibleRegPairStatShufs(r) * maxPossibleCondnStatShufs(r);
            if maxPossiblePairxCondnShufs(r) > numStatShufs
                maxPossiblePairxCondnShufs(r) = numStatShufs;
            end
            
            
            %% GET SWEEP INDICES FOR EACH STATISTICAL SHUFFLE
            pairXCondnStatShufInds = [];
            pairXCondnStatShufInds(1,:) = randperm(minNumSwps * numCondns * numPairs);
            
            while size(pairXCondnStatShufInds,1) < maxPossiblePairxCondnShufs(r)
                check = 0;
                tmpOrder = randperm(minNumSwps * numCondns * numPairs);
                for i = 1:size(pairXCondnStatShufInds,1)
                    check = isequal(tmpOrder, pairXCondnStatShufInds(i,:));
                    if check
                        break
                    end
                end
                if ~check
                    pairXCondnStatShufInds = cat(1,pairXCondnStatShufInds, tmpOrder);
                end
            end
            
            
            %% MAKE SURE YOU HAVE ENOUGH SWEEP SUBSAMPLING INDS FOR EACH REGION PAIR X CONDN RANDOMIZATION
            %   Because they're pulled from above portion for calculating spec estimates from original data
            %   and, for at least one of the conditions for each rat, there is only one subsampling iteration
            %   (Because we subsample each condition down to the lowest # of sweeps across conditions)
            
            numCondnShufs = arrayfun(@(x) size(x.ssInds,1), condn);
            for c = 1:numCondns;
                difBtw = maxPossiblePairxCondnShufs(r) - numCondnShufs(c);
                if difBtw >= 0
                    numReps = ceil(difBtw/size(condn(c).ssInds,1));
                    tmpNewReps = repmat(condn(c).ssInds, numReps,1);
                    tmpNewReps = tmpNewReps(randperm(size(tmpNewReps,1)),:);
                    randPairXCondn(c).ssInds = [condn(c).ssInds; tmpNewReps(1:difBtw,:)]; %#ok
                else
                    randPairXCondn(c).ssInds = condn(c).ssInds; %#ok
                end
            end
            
            
            
            %% GO THROUGH ALL THE SHUFFLE ITERATIONS, CALCULATING SPECTRAL MEASURES FOR DATA RANDOMIZED ACROSS REGION PAIR AND CONDITION
            
            for s = 1:maxPossiblePairxCondnShufs(r);
                fprintf ('\t      Iteration #%d\n', s)
                
                allRegAllCondnData = [];
                for c = 1:numCondns
                    for p = 1:numPairs;
                        reg1 = combos(p,1);
                        reg2 = combos(p,2);
                        allRegAllCondnData = cat(2, allRegAllCondnData, [rat(r).condn(c).eegData(:,randPairXCondn(c).ssInds(s,:),reg1); rat(r).condn(c).eegData(:,randPairXCondn(c).ssInds(s,:),reg2)]);
                    end
                end
                newOrder = pairXCondnStatShufInds(s,:);
                allRegAllCondnData = allRegAllCondnData(:,newOrder);
                
                for c = 1:numCondns
                    for p = 1:numPairs;
                        startInd = (p-1)*minNumSwps + (c-1)*numPairs * minNumSwps + 1;
                        
                        %get pre-calculated spectrum and cross-spectrum
                        eegData(:,:,1) = allRegAllCondnData(1:numSamps,startInd:startInd + minNumSwps - 1);
                        eegData(:,:,2) = allRegAllCondnData(numSamps+1:end,startInd:startInd + minNumSwps - 1);
                        
                        %calculate metrics
                        [tmpDtf, tmpS, tmpCoh] = get_bivar_AR_mets_from_eeg_data(eegData);
                        
                        %store
                        subregXCondnRandRat(r).metric(1).values(:,s,p,c) = tmpDtf;
                        subregXCondnRandRat(r).metric(2).values(:,s,p,c) = tmpS;
                        subregXCondnRandRat(r).metric(3).values(:,s,p,c) = tmpCoh;
                        
                        
                    end%combo
                end %condn
            end %shuffles
            
            
        end%runFactorial
    end %runStats
end%rat

fpass_opts = [params(1).fpass; params(2).fpass];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                                 %
%                     AVERAGE ACROSS RATS AND FIND ERROR FOR ACTUAL DATA                          %
%                                                                                                 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% FOR ACTUAL DATA, GET AVG & ERROR FOR ABS VALUES
for m = 1:3
    metric(m).absSEM = squeeze(semfunct(metric(m).absValues,2));%find sem x rats
    metric(m).absAVG = squeeze(mean(metric(m).absValues,2));%find avg x rats
end


%% FOR ACTUAL DATA, GET DIF FROM MEAN FOR EACH CONDN (FOR EACH RAT, THEN AVERAGE ACROSS RATS)
for m = 1:3
    tmpMean = mean(metric(m).absValues,4);%get an avg x condns for each rat
    for c = 1:numCondns;
        metric(m).values(:,:,:,c) =  metric(m).absValues(:,:,:,c) - tmpMean; %find the difference, for each rat, between each condn and the mean across condns
    end
    metric(m).SEM = squeeze(semfunct(metric(m).values,2));%then find sem x rats
    metric(m).AVG = squeeze(mean(metric(m).values,2));%and average the dif vals across rats
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                                  %
%                  FIND P-VALUES AND DETECT CLUSTERS FOR RANDOMIZED DATA                           %
%                                                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if runStats == 1;
    fprintf('\n\nCalculating p-values for randomized data and establishing significance threshold...\n');
    
    initClustAlpha = 1 - initClustAlpha; %flip the initial cluster detection alpha
    statsAlpha = 1 - statsAlpha; %and the final alpha (so higher is better);
    
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %             FIRST FOR RANDOMIZATIONS ACROSS CONDITIONS                 %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% MAKE SURE EVERY RAT HAS THE SAME NUMBER OF RANDOMIZATIONS
    maxNumRandos = max(maxPossibleCondnStatShufs);
    if sum(abs(diff(maxPossibleCondnStatShufs))) ~= 0
        for r = 1:numRats;
            difBtw = maxNumRandos - maxPossibleCondnStatShufs(r);
            if difBtw ~= 0
                numReps = ceil(difBtw/maxPossibleCondnStatShufs(r));
                for m = 1:3
                    for p = 1:numPairs;
                        for c = 1:numCondns;
                            tmpNewReps = repmat(condnRandRat(r).metric(m).values(:,1:maxPossibleCondnStatShufs(r),p,c)', numReps, 1);
                            tmpNewReps = tmpNewReps(randperm(size(tmpNewReps,1)),:)';
                            condnRandRat(r).metric(m).values(:,maxPossibleCondnStatShufs(r)+1:maxNumRandos,p,c) = tmpNewReps(:,1:difBtw);
                        end
                    end
                end
            end
        end
    end
    
    
    %% GET AVERAGES ACROSS RATS FOR EVERY RANDOMIZATION, DETECT CLUSTERS, ESTABLISH STATISTICAL THRESHOLD
    
    clustMaxs = zeros(2,3,max(maxPossibleCondnStatShufs),numPairs); %fRange x metric x numShufs x numPairs
    fprintf('\t\tFor within subregion/subregion pairing, for effect of condition...\n');
    for m = 1:3;
        fprintf('\t\t\tMetric %d\n', m);
        
        for r = 1:numRats;
            randVals(:,:,:,:,r) = condnRandRat(r).metric(m).values; %#okv
        end
        
        for s = 1:maxNumRandos
            
            for p = 1:numPairs;
                for f = 1:length(allF);
                    testData = squeeze(randVals(f,s,p,:,:))';
                    A = one_way_rm_anova(testData);
                    randPVals(f) = A.p; %#ok
                end
                randPVals = 1 - randPVals; %flip alpha so higher is better
                ptsAbThresh = zeros(size(randPVals));
                ptsAbThresh(randPVals >= initClustAlpha) = 1;
                
                
                for fRan = 1:2;
                    tmpFRange = [fpass_opts(fRan,1) fpass_opts(fRan,2)];
                    fRanInds = find(allF>=tmpFRange(1) & allF<=tmpFRange(2));
                    tmpPVals = randPVals(fRanInds);
                    tmpPtsAbThresh = ptsAbThresh(fRanInds);
                    
                    clusts = bwconncomp(tmpPtsAbThresh, 4);%find clusters of points above threshold -- FYI: 2nd input doesn't matter; have to check length below
                    for j = 1:length(clusts.PixelIdxList)%for each cluster
                        tmpInds = clusts.PixelIdxList{j};%get the indices
                        if length(tmpInds) >= minClustLen(fRan)%if the cluster is long enough
                            clustSum = sum(tmpPVals(tmpInds)); %add up all the p values within it
                            if clustSum > clustMaxs(fRan,m,s,p); %and if it's greater than zero or the other clusters within this fRange/metric/shuffle
                                clustMaxs(fRan,m,s,p) = clustSum; %then save it
                            end
                        end
                    end
                end
            end
        end
    end
    
    condnClustMaxs = sort(clustMaxs,3);
    condnStatThresh = squeeze(condnClustMaxs(:,:,round(maxNumRandos * statsAlpha),:)); %OP = fRan x metric x regPair
    
    
    
    
    if runFactorial == 1
        
        
        %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %        FOR RANDOMIZATIONS ACROSS REGION PAIRING AND CONDITIONS         %
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        %% MAKE SURE EVERY RAT HAS THE SAME NUMBER OF RANDOMIZATIONS
        maxNumRandos = max(maxPossiblePairxCondnShufs);
        if sum(abs(diff(maxPossiblePairxCondnShufs))) ~= 0
            for r = 1:numRats;
                difBtw = maxNumRandos - maxPossiblePairxCondnShufs(r);
                if difBtw ~= 0
                    numReps = ceil(difBtw/maxPossiblePairxCondnShufs(r));
                    for m = 1:3
                        for p = 1:numPairs;
                            for c = 1:numCondns;
                                tmpNewReps = repmat(subregXCondnRandRat(r).metric(m).values(:,1:maxPossiblePairxCondnShufs(r),p,c)', numReps, 1);
                                tmpNewReps = tmpNewReps(randperm(size(tmpNewReps,1)),:)';
                                subregXCondnRandRat(r).metric(m).values(:,maxPossiblePairxCondnShufs(r)+1:maxNumRandos,p,c) = tmpNewReps(:,1:difBtw);
                            end
                        end
                    end
                end
            end
        end
        
        
        %% GET AVERAGES ACROSS RATS FOR EVERY RANDOMIZATION, DETECT CLUSTERS, ESTABLISH STATISTICAL THRESHOLD
        fprintf('\t\tFor subregion/region pairing by condition interaction...\n');
        clustMaxs = zeros(2,3,max(maxPossiblePairxCondnShufs),3); %fRange x metric x numShufs x effect (2Mains+1Int)
        for m = 1:3
            fprintf('\t\t\tMetric %d\n', m);
            
            clear randVals
            for r = 1:numRats;
                randVals(:,:,:,:,r) = subregXCondnRandRat(r).metric(m).values; %OP = freq x shuf x pair x condn x rat
            end
            
            for s = 1:maxNumRandos
                
                for f = 1:length(allF);
                    testData = squeeze(randVals(f,s,:,:,:));
                    testData = permute(testData, [3 1 2]); %OP = rats x regPair x condn
                    
                    [me, int] = fact_rm_anova(testData);
                    
                    randPVals(f,1) = me.A.p; %main effect of condn
                    randPVals(f,2) = me.B.p; %main effect of region pair
                    randPVals(f,3) = int.p; %regPair x condn intxn
                end
                randPVals = 1 - randPVals; %flip alpha so higher is better
                
                ptsAbThresh = zeros(size(randPVals));
                ptsAbThresh(randPVals >= initClustAlpha) = 1;
                
                for ef = 1:3;
                    for fRan = 1:2;
                        tmpFRange = [fpass_opts(fRan,1) fpass_opts(fRan,2)];
                        fRanInds = find(allF>=tmpFRange(1) & allF<=tmpFRange(2));
                        tmpPVals = randPVals(fRanInds,ef);
                        tmpPtsAbThresh = ptsAbThresh(fRanInds,ef);
                        
                        clusts = bwconncomp(tmpPtsAbThresh, 4);%find clusters of points above threshold -- FYI: 2nd input doesn't matter; have to check length below
                        for j = 1:length(clusts.PixelIdxList)%for each cluster
                            tmpInds = clusts.PixelIdxList{j};%get the indices
                            if length(tmpInds) >= minClustLen(fRan)%if the cluster is long enough
                                clustSum = sum(tmpPVals(tmpInds)); %add up all the p values within it
                                if clustSum > clustMaxs(fRan,m,s,ef); %and if it's greater than zero or the other clusters within this fRange/metric/shuffle
                                    clustMaxs(fRan,m,s,ef) = clustSum; %then save it
                                end
                            end
                        end
                    end
                end
            end
        end
        
        ffAnovaIntxnMetsClustMaxs = sort(clustMaxs,3); %this will be used
        ffAnovaStatThresh = squeeze(ffAnovaIntxnMetsClustMaxs(:,:,round(maxNumRandos * statsAlpha),:)); %OP = fRan x metric x effect
        
    end%if runFactorial
    
    
    
    
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %                                                                                                  %
    %                                 FIND P VALUES FOR ACTUAL DATA                                    %
    %                                                                                                  %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf('\n\nCalculating p-values for original data and detecting significant clusters...\n');
    
    %% FOR WITHIN REGION/REGION PAIR --> EFFECT OF CONDITION
    for m = 1:3
        for p = 1:numPairs
            for f = 1:length(allF);
                testData = squeeze(metric(m).absValues(f,:,p,:)); %freq x rat x regCombo x condn
                A = one_way_rm_anova(testData);
                wiPairRMAnovaOrigPVals(f,p,m) = A.p; %#ok
            end
        end
    end
    wiPairRMAnovaOrigPVals = 1-wiPairRMAnovaOrigPVals; %flipping the p-values so higher is better
    
    
    
    %% FOR FACTORIAL --> MAIN EFFECT OF SUBREGION/SUBREGION PAIR, MAIN EFFECT OF CONDITION, INTERACTION BETWEEN
    if runFactorial == 1;
        
        %for spectral interaction metrics
        for m = 1:3
            for f = 1:length(allF);
                
                testData = squeeze(metric(m).absValues(f,:,:,:)); %rats x regPair x condn
                [me, int] = fact_rm_anova(testData);
                
                ffAnovaOrigPVals(f,m,1) = me.A.p; %#ok -- main effect of condn
                ffAnovaOrigPVals(f,m,2) = me.B.p; %#ok -- %main effect of region pair
                ffAnovaOrigPVals(f,m,3) = int.p; %#ok -- %regPair x condn intxn
            end
        end
        
        ffAnovaOrigPVals = 1 - ffAnovaOrigPVals; %flip p values so higher is better
        
    end%runFactorial
    
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %       LOOK FOR STATISTICALLY SIGNIFICANT CLUSTERS         %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    %% FOR W/I SUBREGION/SUBREGION PAIRING, ONE-WAY RM ANOVA EFFECT OF CONDITION
    for m = 1:3;
        for p = 1:numPairs;
            ptsAbThresh = zeros(size(wiPairRMAnovaOrigPVals,1),1);
            ptsAbThresh(wiPairRMAnovaOrigPVals(:,p,m) > initClustAlpha) = 1;
            for fRan = 1:2;
                metric(m).regPair(p).fRange(fRan).clustSums = [];
                tmpFRange = [fpass_opts(fRan,1) fpass_opts(fRan,2)];
                fRanInds = find(allF>=tmpFRange(1) & allF<=tmpFRange(2));
                tmpPVals = wiPairRMAnovaOrigPVals(fRanInds,p,m);
                tmpPtsAbThresh = ptsAbThresh(fRanInds);
                fRange(fRan).sigPts = zeros(size(fRanInds)); %#ok
                
                clusts = bwconncomp(tmpPtsAbThresh, 4);%find clusters of points above threshold -- FYI: 2nd input doesn't matter; have to check length below
                for j = 1:length(clusts.PixelIdxList)%for each cluster
                    tmpInds = clusts.PixelIdxList{j};%get the indices
                    if length(tmpInds) >= minClustLen(fRan)%if the cluster is long enough
                        clustSum = sum(tmpPVals(tmpInds)); %add up all the p values within it
                        metric(m).regPair(p).fRange(fRan).clustSums = [metric(m).regPair(p).fRange(fRan).clustSums clustSum];
                        if clustSum > condnStatThresh(fRan,m,p); %and if it's greater than zero or the other clusters within this fRange/metric/shuffle
                            fRange(fRan).sigPts(tmpInds) = 1;
                        end
                    end
                end
            end%fRange
            metric(m).sigPts(:,p) = [fRange(1).sigPts fRange(2).sigPts];
        end%regPair
    end%metric
    
    
    %% FOR REGION X CONDITION FACTORIAL ANALYSES
    if runFactorial == 1;
        
        for m = 1:3;
            for ef = 1:3;
                ptsAbThresh = zeros(size(ffAnovaOrigPVals(:,m,ef),1));
                ptsAbThresh(ffAnovaOrigPVals(:,m,ef) > initClustAlpha) = 1;
                
                for fRan = 1:2;
                    metric(m).fRange(fRan).ffAnovaClustSums = [];
                    tmpFRange = [fpass_opts(fRan,1) fpass_opts(fRan,2)];
                    fRanInds = find(allF>=tmpFRange(1) & allF<=tmpFRange(2));
                    tmpPVals = ffAnovaOrigPVals(fRanInds,m,ef);
                    tmpPtsAbThresh = ptsAbThresh(fRanInds);
                    fRange(fRan).sigPts = zeros(size(fRanInds));
                    
                    clusts = bwconncomp(tmpPtsAbThresh, 4);%find clusters of points above threshold -- FYI: 2nd input doesn't matter; have to check length below
                    for j = 1:length(clusts.PixelIdxList)%for each cluster
                        tmpInds = clusts.PixelIdxList{j};%get the indices
                        if length(tmpInds) >= minClustLen(fRan)%if the cluster is long enough
                            clustSum = sum(tmpPVals(tmpInds)); %add up all the p values within it
                            metric(m).fRange(fRan).ffAnovaClustSums = [metric(m).fRange(fRan).ffAnovaClustSums clustSum];
                            if clustSum > ffAnovaStatThresh(fRan,m,ef); %and if it's greater than zero or the other clusters within this fRange/metric/shuffle
                                fRange(fRan).sigPts(tmpInds) = 1;
                            end
                        end
                    end
                end%fRange
                metric(m).ffAnovaSigPts(:,ef) = [fRange(1).sigPts fRange(2).sigPts];
            end%effect
        end%metric
        
        
    end%runFactorial
    
    
end%runStats







%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                                  %
%                        OPTIONAL PLOTTING OF SPECTRAL MEASURES                                    %
%                                                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% PLOTTING THINGS
if numRegs == 2, regNames = {'CA3', 'CA1'};
else regNames = {'DG', 'CA3', 'CA1', 'SUB'};
end

if numPairs == 1, pairNames = {'CA3/CA1'};
elseif numPairs == 2, pairNames = {'DG/CA3', 'CA3/CA1'};
elseif numPairs == 3, pairNames = {'DG/CA3', 'CA3/CA1', 'CA1/SUB'};
end

if numCondns == 2, condnCols = {'DarkOrange', 'DodgerBlue'};
elseif numCondns == 3, condnCols = {'IndianRed', 'DeepSkyBlue', 'MediumOrchid'};
elseif numCondns == 4, condnCols = {'Red', 'Green', 'Blue', 'Purple'};
end

metNames = {'DTF', 'Spec', 'Coh'};

regCols = {'Red', 'Green', 'Blue', 'Purple'};

if plotResults == 1;
    fprintf('\n\nPlotting results...\n');
    
    if saveFigs
        cd (saveFolder);
        if runStats
            newDirName = ([num2str(desNumOrigIts) '_ssIts__' num2str(numStatShufs) '_statShufs']);
        else
            newDirName = ([num2str(desNumOrigIts) '_ssIts__NO_stats']);
        end
        mkdir(newDirName);
        cd(newDirName);
        metSaveNames = {'dtf', 'spec', 'coh'};
    end
    
    colTrip = rgb('Gold');
    
    %% PLOT INTERACTION METRICS
    for m = 1:3;
        figure ('name', metNames{m});
        % PLOT ABSOLUTE SCORES ON THE TOP ROW
        AVG = metric(m).absAVG; %freqBin x numPairs x condn
        SEM = metric(m).absSEM;
        if runStats == 1;
            sigPts = metric(m).sigPts; %freqBin x numPairs
        end
        for p = 1:numPairs;
            subplot(2,numPairs, p);
            hold on;
            ln = line([allF(1) allF(end)], [0 0]);
            set(ln, 'LineStyle', '--', 'Color', [0 0 0]);
            for c = 1:numCondns;
                condLine(c) = error_fill_plot(allF, AVG(:,p,c), SEM(:,p,c), condnCols{c}); %#ok
            end
            yRange = get(gca, 'YLim');
            yMax(p) = max(yRange);%#ok
            yMin(p) = min(yRange);
            title(pairNames{p});
            if p == 1;
                ylabel ({metNames{m} ; 'Absolute Scores'});
            end
            xlim([allF(1) allF(end)]);
        end
        yBounds = [-max(abs(yMax)) max(abs(yMax))];
        for p = 1:numPairs;
            subplot(2,numPairs, p);
            hold on;
            if ~yMin<0
                ylim([0 yBounds(2)]);
            else
                ylim([min(yMin) max(yMax)]);
            end
            if runStats == 1;
                sigClusts = bwconncomp(sigPts(:,p), 4);
                for i = 1:length(sigClusts.PixelIdxList)
                    sigBoxEdges = [sigClusts.PixelIdxList{i}(1) sigClusts.PixelIdxList{i}(end)];
                    pHand = fill([allF(sigBoxEdges(1)) allF(sigBoxEdges(2)) allF(sigBoxEdges(2)) allF(sigBoxEdges(1))], [0 0 yBounds(2) yBounds(2)], colTrip);
                    set(pHand, 'edgecolor', 'none');
                    alpha(.3);
                end
            end
        end %numPairs
        
        leg = legend(condLine, condnNames);
        set(leg, 'Box', 'Off');
        
        
        
        % ON THE BOTTOM, PLOT DIFFERENCE FROM AVERAGE OR DIFFERENCE IF NUMCONDNS = 2
        if numCondns > 2
            AVG = metric(m).AVG; %freqBin x numPairs x condn
            SEM = metric(m).SEM;
        else
            difByRat = metric(m).absValues(:,:,:,1) - metric(m).absValues(:,:,:,2);
            AVG = squeeze(mean(difByRat,2));
            SEM = squeeze(semfunct(difByRat,2));
        end
        if runStats == 1;
            sigPts = metric(m).sigPts; %freqBin x numPairs
        end
        for p = 1:numPairs;
            subplot(2,numPairs, numPairs+p);
            hold on;
            ln = line([allF(1) allF(end)], [0 0]);
            set(ln, 'LineStyle', '--', 'Color', [0 0 0]);
            if numCondns > 2
                for c = 1:numCondns;
                    condLine(c) = error_fill_plot(allF, AVG(:,p,c), SEM(:,p,c), condnCols{c});
                end
            else
                error_fill_plot(allF, AVG(:,p), SEM(:,p), 'Black');
            end
            
            yRange = get(gca, 'YLim');
            yMax(p) = max(yRange);
            if p == 1;
                if numCondns > 2
                    ylabel ({metNames{m} ; 'Dif From Avg x Condns'});
                else
                    ylabel ({metNames{m}; [condnNames{1} ' - ' condnNames{2}]});
                end
            end
            xlabel ('Frequency (Hz)');
        end
        yBounds = [-max(abs(yMax)) max(abs(yMax))];
        for p = 1:numPairs;
            subplot(2,numPairs, numPairs + p);
            hold on;
            ylim(yBounds);
            if runStats == 1;
                sigClusts = bwconncomp(sigPts(:,p), 4);
                for i = 1:length(sigClusts.PixelIdxList)
                    sigBoxEdges = [sigClusts.PixelIdxList{i}(1) sigClusts.PixelIdxList{i}(end)];
                    pHand = fill([allF(sigBoxEdges(1)) allF(sigBoxEdges(2)) allF(sigBoxEdges(2)) allF(sigBoxEdges(1))], [yBounds(1) yBounds(1) yBounds(2) yBounds(2)], colTrip);
                    set(pHand, 'edgecolor', 'none');
                    alpha(.3);
                end
            end
            xlim([allF(1) allF(end)]);
        end %numPairs
        if saveFigs
            savefig(metSaveNames{m});
        end
    end %metric
    
    
end%plotting spec measures




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                                  %
%           OPTIONAL PLOTTING OF CLUSTER MAX HISTOGRAMS AND P VALUES FOR ORIGINAL DATA             %
%                                                                                                  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if runStats == 1 && plotStats == 1;
    
    if saveFigs
        cd (saveFolder);
        if runStats
            newDirName = ([num2str(desNumOrigIts) '_ssIts__' num2str(numStatShufs) '_statShufs']);
        else
            newDirName = ([num2str(desNumOrigIts) '_ssIts__NO_stats']);
        end
        mkdir(newDirName);
        cd(newDirName);
%         metSaveNames = {'coh', 'phiCoh', 'crossSpec', 'power'};
        metSaveNames = {'dtf', 'spec', 'coh'};
    end
    
    for m = 1:3;
        figure('name', ['Statistical Details for ' metNames{m}]);
        hold on;
        for p = 1:numPairs;
            for fRan = 1:2;
                subplot(3, numPairs, (fRan-1)*numPairs+p);
                hold on;
                histogram(condnClustMaxs(fRan,m,:,p));
                yRange = get(gca, 'YLim');
                threshLine = line([condnStatThresh(fRan,m,p) condnStatThresh(fRan,m,p)], [yRange(1) yRange(2)]);
                set(threshLine, 'Color', [0 0 0], 'LineStyle', '--');
                tt = text(condnStatThresh(fRan,m,p), mean(yRange), 'Stat Thresh');
                set(tt, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom', 'Rotation', 90);
                
                for i = 1:length(metric(m).regPair(p).fRange(fRan).clustSums);
                    clustX = metric(m).regPair(p).fRange(fRan).clustSums(i);
                    clustLine = line([clustX clustX], [yRange(1) yRange(2)]);
                    set(clustLine, 'Color', [1 0 0]);
                    tt = text(clustX, mean(yRange), 'Act Data Clust Sum');
                    set(tt, 'HorizontalAlignment', 'Center', 'VerticalAlignment', 'Bottom', 'Rotation', 90);
                end
                if p == 1;
                    ylabel ({['Freq Range ' num2str(fRan) ' (' num2str(fpass_opts(fRan,1)) '-' num2str(fpass_opts(fRan,2)) ' Hz)']; 'Counts'});
                end
                if fRan == 1;
                    title(pairNames{p});
                end
                xlabel('Cluster Sums');
            end
        end
        
        for p = 1:3
            subplot(3,numPairs,2*numPairs+p);
            hold on;
            plot(allF, wiPairRMAnovaOrigPVals(:,p,m));
            sigPts = metric(m).sigPts(:,p);
            plot(allF(sigPts==1), wiPairRMAnovaOrigPVals(sigPts==1,p,m), 'k*')
            ln = line([allF(1) allF(end)], [initClustAlpha initClustAlpha]);
            set(ln, 'Color', [0 0 0], 'LineStyle', '--');
            if p == 1;
                ylabel ('P Values By Freq');
            end
            xlabel('Frequency (Hz)');
            xlim([allF(1) allF(end)])
            ylim([0 1]);
        end
        if saveFigs
            savefig([metSaveNames{m} '_stats']);
        end
    end
    
    
    %% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %          PLOT FACTORIAL ANOVA RESULTS             %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if runFactorial == 1;
        metNames{4} = 'Power';
        
        for m = 1:3;
            
            fxNames = {'Main Effect of Condition', 'Main Effect of Region Pair', 'Region Pair x Condition Intxn'};
            
            
            figure('name', ['Factorial ANOVA Results for ' metNames{m}]);
            
            %% PLOT P VALUES AND SIGNIFICANCE MARKERS
            for ef = 1:3;
                subplot(2,3,ef)
                hold on;
                plot(allF, ffAnovaOrigPVals(:,m,ef));
                sigPts = metric(m).ffAnovaSigPts(:,ef);
                plot(allF(sigPts==1), ffAnovaOrigPVals(sigPts==1,m,ef), 'k*')
                ln = line([allF(1) allF(end)], [initClustAlpha initClustAlpha]);
                set(ln, 'Color', [0 0 0], 'LineStyle', '--');
                if ef == 1;
                    ylabel ('P Values');
                end
                xlabel('Frequency (Hz)');
                xlim([allF(1) allF(end)])
                ylim([0 1]);
                title(fxNames{ef});
            end
            
            
            
            %% PLOT AVERAGE ACROSS SUBREGION/SUBREGION PAIRINGS FOR EACH CONDITION
            subplot(2,3,4);
            hold on;
            
            ln = line([allF(1) allF(end)], [0 0]);
            set(ln, 'LineStyle', '--', 'Color', [0 0 0]);
            
            regOrPair = 'Region Pairing';
            title([metNames{m} ' Avg x ' regOrPair 's For Each Condn']);
            
            tmpData = metric(m).absValues(:,:,:,:); %OP = freq x rat x regPair x condn
            
            avgXRegs = mean(tmpData,3);
            
            if numCondns < 3
                difXRat = avgXRegs(:,:,:,1) - avgXRegs(:,:,:,2);
                AVG = mean(difXRat,2);
                SEM = semfunct(difXRat,2);
                error_fill_plot(allF, AVG, SEM, 'Black');
                ylabel ({[metNames{m} ' Difference']; [condnNames{1} ' - ' condnNames{2}]});
            else
                tmpAvgXCondns = mean(avgXRegs,4);
                for c = 1:numCondns
                    difXRat(:,:,c) = avgXRegs(:,:,:,c) - tmpAvgXCondns;
                end
                AVG = squeeze(mean(difXRat,2));
                SEM = squeeze(semfunct(difXRat,2));
                
                pairLines = [];
                for c = 1:numCondns;
                    pairLines(c) = error_fill_plot(allF, AVG(:,c), SEM(:,c), condnCols{c});%#ok
                end
                leg = legend(pairLines, condnNames);
                set(leg, 'Box', 'Off');
                ylabel({metNames{m}; 'Dif From Avg x Condns'});
            end
            xlim([allF(1) allF(end)])
            yBnds = get(gca, 'YLim');
            ylim([-max(abs(yBnds)) max(abs(yBnds))]);
            
            
            
            
            %% PLOT AVERAGE ACROSS CONDITIONS FOR EAHC SUBREGION/SUBREGION PAIRING
            subplot(2,3,5);
            hold on;
            
            ln = line([allF(1) allF(end)], [0 0]);
            set(ln, 'LineStyle', '--', 'Color', [0 0 0]);
            
            title([metNames{m} ' Avg x Condns For Each ' regOrPair]);
            tmpData = metric(m).absValues(:,:,:,:); %OP = freq x rat x regPair x condn
            compareMe = numPairs;
            
            
            avgXCondns = mean(tmpData,4);
            
            if compareMe < 3
                difXRat = avgXCondns(:,:,1) - avgXCondns(:,:,2);
                AVG = squeeze(mean(avgXCondns,2));
                SEM = squeeze(semfunct(avgXCondns,2));
                error_fill_plot(allF, AVG, SEM, 'Black');
                ylabel ({[metNames{m} ' Difference']; [pairNames{1} ' - ' pairNames{2}]});
                
            else
                tmpAvgXRegs = mean(avgXCondns,3);
                for reg = 1:compareMe
                    difXRat(:,:,reg) = avgXCondns(:,:,reg) - tmpAvgXRegs;
                end
                AVG = squeeze(mean(difXRat,2));
                SEM = squeeze(semfunct(difXRat,2));
                pairLines = [];
                for reg = 1:compareMe;
                    pairLines(reg) = error_fill_plot(allF, AVG(:,reg), SEM(:,reg), regCols{reg});%#ok
                end
                ylabel({metNames{m}; ['Dif From Avg x ' regOrPair 's']});
            end
            
            leg = legend(pairLines, pairNames);
            
            set(leg, 'Box', 'Off');
            xlim([allF(1) allF(end)])
            yBnds = get(gca, 'YLim');
            ylim([-max(abs(yBnds)) max(abs(yBnds))]);
            
            
            if saveFigs
                saveName = [metNames{m} '_ffAnova_stats'];
                cd(saveFolder)
                cd(newDirName);
                savefig(saveName);
            end
        end %metric
        
        if saveFigs
            cd(curDir)
        end
        
    end %runFactorial
    
    
end %plotStats

end%FUNCTION


