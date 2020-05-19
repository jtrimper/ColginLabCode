function corrProj_9_2_xCorrSumsForNonRemXSession(region)
% function corrProj_9_2_xCorrSumsForNonRemXSession(region)
%
% PURPOSE:
%  Function to plot the sum across the center +/- 5 or +/- 50 ms of each nREM xCorr
%  It's averaged across bouts for each cell pair.
%  Separate figures are made/saved for each rat/session, then there's a grand figure comparing CA1 to MEC
%  at each bin size.
%  Here, the center sums are drawn from the pre-calculated and appended cross-correlations attached to the
%  region structure.
%
% JBT 12/2017
% Colgin Lab
%
%   Update: 01/2019 -- Changed to exclude cell pairs flagged as bad in any state, not just NREM. 


fprintf('Finding bad pairs by running corrProj_6...\n'); 
[~,badPairs] = corrProj_6_reduceMetricsForEachCellPair(region);
fprintf('\n\n\n'); 

plotUnNorm = 0; %set to 1 to plot the un-normalized cross corr
calcXWholeSleepBout = 0; %set to 1 to not just consider nREM, but the entire sleep bouts (an attempt to get some more spikes)
xCorrLag = 0.100; %s - only matters if calcXWholeSleepBout == 1

% plotSaveDir = 'I:\STORAGE\LAB_STUFF\COLGIN_LAB\PROJECTS\Grid_Cell_Correlations_TrettelProj\MANUSCRIPT\NATURE_NEURO_SUBMISSION\REVISIONS\NEW_RESULTS\midSumsXTime\bySession_coeffNormed';
% plotSaveDir = 'C:\Users\John Trimper\Desktop\LAB_STUFF\PROJECTS\Grid_Cell_Correlations_TrettelProj\MANUSCRIPT\NATURE_NEURO_SUBMISSION\REVISIONS\RND_1\NEW_RESULTS\midSumsXTime\tmp_rerun_on_012818'; 

if calcXWholeSleepBout ~= 1
    xCorrLag = 5.000;
end

regNames = {'MEC', 'CA1'};
sumRanges = {'+/- 5 ms', '+/- 50 ms'};
regCols = {'Black', 'DarkGray'};

sKey = 3; %nREM
t = 3; %Overnight
d = 1; %Day 1 only

maxNumOvNtHrs = 14; %longest duration of an overnight session
timeBinDuration = 30; %minutes
timeBinHrs = timeBinDuration/60; %hrs
nightTimeVctr = 0: timeBinHrs : maxNumOvNtHrs;

curDir = pwd;
dataDir = 'C:\Users\John Trimper\Desktop\LAB_STUFF\PROJECTS\Grid_Cell_Correlations_TrettelProj\CORR_PROJECT_RERUN\DATASET';
cd(dataDir);

