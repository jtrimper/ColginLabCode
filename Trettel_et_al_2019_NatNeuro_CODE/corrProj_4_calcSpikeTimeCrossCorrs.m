function region = corrProj_4_calcSpikeTimeCrossCorrs(region)
% function region = corrProj_4_calcSpikeTimeCrossCorrs(region)
%
% PURPOSE:
%   Function to calculate spike time cross correlations by state.
%
% INPUT:
%   region = project uber data structure after it has been passed through
%            the other 3 corrProj functions
%
% OUTPUT:
%   region = same thing, but an additional field for each session titled cell pair that contains,
%            for each state (RUN, REM, nREM), the spike time cross correlations for each bout/bin
%            along with the sum across the middle bins
%
% JBT 8/2017
% Colgin Lab

interimSave = 1; %set to 1 to save the output structure after each rat

xCorrLag = 5.000; %seconds - +/- lag for cross corr
spkBinDur = [0.002 0.005 0.010 0.050]; %s - bin sizes for cross correlation
sleepStateNames = {'REM', 'nREM'};

curDir = pwd;
dataDir = 'I:\STORAGE\LAB_STUFF\COLGIN_LAB\PROJECTS\Grid_Cell_Correlations_TrettelProj\CORR_PROJECT_RERUN\DATASET';
cd(dataDir);

