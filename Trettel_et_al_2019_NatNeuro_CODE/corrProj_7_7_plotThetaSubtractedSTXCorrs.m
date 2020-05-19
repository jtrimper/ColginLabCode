function corrProj_7_7_plotThetaSubtractedSTXCorrs(cellRegion, region)
% function corrProj_7_7_plotThetaSubtractedSTXCorrs(cellRegion, region)
%
% PURPOSE:
%   To generate the supplementary figure where theta is taken into account as
%   a possible explanatory factor for the spike time cross correlations.
%   Plotting 10 figures for each region, for the five lowest and five highest
%   relative spatial phase pairs (MEC) and distance pairs (CA1).
%
% INPUT:
%   cellRegion = uber data struct that has been passed through corrProj_6...
%
% OUTPUT:
%   Figgers.
%
% JBT 9/2017
% Colgin Lab
curDir = pwd;
dataDir = 'H:\CORR_PROJECT_RERUN\DATASET'; %PC
% dataDir = 'D:\CORR_PROJECT_RERUN\DATASET'; %LAPTOP, EXTERNAL
cd(dataDir);

saveFigs = 1; %set to 1 to save figs
saveDir = 'H:\CORR_PROJECT_RERUN\RESULTS\Theta_Subtracted_SpkTm_CrossCorrs';
plotAbbrevs = {'LowSD', 'HighSD'};

stateNames = {'RUN', 'REM'};
taskNames = {'LinearTrack', 'OpenField', 'Overnight'};
phiMagGrpNames = {'Low Relative Spatial Distance', 'High Relative Spatial Distance'};
shufColMat = define_cust_color_map('LightGray', 'SlateGray', 10);

binDur = 0.002; %seconds - for binning spikes
runTNum = [2 1]; %for MEC, task 2 (Open Field); for CA1, task 1 (Linear Track)
xCorrLag = 0.500; %seconds - lag for cross correlation

numPhaseBinEdges = 72; %5* bins [72 bin edges)
phiBinEdges = linspace(-pi, pi, numPhaseBinEdges); %phase bin edges

numShufs = 200; %number of shuffles to compare to
numPairs = 10; %# of pairs to look at
%  Data will be plotted for numPairs cell pairs with lowest relative spatial distance and
%  numPairs cell pairs with highest relative spatial distance

for reg = 2 %CA1 Only
% for reg = 1 %MEC Only
    fprintf('%s\n', region(reg).name);
    cd(region(reg).name);
    
    % FIRST GO THROUGH AND IDENTIFY THE PAIRS WITH THE LOWEST HIGHEST RELATIVE SPATIAL PHASES
    allSpatPhiMags = [];
    for cp = 1:length(cellRegion(reg).cellPair)
        if reg == 1 %MEC
            allSpatPhiMags = [allSpatPhiMags cellRegion(reg).cellPair(cp).state(1).relSpatPhiMag]; %#ok
        else %CA1
            allSpatPhiMags = [allSpatPhiMags cellRegion(reg).cellPair(cp).state(1).relSpatDist]; %#ok
        end
    end
    
    [~, srtInds] = sort(allSpatPhiMags);
    
    magInds(:,1) = srtInds(1:numPairs); %lowest spatial mag
    magInds(:,2) = srtInds(end-(numPairs-1):end); %highest spatial mag
    
    
        for pm = 1:2 %phase mag groups (low/high)