xRegFig = figure('Position', [351 528 1051 420]);
AVG = cell(1,2); 
ERR = cell(1,2); 
for reg = 1:2
    fprintf('%s\n', regNames{reg});
    cd(region(reg).name)
    cpCntr = 1;
    
    for r = 1:length(region(reg).rat)
        fprintf('\tRat %d/%d\n', r, length(region(reg).rat));
        cd(region(reg).rat(r).name)
        
        for s = 1:length(region(reg).rat(r).session)
            
            fprintf('\t\tSession %d/%d\n', s, length(region(reg).rat(r).session));
            
            cd(['Session' num2str(s) '\Day1\Overnight'])
            if isempty(region(reg).rat(r).session(s).state(1).cellPair)
                fprintf('\t\t\tNo cell pairs.\n');
            else
                sleepEpochBnds = [];
                nRemBnds = [];
                for b = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout)
                    %                     for b = 1:20
                    fprintf('\t\t\t\tBout %d/%d\n', b, length(region(reg).rat(r).session(s).day(d).task(t).bout));
                    cd(['Sleep' num2str(b)]);
                    
                    eegFInfo = dir('*.ncs');
                    try
                        eegStruct = read_in_lfp(eegFInfo(1).name);
                        goodRead = 1;
                    catch
                        goodRead = 0;
                    end
                    
                    if goodRead == 1
                        startBout = eegStruct.ts(1);
                        endBout = eegStruct.ts(end);
                        boutTs = startBout:1/2000:endBout;
                        
                        sleepEpochBnds = [sleepEpochBnds; startBout endBout]; %#ok
                        
                        
                        if b == 1
                            firstTs = startBout;
                        elseif b == length(region(reg).rat(r).session(s).day(d).task(t).bout)
                            lastTs = endBout;
                            wholeNightBnds = [firstTs lastTs];
                        end
                        
                        if ~isempty(region(reg).rat(r).session(s).day(d).task(t).bout(b).nRemTimes)
                            nRemBnds = [nRemBnds; region(reg).rat(r).session(s).day(d).task(t).bout(b).nRemTimes];%#ok
                        end
                        
                        
                        if calcXWholeSleepBout == 1
                            fprintf('\t\t\t\t\tCalculating correlations for whole sleep bouts (not just nREM)\n');
                            cpCntr  = 0;
                            
                            numSampsPerCol = 0.002 * 2000; %2 ms bins
                            numCols = floor(length(boutTs)/numSampsPerCol);
                            ttlNumSamps = numSampsPerCol * numCols;
                            
                            numUnits = length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit);
                            for u1 = 1:numUnits
                                if region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u1).type == 1
                                    
                                    u1SpkTms = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u1).spkTms;
                                    u1SpkVctr = zeros(1,length(boutTs));
                                    for st = 1:length(u1SpkTms)
                                        tmpTm = u1SpkTms(st);
                                        spkInd = find(boutTs<=tmpTm,1,'Last');
                                        if ~isempty(spkInd)
                                            u1SpkVctr(spkInd) = 1;
                                        end
                                    end
                                    u1SpkVctr(ttlNumSamps+1:end) = [];
                                    reshSpkMat = reshape(u1SpkVctr,numSampsPerCol,numCols);
                                    u1SpkVctr = sum(reshSpkMat,1);
                                    
                                    for u2 = u1:numUnits
                                        if region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u2).type == 1
                                            
                                            cpCntr  = cpCntr + 1;
                                            
                                            u2SpkTms = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u2).spkTms;
                                            u2SpkVctr = zeros(1,length(boutTs));
                                            for st = 1:length(u2SpkTms)
                                                tmpTm = u2SpkTms(st);
                                                spkInd = find(boutTs<=tmpTm,1,'Last');
                                                if ~isempty(spkInd)
                                                    u2SpkVctr(spkInd) = 1;
                                                end
                                            end
                                            u2SpkVctr(ttlNumSamps+1:end) = [];
                                            reshSpkMat = reshape(u2SpkVctr,numSampsPerCol,numCols);
                                            u2SpkVctr = sum(reshSpkMat,1);
                                            
                                            fprintf('\t\t\t\t\t\tCell Pair %d: Unit %d/%d (%d spks) vs. Unit %d/%d (%d spks)\n', cpCntr, u1, numUnits, sum(u1SpkVctr), u2, numUnits, sum(u2SpkVctr));
                                            
                                            region(reg).rat(r).session(s).state(3).cellPair(cpCntr).stXCorr{b}{1} = xcorr(u1SpkVctr, u2SpkVctr, xCorrLag/0.002);
                                            region(reg).rat(r).session(s).state(3).cellPair(cpCntr).normStXCorr{b}{1} = xcorr(u1SpkVctr, u2SpkVctr, xCorrLag/0.002, 'coeff');
                                            
                                        end %if u2 is grid/pyram
                                    end %unit 2
                                end %if u1 is a grid/pyram
                            end %unit1
                        end %if calculating correlation across the whole sleep bout
                        
                        
                        
                    end
                    cd ..
                end %bout
                
                
                midSums = nan(2, length(region(reg).rat(r).session(s).state(sKey).cellPair),length(region(reg).rat(r).session(s).day(d).task(t).bout));

                for cp = 1:length(region(reg).rat(r).session(s).state(sKey).cellPair)
                    xCorrSum = zeros(1,xCorrLag*2/.002+1);
                    tmpSum = [];
                    for b = 1:size(region(reg).rat(r).session(s).state(sKey).cellPair(cp).midSum,2)
                        
                        if ~isempty(region(reg).rat(r).session(s).state(3).cellPair(cp).stXCorr{b})
                            
                            %sum the normalized xCorr over middle 5 bins
                            tmpInds = median(1:length(xCorrSum))-2:median(1:length(xCorrSum))+2;
                            if plotUnNorm == 1
                                tmpSum(1) = sum(region(reg).rat(r).session(s).state(3).cellPair(cp).stXCorr{b}{1}(tmpInds));
                            else
                                tmpSum(1) = sum(region(reg).rat(r).session(s).state(3).cellPair(cp).normStXCorr{b}{1}(tmpInds));
                            end
                            
                            
                            %sum normalized xCorr over middle 50 bins
                            tmpInds = median(1:length(xCorrSum))-25:median(1:length(xCorrSum))+25;
                            if plotUnNorm == 1
                                tmpSum(2) = sum(region(reg).rat(r).session(s).state(3).cellPair(cp).stXCorr{b}{1}(tmpInds));
                            else
                                tmpSum(2) = sum(region(reg).rat(r).session(s).state(3).cellPair(cp).normStXCorr{b}{1}(tmpInds));
                            end
                            
                            midSums(:,cp,b) = tmpSum;
                            
                            %add up the non-normalized xCorr across bouts
                            xCorrSum = xCorrSum + region(reg).rat(r).session(s).state(3).cellPair(cp).stXCorr{b}{1};
                        end
                    end

                    
                end
                
                wholeNightTsVctr = wholeNightBnds(1):1/2000:wholeNightBnds(2);
                
                sleepBoutMidTimes = zeros(1,size(sleepEpochBnds,1));
                for b = 1:size(sleepEpochBnds,1)
                    tmpBnds = sleepEpochBnds(b,:);
                    sleepBoutStartInd = find(wholeNightTsVctr<=tmpBnds(1), 1, 'Last');
                    sleepBoutStartTime = wholeNightTsVctr(sleepBoutStartInd);
                    sleepBoutEndInd = find(wholeNightTsVctr>=tmpBnds(2), 1, 'First');
                    sleepBoutEndTime = wholeNightTsVctr(sleepBoutEndInd);
                    sleepBoutMidTimes(b) = mean([sleepBoutStartTime sleepBoutEndTime]);
                end
                
                sleepBoutMidTimes = sleepBoutMidTimes - wholeNightTsVctr(1); %get all times time-locked to the start of the first sleep bout
                sleepBoutMidTimes = sleepBoutMidTimes / 60^2;
                
                
                binnedMidSums = cell(1,length(nightTimeVctr)-1);
                for b = 1:length(sleepBoutMidTimes)
                    binInd = find(nightTimeVctr<=sleepBoutMidTimes(b), 1, 'Last');
                    binnedMidSums{binInd} = cat(3,binnedMidSums{binInd},midSums(:,:,b));
                end
                
                goodBins = [];
                binnedMidSumAvgs = nan(2,size(midSums,2),length(binnedMidSums));
                for b = 1:length(binnedMidSums)
                    if ~isempty(binnedMidSums{b})
                        binnedMidSumAvgs(:,:,b) = nanmean(binnedMidSums{b},3);
                        goodBins = [goodBins b]; %#ok
                    end
                end
                
                
                for cp = 1:size(midSums,2)
                    for bw = 1:2
                        region(reg).midSumsAcrossNight(bw,cpCntr,goodBins) = squeeze(binnedMidSumAvgs(bw,cp,goodBins));
                    end
                    cpCntr = cpCntr + 1;
                end
                
            end
            cd ../../..
        end %ses
        
        cd ..
    end %rat

  % Get rid of bad pairs, as flagged by corrProj_6
  region(reg).midSumsAcrossNight(:,badPairs{reg},:) = []; 
    
    % Plot the data
    figure(xRegFig)
    tmpTimeVctr = mean([nightTimeVctr(1:end-1); nightTimeVctr(2:end)]);
    
    AVG{reg} = squeeze(nanmean(region(reg).midSumsAcrossNight,2));
    ERR{reg} = squeeze(nan_semfunct(region(reg).midSumsAcrossNight,2));
    for bw = 1:2
        subplot(1,2,bw)
        hold on;
        xRegHndl(reg) = plot(tmpTimeVctr(1:size(AVG{reg},2)), AVG{reg}(bw,:), 'Color', rgb(regCols{reg}), 'LineWidth', 2);%#ok
        eb = errorbar(tmpTimeVctr(1:size(AVG{reg},2)), AVG{reg}(bw,:), ERR{reg}(bw,:));
        set(eb, 'Color', rgb(regCols{reg}), 'LineStyle', 'none', 'LineWidth', 2);
        if reg == 2
            title(['Summed Over ' sumRanges{bw}]);
            xlabel('Time Since Overnight Start (Hr');
            if bw == 1
                ylabel('Summed Cross Correlation');
            end
            set(gca, 'FontName', 'Arial', 'XTick', 0:.5:maxNumOvNtHrs, 'XGrid', 'On');
            leg = legend(xRegHndl, regNames);
            set(leg, 'Box', 'Off');
            xlim([-.25 3]);
        end
    end
    
    cd ..
end %region

dataMat = []; 
fprintf('\n\nCell Pair Counts: \n');
for reg = 1:2
    fprintf('\t%s: %d\n', regNames{reg}, size(region(reg).midSumsAcrossNight,2));
    regVctr = repmat(reg, size(region(reg).midSumsAcrossNight,2), 1); 

    dataMat = [dataMat; 
        regVctr reshape(permute(region(reg).midSumsAcrossNight(:,:,1:6), [2 3 1]),size(region(reg).midSumsAcrossNight(:,:,1:6),2),numel(region(reg).midSumsAcrossNight(:,:,1:6))/size(region(reg).midSumsAcrossNight(:,:,1:6),2))]; %#ok
end


keyboard

cd('C:\Users\John Trimper\Desktop\LAB_STUFF\PROJECTS\Grid_Cell_Correlations_TrettelProj\MANUSCRIPT\NATURE_NEURO_SUBMISSION\REVISIONS\RND_1\NEW_RESULTS\midSumsXTime'); 
xlswrite('midSumsXTime.xlsx', dataMat)


keyboard

cd (curDir);

end %fnctn