for reg = 1:2
    % for reg = 1
    fprintf('%s\n', region(reg).name)
    cd(region(reg).name)
    for r = 1:length(region(reg).rat)
        %     for r = 4
        fprintf('\t%s\n', region(reg).rat(r).name);
        cd(region(reg).rat(r).name)
        for s = 1:length(region(reg).rat(r).session)
            fprintf('\t\tSession %d\n', s);
            cd(['Session' num2str(s)])
            for d = 1
                fprintf('\t\t\tDay %d\n', d);
                cd(['Day' num2str(d)])
                
                
                
                if reg == 1 %MEC
                    tNum = 2; %Open Field
                else %CA1
                    tNum = 1; %Circular Track
                end
                cd(region(reg).rat(r).session(s).day(d).task(tNum).name);
                fprintf('\t\t\t\t%s\n', region(reg).rat(r).session(s).day(d).task(tNum).name)
                
                
                
                %% GET A LIST OF ALL POSSIBLE UNIQUE CELL PAIRS
                cellPairList = [];
                cpCntr = 1;
                for u1 = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout(1).unit)
                    if region(reg).rat(r).session(s).day(d).task(tNum).bout(1).unit(u1).type == 1
                        u1ID = region(reg).rat(r).session(s).day(d).task(tNum).bout(1).unit(u1).ID;
                        for u2 = u1+1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout(1).unit)
                            if region(reg).rat(r).session(s).day(d).task(tNum).bout(1).unit(u2).type == 1
                                u2ID = region(reg).rat(r).session(s).day(d).task(tNum).bout(1).unit(u2).ID;
                                cellPairList(:,:,cpCntr) = [u1ID; u2ID]; %#ok
                                cpCntr = cpCntr + 1;
                            end
                        end
                    end
                end
                
                %% FIRST GO THROUGH THE RUN EPOCHS
                for b = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout)
                    fprintf('\t\t\t\t\tBout %d\n', b);
                    cd(['Begin' num2str(b)]);
                    
                    runEpochBnds = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).runTimes;
                    
                    if ~isempty(runEpochBnds)
                        
                        fprintf('\t\t\t\t\t\t%0.04g sec of RUN for this bout.\n', sum(diff(runEpochBnds,[],2)));
                        
                        % get the time edges for the window; make an empty vector to fill in spike counts
                        eegFile = dir('*.ncs');
                        eegStruct = read_in_eeg(eegFile(1).name);
                        epochTs = eegStruct.ts(1):0.0005:eegStruct.ts(end);
                        
                        % GET RATE-MAP AND SPIKE TIMES FOR UNIT 1
                        for u1 = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit)
                            u1ID = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u1).ID;
                            %                             fprintf('\t\t\t\t\t\tUnit %d (Tet#%d, Unit#%d)\n', u1, u1ID(1), u1ID(2));
                            if region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u1).type ~= 1 %if it's a grid cell/CA1 pyram
                                %                                 fprintf('\t\t\t\t\t\t\tUnit is not a grid cell. Skipping.\n');
                            else
                                
                                u1SpkTms = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u1).spkTms;
                                
                                %get only the spikes that occurred during the sleep epochs
                                u1StateSpks = [];
                                for e = 1:size(runEpochBnds,1)
                                    startTime = runEpochBnds(e,1);
                                    endTime = runEpochBnds(e,2);
                                    
                                    spkInds = find(u1SpkTms>=startTime & u1SpkTms<=endTime);
                                    if ~isempty(spkInds)
                                        u1StateSpks = [u1StateSpks; u1SpkTms(spkInds)]; %#ok
                                    end
                                end
                                
                                %convert spike times to binary for binning
                                %  FYI: can't use histcounts because there's a max # of bins that makes .002, .005, and .010 have the same #
                                u1SpkBinaryTs = zeros(1,length(epochTs));
                                for st = 1:length(u1StateSpks)
                                    tmpSpkTm = u1StateSpks(st);
                                    spkInd = find(epochTs<=tmpSpkTm, 1, 'Last');
                                    u1SpkBinaryTs(spkInd) = u1SpkBinaryTs(spkInd) + 1; %in case there was more than 1 spike that lined up with this EEG sample
                                end
                                
                                %get spike counts binned by diferent bin durations
                                u1BinnedSpks = cell(1,length(spkBinDur));
                                for bs = 1:length(spkBinDur)
                                    tmpBinDur = spkBinDur(bs);
                                    binLen = tmpBinDur / 0.0005;
                                    numRows = floor(length(u1SpkBinaryTs)/binLen);
                                    tmpSpkBinary = u1SpkBinaryTs(1:numRows*binLen);
                                    reshSpkBinary = reshape(tmpSpkBinary, binLen, numRows);
                                    u1BinnedSpks{bs} = sum(reshSpkBinary,1);
                                end
                                
                                % GET SPIKE TIMES FOR UNIT 2
                                %  Check against a bunch of criteria
                                for u2 = u1+1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit)
                                    
                                    u2ID = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u2).ID; %get unit 2 ID
                                    %                                     fprintf('\t\t\t\t\t\t\tPaired with Unit %d (Tet#%d, Unit#%d)\n', u2, u2ID(1), u2ID(2));
                                    
                                    if region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u2).type ~= 1 %if it's a grid cell/CA1 pyram
                                        %                                         fprintf('\t\t\t\t\t\t\t\tUnit is not a grid cell. Skipping.\n');
                                    else
                                        
                                        
                                        u2SpkTms = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u2).spkTms;
                                        
                                        u2StateSpks = [];
                                        for e = 1:size(runEpochBnds,1)
                                            startTime = runEpochBnds(e,1);
                                            endTime = runEpochBnds(e,2);
                                            
                                            spkInds = find(u2SpkTms>=startTime & u2SpkTms<=endTime);
                                            if ~isempty(spkInds)
                                                u2StateSpks = [u2StateSpks; u2SpkTms(spkInds)]; %#ok
                                            end
                                        end
                                        
                                        
                                        %convert spike times to binary for binning
                                        %  FYI: can't use histcounts because there's a max # of bins that makes .002, .005, and .010 have the same #
                                        u2SpkBinaryTs = zeros(1,length(epochTs));
                                        for st = 1:length(u2StateSpks)
                                            tmpSpkTm = u2StateSpks(st);
                                            spkInd = find(epochTs<=tmpSpkTm, 1, 'Last');
                                            u2SpkBinaryTs(spkInd) = u2SpkBinaryTs(spkInd) + 1; %in case there was more than 1 spike that lined up with this EEG sample
                                        end
                                        
                                        %get spike counts binned by diferent bin durations
                                        u2BinnedSpks = cell(1,length(spkBinDur));
                                        for bs = 1:length(spkBinDur)
                                            tmpBinDur = spkBinDur(bs);
                                            binLen = tmpBinDur / 0.0005;
                                            numRows = floor(length(u2SpkBinaryTs)/binLen);
                                            tmpSpkBinary = u2SpkBinaryTs(1:numRows*binLen);
                                            reshSpkBinary = reshape(tmpSpkBinary, binLen, numRows);
                                            u2BinnedSpks{bs} = sum(reshSpkBinary,1);
                                        end
                                        
                                        
                                        % calculate spike time cross correlation
                                        cpCc = cell(1,4);
                                        nCpCc = cell(1,4);
                                        for bs = 1:length(spkBinDur)
                                            cpCc{bs} = xcorr(u1BinnedSpks{bs}, u2BinnedSpks{bs}, xCorrLag/spkBinDur(bs)); %non-normalized cross-correlation
                                            nCpCc{bs} = xcorr(u1BinnedSpks{bs}, u2BinnedSpks{bs}, xCorrLag/spkBinDur(bs), 'coeff'); %non-normalized cross-correlation
                                            if bs == 1
                                                %Sum over center 5 ms
                                                tmpInds = median(1:length(cpCc{bs}))-2:median(1:length(cpCc{bs}))+2;
                                                midSum(1) = sum(cpCc{bs}(tmpInds));
                                                %Sum over center 50 ms
                                                tmpInds = median(1:length(cpCc{bs}))-25:median(1:length(cpCc{bs}))+25;
                                                midSum(2) = sum(cpCc{bs}(tmpInds));
                                            end
                                        end
                                        
                                        
                                        % find out which cell pair this is in the list
                                        cpInd = find(cellPairList(1,1,:)==u1ID(1) & cellPairList(1,2,:)==u1ID(2) & cellPairList(2,1,:)==u2ID(1) & cellPairList(2,2,:)==u2ID(2));
                                        
                                        %store all the variables we might need
                                        region(reg).rat(r).session(s).state(1).cellPair(cpInd).midSum(:,b) = midSum;
                                        region(reg).rat(r).session(s).state(1).cellPair(cpInd).stXCorr{b} = cpCc;
                                        region(reg).rat(r).session(s).state(1).cellPair(cpInd).normStXCorr{b} = nCpCc;
                                        
                                        
                                    end %if unit2 is a grid cell/pyram
                                end %unit2
                            end %if unit1 is a grid cell/pyram
                        end %unit1
                    end %if there were run epochs for this bout
                    cd ../
                end %bout
                
                cd ../ %FYI: leave this if just running sleep for debug
                
                
                
                %% THEN GO THROUGH THE SLEEP EPOCHS
                tNum = 3;
                cd(region(reg).rat(r).session(s).day(d).task(tNum).name);
                fprintf('\t\t\t\t%s\n', region(reg).rat(r).session(s).day(d).task(tNum).name)
                
                for b = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout)
                    %                 for b = 1:5
                    fprintf('\t\t\t\t\tBout %d\n', b);
                    try
                        cd(['Sleep' num2str(b)]);
                        goodDir = 1;
                    catch
                        goodDir = 0;
                    end
                    
                    if goodDir == 1
                        for ss = 1:2
                            fprintf('\t\t\t\t\t\t%s\n', sleepStateNames{ss});
                            
                            
                            if ss == 1
                                sleepEpochBnds = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).remTimes;
                            else
                                sleepEpochBnds = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).nRemTimes;
                            end
                            
                            if ~isempty(sleepEpochBnds)
                                
                                fprintf('\t\t\t\t\t\t\t%0.04g sec of %s for this bout.\n', sum(diff(sleepEpochBnds,[],2)), sleepStateNames{ss});
                                
                                eegFile = dir('*.ncs');
                                eegStruct = read_in_eeg(eegFile(1).name);
                                epochTs = eegStruct.ts(1):0.0005:eegStruct.ts(end);
                                
                                
                                % GET SPIKE TIMES FOR UNIT 1
                                for u1 = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit)
                                    u1ID = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u1).ID;
                                    %                                     fprintf('\t\t\t\t\t\t\tUnit %d (Tet#%d, Unit#%d)\n', u1, u1ID(1), u1ID(2));
                                    if region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u1).type ~= 1 %if it's a grid cell/CA1 pyram
                                        %                                         fprintf('\t\t\t\t\t\t\t\tMEC unit is not a grid cell. Moving on.\n');
                                    else
                                        
                                        u1SpkTms = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u1).spkTms;
                                        
                                        %get only the spikes that occurred during the sleep epochs
                                        u1StateSpks = [];
                                        for e = 1:size(sleepEpochBnds,1)
                                            startTime = sleepEpochBnds(e,1);
                                            endTime = sleepEpochBnds(e,2);
                                            
                                            spkInds = find(u1SpkTms>=startTime & u1SpkTms<=endTime);
                                            if ~isempty(spkInds)
                                                u1StateSpks = [u1StateSpks; u1SpkTms(spkInds)]; %#ok
                                            end
                                        end
                                        
                                        %convert spike times to binary for binning
                                        %  FYI: can't use histcounts because there's a max # of bins that makes .002, .005, and .010 have the same #
                                        u1SpkBinaryTs = zeros(1,length(epochTs));
                                        for st = 1:length(u1StateSpks)
                                            tmpSpkTm = u1StateSpks(st);
                                            spkInd = find(epochTs<=tmpSpkTm, 1, 'Last');
                                            u1SpkBinaryTs(spkInd) = 1;
                                        end
                                        
                                        
                                        %get spike counts binned by diferent bin durations
                                        u1BinnedSpks = cell(1,length(spkBinDur));
                                        for bs = 1:length(spkBinDur)
                                            tmpBinDur = spkBinDur(bs);
                                            binLen = tmpBinDur / 0.0005;
                                            numRows = floor(length(epochTs)/binLen);
                                            tmpSpkBinary = u1SpkBinaryTs(1:numRows*binLen);
                                            reshSpkBinary = reshape(tmpSpkBinary, binLen, numRows);
                                            u1BinnedSpks{bs} = sum(reshSpkBinary,1);
                                        end
                                        
                                        % GET SPIKE TIMES FOR UNIT 2
                                        %  Check against a bunch of criteria
                                        for u2 = u1+1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit)
                                            
                                            u2ID = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u2).ID; %get unit 2 ID
                                            %                                             fprintf('\t\t\t\t\t\t\t\tPaired with Unit %d (Tet#%d, Unit#%d)\n', u2, u2ID(1), u2ID(2));
                                            
                                            if region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u2).type ~= 1 %if it's a grid cell/CA1 pyram
                                                %                                                 fprintf('\t\t\t\t\t\t\t\t\tMEC unit is not a grid cell. Moving on.\n');
                                            else
                                                
                                                u2SpkTms = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u2).spkTms;
                                                
                                                u2StateSpks = [];
                                                for e = 1:size(sleepEpochBnds,1)
                                                    startTime = sleepEpochBnds(e,1);
                                                    endTime = sleepEpochBnds(e,2);
                                                    
                                                    spkInds = find(u2SpkTms>=startTime & u2SpkTms<=endTime);
                                                    if ~isempty(spkInds)
                                                        u2StateSpks = [u2StateSpks; u2SpkTms(spkInds)]; %#ok
                                                    end
                                                end
                                                
                                                
                                                %convert spike times to binary for binning
                                                %  FYI: can't use histcounts because there's a max # of bins that makes .002, .005, and .010 have the same #
                                                u2SpkBinaryTs = zeros(1,length(epochTs));
                                                for st = 1:length(u2StateSpks)
                                                    tmpSpkTm = u2StateSpks(st);
                                                    spkInd = find(epochTs<=tmpSpkTm, 1, 'Last');
                                                    u2SpkBinaryTs(spkInd) = 1;
                                                end
                                                
                                                %get spike counts binned by diferent bin durations
                                                u2BinnedSpks = cell(1,length(spkBinDur));
                                                for bs = 1:length(spkBinDur)
                                                    tmpBinDur = spkBinDur(bs);
                                                    binLen = tmpBinDur / 0.0005;
                                                    numRows = floor(length(epochTs)/binLen);
                                                    tmpSpkBinary = u2SpkBinaryTs(1:numRows*binLen);
                                                    reshSpkBinary = reshape(tmpSpkBinary, binLen,numRows);
                                                    u2BinnedSpks{bs} = sum(reshSpkBinary,1);                                                    
                                                end
                                                
                                                
                                                % calculate spike time cross correlation
                                                cpCc = cell(1,4);
                                                nCpCc = cell(1,4);
                                                for bs = 1:length(spkBinDur)
                                                    cpCc{bs} = xcorr(u1BinnedSpks{bs}, u2BinnedSpks{bs}, xCorrLag/spkBinDur(bs)); %non-normalized cross-correlation
                                                    nCpCc{bs} = xcorr(u1BinnedSpks{bs}, u2BinnedSpks{bs}, xCorrLag/spkBinDur(bs), 'coeff'); %non-normalized cross-correlation
                                                    if bs == 1
                                                        %Sum over center 5 ms
                                                        tmpInds = median(1:length(cpCc{bs}))-2:median(1:length(cpCc{bs}))+2;
                                                        midSum(1) = sum(cpCc{bs}(tmpInds));
                                                        %Sum over center 50 ms
                                                        tmpInds = median(1:length(cpCc{bs}))-25:median(1:length(cpCc{bs}))+25;
                                                        midSum(2) = sum(cpCc{bs}(tmpInds));
                                                    end
                                                end
                                                
                                                % find out which cell pair this is in the list
                                                cpInd = find(cellPairList(1,1,:)==u1ID(1) & cellPairList(1,2,:)==u1ID(2) & cellPairList(2,1,:)==u2ID(1) & cellPairList(2,2,:)==u2ID(2));
                                                
                                                %store all the variables we might need
                                                region(reg).rat(r).session(s).state(ss+1).cellPair(cpInd).midSum(:,b) = midSum;
                                                region(reg).rat(r).session(s).state(ss+1).cellPair(cpInd).stXCorr{b} = cpCc;
                                                region(reg).rat(r).session(s).state(ss+1).cellPair(cpInd).normStXCorr{b} = nCpCc;
                                                
                                            end %if unit2 is a grid cell/pyram
                                        end %unit2
                                    end %if unit1 is a grid cell/pyram
                                end %unit1
                            else
                                fprintf('\t\t\t\t\t\t\tNo %s epochs for this bout.\n', sleepStateNames{ss});
                            end %if there were sleep epochs for this bout
                            
                        end %REM then nREM
                    else
                        fprintf('\t\t\t\t\t\tNo data directory for this bout.\n');
                    end
                    cd ../
                end %bout
                cd ../
                
                cd ../
            end %day
            cd ../
        end %session
        cd ../
        
        
        if interimSave == 1
            tmpCD = pwd;
            cd(dataDir);
            save(['corrProj_4_interimSave_curInfo_Reg' num2str(reg) 'R' num2str(r)], 'region', '-v7.3');
            cd(tmpCD);
        
        end
        
    end %rat
    cd ../
end %region



cd(curDir)
end %fnctn