%     for pm = 2 %phase mag groups (low/high)
        fprintf('\tWorking on %s Cell Pairs\n', phiMagGrpNames{pm})
        %         for ci = 1:numPairs %cell pair index
        for ci = 1:numPairs %cell pair index
            cp = magInds(ci,pm);
            fprintf('\t\tCell Pair %d (%d/%d)\n', cp, ci, numPairs);
            
            %make a figure for this cell pair
            stdFig = figure('name', ['STD CI: ' phiMagGrpNames{pm} ' -- Cell Pair #' num2str(cp) ' (' num2str(ci) '/5)'], 'Position', [ 220    58   980   614]);
            semFig = figure('name', ['SEM CI: ' phiMagGrpNames{pm} ' -- Cell Pair #' num2str(cp) ' (' num2str(ci) '/5)'], 'Position', [ 220    58   980   614]);
            bsFig = figure('name', ['Bootstrap CI: ' phiMagGrpNames{pm} ' -- Cell Pair #' num2str(cp) ' (' num2str(ci) '/5)'], 'Position', [ 220    58   980   614]);
            
            % get all the info for where this cell pair came from
            cpInfo = cellRegion(reg).cellPair(cp).info;
            r = cpInfo(1);
            s = cpInfo(2);
            %             wInSesCp = cpInfo(3);
            u1ID = cpInfo(4:5);
            u2ID = cpInfo(6:7);
            
            % go into the rat/ses/day directory
            cd(region(reg).rat(r).name)
            cd(['Session' num2str(s)]);
            cd('Day1')
            
            for ss = 1:2 %RUN, then REM
                %                 for ss = 2 %RUN, then REM
                if ss == 1
                    tNum = runTNum(reg); %for MEC, task 2 (Open Field); for CA1, task 1 (Linear Track)
                else
                    tNum = 3; %OverNight
                end
                fprintf('\t\t\t%s\n', taskNames{tNum});
                
                cd(taskNames{tNum});
                
                %get bout directory title
                if ss == 1
                    boutTtl = 'Begin';
                else
                    boutTtl = 'Sleep';
                end
                
                %initiate matrices for shuffle and original cross correlations across bouts/shuffles
                origCrossCorr = zeros((xCorrLag/binDur)*2+1, length(region(reg).rat(r).session(s).day(1).task(tNum).bout));
                shuffleCrossCorr = zeros((xCorrLag/binDur)*2+1, length(region(reg).rat(r).session(s).day(1).task(tNum).bout), numShufs);
                
                for b = 1:length(region(reg).rat(r).session(s).day(1).task(tNum).bout)
                    %                     for b = 60
                    fprintf('\t\t\t\tBout %d\n', b);
                    if ss == 1
                        epochTimes = region(reg).rat(r).session(s).day(1).task(tNum).bout(b).runTimes;
                    else
                        epochTimes = region(reg).rat(r).session(s).day(1).task(tNum).bout(b).remTimes;
                    end
                    cd([boutTtl num2str(b)]);
                    
                    if isempty(epochTimes)
                        fprintf('\t\t\t\t\tNo state epochs detected for this bout or empty directory.\n');
                    else
                        
                        fprintf('\t\t\t\t\t%0.04g sec of state detected\n', sum(diff(epochTimes,[],2)));
                        
                        %load the EEG if there is one in this directory
                        eegFileInfo = dir('*.ncs');
                        if isempty(eegFileInfo)
                            fprintf('No EEG in directory for this bout.\n');
                        else
                            eegStruct = read_in_eeg(eegFileInfo(1).name);
                            eegTs = eegStruct.ts; %eeg time-stamps
                            
                            
                            %get the theta phase for every EEG time-series
                            %  first check to see if there's already a saved theta filtered vector
                            
                            %                             thetaFileInfo = dir('thetaPhaseVctr.mat');
                            %                             if ~isempty(thetaFileInfo)
                            %                                 fprintf('\t\t\t\t\t\tLoading saved theta phase vector.\n');
                            %                                 load(thetaFileInfo(1).name);
                            %                             else %if not
                            fprintf('\t\t\t\t\t\tNo pre-saved theta phase vector.\n');
                            
                            fprintf('\t\t\t\t\t\t\tFiltering.\n');
                            %filter in narrow theta range
                            thetaFiltEegVctr = filter_eeg_jt(eegStruct, 6, 10);
                            eegStruct.narrowThetaEeg = thetaFiltEegVctr;
                            
                            %filter in broader theta range
                            thetaFiltEegVctr = filter_eeg_jt(eegStruct, 3, 20);
                            eegStruct.broadThetaEeg = thetaFiltEegVctr;
                            
                            %get instaneous theta phase interpolated from theta quartile phase times
                            fprintf('\t\t\t\t\t\t\tExtracting phase.\n');
                            thetaPhiVctr = get_asym_theta_phi_vector(eegStruct);
                            % FYI: range is -pi to pi, with pi/-pi = trough and 0 = peak
                            
                            fprintf('\t\t\t\t\t\t\tSaving theta phase vector.\n');
                            save('thetaPhaseVctr.mat', 'thetaPhiVctr');
                            %                             end
                            
                            
                            %find the units
                            unitInds = nan(1,2);
                            for u = 1:length(region(reg).rat(r).session(s).day(1).task(tNum).bout(b).unit)
                                tmpID = region(reg).rat(r).session(s).day(1).task(tNum).bout(b).unit(u).ID;
                                
                                if tmpID(1) == u1ID(1) && tmpID(2) == u1ID(2)
                                    unitInds(1) = u;
                                elseif tmpID(1) == u2ID(1) && tmpID(2) == u2ID(2)
                                    unitInds(2) = u;
                                end
                                
                            end
                            
                            
                            %if you couldn't find the cell in this bout, skip this cell pair;
                            %   it was there for RUN, but probably not for at least one of the overnight bouts
                            if sum(isnan(unitInds)) == 0
                                
                                %create a binary vector for matching spike times to EEG phase
                                spkBinary = zeros(2, length(eegTs)); %cuz 2 units
                                
                                %find all the spikes that occurred during this state
                                stateSpks = cell(1,2);
                                spkPhis = cell(1,2); %for the spike phases
                                for u = 1:2
                                    fprintf('\t\t\t\t\t\tUnit %d/2: ', u);
                                    
                                    allSpkTms = region(reg).rat(r).session(s).day(1).task(tNum).bout(b).unit(u).spkTms;
                                    for e = 1:size(epochTimes,1)
                                        startEp = epochTimes(e,1);
                                        endEp = epochTimes(e,2);
                                        
                                        spkInds = find(allSpkTms>=startEp & allSpkTms<=endEp);
                                        if ~isempty(spkInds)
                                            stateSpks{u} = [stateSpks{u}; allSpkTms(spkInds)];
                                            for st = 1:length(spkInds)
                                                epochSpkInd = spkInds(st);
                                                spkEegInd = find(eegTs<=allSpkTms(epochSpkInd), 1, 'Last');
                                                if spkEegInd == 0
                                                    spkEegInd = 1;
                                                end
                                                if spkEegInd > length(eegTs)
                                                    spkEegInd = length(eegTs);
                                                end
                                                spkBinary(u, spkEegInd) = 1;
                                                
                                                spkPhis{u} = [spkPhis{u} thetaPhiVctr(spkEegInd)];
                                            end
                                        end
                                        
                                    end %each epoch
                                    fprintf('%d spikes\n', length(spkPhis{u}))
                                    
                                end %each unit in the pair
                                
                                
                                %bin the binary spk time vectors
                                binLen = binDur / 0.0005; %0.0005 because EEG has 2000 Hz samp rate
                                numRows = floor(length(spkBinary)/binLen);
                                spkBinary = spkBinary(:,1:numRows*binLen);%cut off extra segments before reshaping
                                binnedSpkCnts = zeros(2,numRows); %initiate binary matrix for binned spike counts
                                for u = 1:2
                                    reshSpkBinary = reshape(spkBinary(u,:), binLen, numRows);
                                    binnedSpkCnts(u,:) = sum(reshSpkBinary,1);
                                end
                                
                                %calculate original normalized cross correlation coefficient
                                origCrossCorr(:,b) = xcorr(binnedSpkCnts(1,:), binnedSpkCnts(2,:), xCorrLag/binDur, 'coeff');
                                
                                
                                %shuffle the spike phases
                                fprintf('\t\t\t\t\t\tCalculating shuffle cross-corrs.\n');
                                for sh = 1:numShufs
                                    fprintf('\t\t\t\t\t\t\tShuf #%d\n', sh)
                                    shufSpkBinary = zeros(size(spkBinary));
                                    for u = 1:2
                                        for st = 1:length(spkPhis{u})
                                            tmpPhi = spkPhis{u}(st); %spike phase
                                            tmpTm = stateSpks{u}(st); %spike time
                                            phiBin = find(phiBinEdges<=tmpPhi,1, 'Last');
                                            
                                            %find EEG bounds for +/- 500 ms
                                            startInd = find(eegTs<=tmpTm-0.5, 1, 'Last');
                                            if isempty(startInd)
                                                startInd = 1;
                                            end
                                            endInd = find(eegTs>=tmpTm+0.5, 1, 'First');
                                            if isempty(endInd)
                                                endInd = length(eegTs);
                                            end
                                            
                                            %find a new spike index within that window that is within +/- 5 of the phase of the original
                                            windowPhis = thetaPhiVctr(startInd:endInd);
                                            
                                            phiMatchInds = find(windowPhis>=phiBinEdges(phiBin) & windowPhis<phiBinEdges(phiBin+1));
                                            
                                            rndmizer = rand(1,length(phiMatchInds));
                                            [~,rndmInds] = sort(rndmizer);
                                            newSpkInd = phiMatchInds(rndmInds(1))+startInd-1;
                                            
                                            shufSpkBinary(u,newSpkInd) = 1;
                                        end
                                    end
                                    
                                    %reshape the spike binary and bin it by the proper duration
                                    shufSpkBinary = shufSpkBinary(:,1:numRows*binLen);%cut off extra segments before reshaping
                                    shufBinnedSpkCnts = zeros(2,numRows); %initiate binary matrix for binned spike counts
                                    for u = 1:2
                                        reshSpkBinary = reshape(shufSpkBinary(u,:), binLen, numRows);
                                        shufBinnedSpkCnts(u,:) = sum(reshSpkBinary,1);
                                    end
                                    
                                    %calculate shuffle normalized cross correlation coefficient
                                    shuffleCrossCorr(:,b,sh) = xcorr(shufBinnedSpkCnts(1,:), shufBinnedSpkCnts(2,:), xCorrLag/binDur, 'coeff');
                                    
                                end %shuffle
                                
                            else
                                fprintf('\t\t\t\t\tOne or both of the units were not there for this bout.\n');
                            end %if both units were found in this bout
                            
                        end %there's no eeg file
                    end %if there were RUN/REM epochs for this bout
                    cd ../ %out of bout dir
                end %bout
                
                
                %Average the original cross-correlation across bouts
                tmpOrigXCorr = [];
                for b = 1:size(origCrossCorr,2)
                    if sum(origCrossCorr(:,b)>0)
                        tmpOrigXCorr = [tmpOrigXCorr origCrossCorr(:,b)]; %#ok
                    end
                end
                origCrossCorr = mean(tmpOrigXCorr,2);
                
                
                %Average the shuffled cross-correlations across bouts
                newShuffleCrossCorr = zeros((xCorrLag/binDur)*2+1,numShufs);
                for sh = 1:numShufs
                    tmpShufXCorr = [];
                    for b = 1:size(shuffleCrossCorr,2)
                        if sum(shuffleCrossCorr(:,b,sh)>0) %a lot of bouts don't have REM epochs so the cross corr will still be all zeros
                            tmpShufXCorr = [tmpShufXCorr shuffleCrossCorr(:,b,sh)]; %#ok
                        end
                    end
                    newShuffleCrossCorr(:,sh) = mean(tmpShufXCorr,2);
                end
                shuffleCrossCorr = newShuffleCrossCorr;
                shuffleCrossCorr_AVG = mean(shuffleCrossCorr,2);
                shuffleCrossCorr_STD = std(shuffleCrossCorr,0,2);
                shuffleCrossCorr_SEM = semfunct(shuffleCrossCorr,2);
                
                
                
                
                %get x values for plotting
                xVals = ([1:length(origCrossCorr)]*binDur) - (max((length(origCrossCorr)+1)*binDur)/2);
                xInds = find(xVals >= -0.250 & xVals <= 0.25);
                xVals = xVals(xInds);
                xVals = xVals * 1000; %convert to seconds
                
                %% PLOT WITH THE CONFIDENCE INTERVAL BASED ON STANDARD DEVIATIONS
                figure(stdFig);
                
                % Calculate the confidence interval (95% confidence interval based on STD = mean +/- 1.96 * STD)
                shuffleCrossCorr_CI = [shuffleCrossCorr_AVG - (1.96*shuffleCrossCorr_STD) ... %lower bound of CI
                    shuffleCrossCorr_AVG + (1.96*shuffleCrossCorr_STD)]; %upper bound of CI
                
                %  Plot the average with 10 example shuffles
                subplot(3,2,ss);
                hold on;
                tmpNumShufs = 10;
                if size(shuffleCrossCorr,2)<tmpNumShufs
                    tmpNumShufs = size(shuffleCrossCorr,2);
                end
                for sh = 1:tmpNumShufs
                    plot(xVals, shuffleCrossCorr(xInds,sh), 'Color', shufColMat(sh,:));
                end
                plot(xVals, origCrossCorr(xInds), 'k', 'LineWidth', 1.5);
                xlim([xVals(1) xVals(end)]);
                zero_line;
                y_zero_line;
                if ss == 1
                    ylabel({'Cross-Correlation'; 'Coefficient'});
                end
                title(stateNames{ss});
                set(gca, 'FontName', 'Arial');
                
                
                % Plot the average with the CI and shuffle AVG
                subplot(3,2,ss+2);
                hold on;
                plot(xVals, shuffleCrossCorr_AVG(xInds), 'Color', shufColMat(5,:), 'LineWidth', 1.5);
                for lim = 1:2
                    plot(xVals, shuffleCrossCorr_CI(xInds,lim), 'Color', shufColMat(5,:));
                end
                plot(xVals, origCrossCorr(xInds), 'k', 'LineWidth', 1.5);
                xlim([xVals(1) xVals(end)]);
                zero_line;
                y_zero_line;
                if ss == 1
                    ylabel({'Cross-Correlation'; 'Coefficient'});
                end
                set(gca, 'FontName', 'Arial');
                
                
                % Remove the theta component
                %  Find orig cross corr vals within the shuffled CI and set them to the average shuffle cross corr
                thetaExpInds = find(origCrossCorr>shuffleCrossCorr_CI(:,1) & origCrossCorr<shuffleCrossCorr_CI(:,2)); %find average values explainable by theta
                thetaCrossCorr = origCrossCorr;
                thetaCrossCorr(thetaExpInds) = shuffleCrossCorr_AVG(thetaExpInds);
                %  Find orig cross corr vals below shuffled CI and add to them the distance between the nearest shuffle CI edge and the shuffle AVG
                belowCIInds = find(origCrossCorr <= shuffleCrossCorr_CI(:,1));
                CItoAVGdist = shuffleCrossCorr_AVG - shuffleCrossCorr_CI(:,1);
                thetaCrossCorr(belowCIInds) = origCrossCorr(belowCIInds) + CItoAVGdist(belowCIInds);
                %  Find orig cross corr vals above shuffled CI and subtract from them the distance between the nearest shuffle CI edge and the shuffle AVG
                aboveCIInds = find(origCrossCorr >= shuffleCrossCorr_CI(:,2));
                CItoAVGdist = shuffleCrossCorr_CI(:,1) - shuffleCrossCorr_AVG;
                thetaCrossCorr(aboveCIInds) = origCrossCorr(aboveCIInds) - CItoAVGdist(aboveCIInds);
                thetaCrossCorr = thetaCrossCorr - shuffleCrossCorr_AVG;
                
                % Plot the cross corr with theta contribution removed
                subplot(3,2,ss+4);
                plot(xVals, thetaCrossCorr(xInds), 'k', 'LineWidth', 1.5');
                zero_line;
                y_zero_line;
                xlim([xVals(1) xVals(end)]);
                if ss == 1
                    ylabel({'Cross-Correlation'; 'Coefficient'});
                end
                set(gca, 'FontName', 'Arial');
                
                
                if saveFigs == 1 && ss == 2
                    tmpCD = pwd;
                    cd(saveDir);
                    figTtl = [region(reg).name '_' plotAbbrevs{pm} '_CP' num2str(ci) '_STD_Fig'];
                    savefig(stdFig, figTtl);
                    print(figTtl, '-dpng'); %save as png
                    cd(tmpCD);
                end
                
                
                
                
                
                
                %% PLOT WITH THE CONFIDENCE INTERVAL BASED ON SEM
                figure(semFig);
                
                % Calculate confidence interval based on SEM (98% confidence interval)
                shuffleCrossCorr_CI = [shuffleCrossCorr_AVG - (2.33*shuffleCrossCorr_SEM) ... %lower bound of 98% CI
                    shuffleCrossCorr_AVG + (2.33*shuffleCrossCorr_SEM)]; %upper bound of 98% CI
                
                %  Plot the average with 10 example shuffles
                subplot(3,2,ss);
                hold on;
                for sh = 1:tmpNumShufs
                    plot(xVals, shuffleCrossCorr(xInds,sh), 'Color', shufColMat(sh,:));
                end
                plot(xVals, origCrossCorr(xInds), 'k', 'LineWidth', 1.5);
                xlim([xVals(1) xVals(end)]);
                zero_line;
                y_zero_line;
                if ss == 1
                    ylabel({'Cross-Correlation'; 'Coefficient'});
                end
                title(stateNames{ss});
                set(gca, 'FontName', 'Arial');
                
                
                % Plot the average with the CI and shuffle AVG
                subplot(3,2,ss+2);
                hold on;
                plot(xVals, shuffleCrossCorr_AVG(xInds), 'Color', shufColMat(5,:), 'LineWidth', 1.5);
                for lim = 1:2
                    plot(xVals, shuffleCrossCorr_CI(xInds,lim), 'Color', shufColMat(5,:));
                end
                plot(xVals, origCrossCorr(xInds), 'k', 'LineWidth', 1.5);
                zero_line;
                y_zero_line;
                xlim([xVals(1) xVals(end)]);
                if ss == 1
                    ylabel({'Cross-Correlation'; 'Coefficient'});
                end
                set(gca, 'FontName', 'Arial');
                
                
                % Remove the theta component
                %  Find orig cross corr vals within the shuffled CI and set them to the average shuffle cross corr
                thetaExpInds = find(origCrossCorr>shuffleCrossCorr_CI(:,1) & origCrossCorr<shuffleCrossCorr_CI(:,2)); %find average values explainable by theta
                thetaCrossCorr = origCrossCorr;
                thetaCrossCorr(thetaExpInds) = shuffleCrossCorr_AVG(thetaExpInds);
                %  Find orig cross corr vals below shuffled CI and add to them the distance between the nearest shuffle CI edge and the shuffle AVG
                belowCIInds = find(origCrossCorr <= shuffleCrossCorr_CI(:,1));
                CItoAVGdist = shuffleCrossCorr_AVG - shuffleCrossCorr_CI(:,1);
                thetaCrossCorr(belowCIInds) = origCrossCorr(belowCIInds) + CItoAVGdist(belowCIInds);
                %  Find orig cross corr vals above shuffled CI and subtract from them the distance between the nearest shuffle CI edge and the shuffle AVG
                aboveCIInds = find(origCrossCorr >= shuffleCrossCorr_CI(:,2));
                CItoAVGdist = shuffleCrossCorr_CI(:,1) - shuffleCrossCorr_AVG;
                thetaCrossCorr(aboveCIInds) = origCrossCorr(aboveCIInds) - CItoAVGdist(aboveCIInds);
                thetaCrossCorr = thetaCrossCorr - shuffleCrossCorr_AVG;
                
                % Plot the cross corr with theta contribution removed
                subplot(3,2,ss+4);
                plot(xVals, thetaCrossCorr(xInds), 'k', 'LineWidth', 1.5');
                zero_line;
                y_zero_line;
                xlim([xVals(1) xVals(end)]);
                if ss == 1
                    ylabel({'Cross-Correlation'; 'Coefficient'});
                end
                set(gca, 'FontName', 'Arial');
                xlabel('Time lag (s)');
                
                if saveFigs == 1 && ss == 2
                    tmpCD = pwd;
                    cd(saveDir);
                    figTtl = [region(reg).name '_' plotAbbrevs{pm} '_CP' num2str(ci) '_SEM_Fig'];
                    savefig(semFig, figTtl);
                    print(figTtl, '-dpng'); %save as png
                    cd(tmpCD);
                end
                
                
                
                
                %% PLOT WITH THE CONFIDENCE INTERVAL BASED ON THE 97.5th PERCENTILE OF THE BOOTSTRAP DISTRIBUTION
                figure(bsFig);
                
                % Calculate confidence interval based on sorted index of the bootstrap distribution
                CI_Ind(1) = floor(0.025 * numShufs);
                if numShufs < 40 %if debugging and numShufs < 40, CI_Ind(1) will be 0
                    CI_Ind(1) = 1;
                end
                CI_Ind(2) = ceil(0.975 * numShufs);
                
                srtedShufCrossCorrs = sort(shuffleCrossCorr,2);
                
                shuffleCrossCorr_CI = [srtedShufCrossCorrs(:,CI_Ind(1)) ... %lower bound of 98% CI
                    srtedShufCrossCorrs(:,CI_Ind(2))]; %upper bound of 98% CI
                
                %  Plot the average with 10 example shuffles
                subplot(3,2,ss);
                hold on;
                for sh = 1:tmpNumShufs
                    plot(xVals, shuffleCrossCorr(xInds,sh), 'Color', shufColMat(sh,:));
                end
                plot(xVals, origCrossCorr(xInds), 'k', 'LineWidth', 1.5);
                xlim([xVals(1) xVals(end)]);
                zero_line;
                y_zero_line;
                if ss == 1
                    ylabel({'Cross-Correlation'; 'Coefficient'});
                end
                title(stateNames{ss});
                set(gca, 'FontName', 'Arial');
                
                
                % Plot the average with the CI and shuffle AVG
                subplot(3,2,ss+2);
                hold on;
                plot(xVals, shuffleCrossCorr_AVG(xInds), 'Color', shufColMat(5,:), 'LineWidth', 1.5);
                for lim = 1:2
                    plot(xVals, shuffleCrossCorr_CI(xInds,lim), 'Color', shufColMat(5,:));
                end
                plot(xVals, origCrossCorr(xInds), 'k', 'LineWidth', 1.5);
                zero_line;
                y_zero_line;
                xlim([xVals(1) xVals(end)]);
                if ss == 1
                    ylabel({'Cross-Correlation'; 'Coefficient'});
                end
                set(gca, 'FontName', 'Arial');
                
                
                % Remove the theta component
                %  Find orig cross corr vals within the shuffled CI and set them to the average shuffle cross corr
                thetaExpInds = find(origCrossCorr>shuffleCrossCorr_CI(:,1) & origCrossCorr<shuffleCrossCorr_CI(:,2)); %find average values explainable by theta
                thetaCrossCorr = origCrossCorr;
                thetaCrossCorr(thetaExpInds) = shuffleCrossCorr_AVG(thetaExpInds);
                %  Find orig cross corr vals below shuffled CI and add to them the distance between the nearest shuffle CI edge and the shuffle AVG
                belowCIInds = find(origCrossCorr <= shuffleCrossCorr_CI(:,1));
                CItoAVGdist = shuffleCrossCorr_AVG - shuffleCrossCorr_CI(:,1);
                thetaCrossCorr(belowCIInds) = origCrossCorr(belowCIInds) + CItoAVGdist(belowCIInds);
                %  Find orig cross corr vals above shuffled CI and subtract from them the distance between the nearest shuffle CI edge and the shuffle AVG
                aboveCIInds = find(origCrossCorr >= shuffleCrossCorr_CI(:,2));
                CItoAVGdist = shuffleCrossCorr_CI(:,1) - shuffleCrossCorr_AVG;
                thetaCrossCorr(aboveCIInds) = origCrossCorr(aboveCIInds) - CItoAVGdist(aboveCIInds);
                thetaCrossCorr = thetaCrossCorr - shuffleCrossCorr_AVG;
                
                % Plot the cross corr with theta contribution removed
                subplot(3,2,ss+4);
                plot(xVals, thetaCrossCorr(xInds), 'k', 'LineWidth', 1.5');
                zero_line;
                y_zero_line;
                xlim([xVals(1) xVals(end)]);
                if ss == 1
                    ylabel({'Cross-Correlation'; 'Coefficient'});
                end
                set(gca, 'FontName', 'Arial');
                xlabel('Time lag (s)');
                
                if saveFigs == 1 && ss == 2
                    tmpCD = pwd;
                    cd(saveDir);
                    figTtl = [region(reg).name '_' plotAbbrevs{pm} '_CP' num2str(ci) '_BootstrapCI_Fig'];
                    savefig(bsFig, figTtl);
                    print(figTtl, '-dpng'); %save as png
                    cd(tmpCD);
                end
                
                
                
                cd ../ %out of task directory
            end%state
            cd ../../.. %out of day/session/rat (i,e., back to region subdir)
        end %cell pairs
    end %phase mag groups (low/high)
    cd ../ %out of region subdir
end %region


cd(curDir); %back from whence you came
end%fnctn



