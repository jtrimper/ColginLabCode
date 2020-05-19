function region = corrProj_3_attachStateTimes(region)
% function region = corrProj_3_attachStateTimes(region)
%
% PURPOSE:
%   Function attaches to the 'bout' field of the uber structure the epoch
%   bounds for each time that a rat is in RUN, REM, or nREM.
%
% INPUT:
%  region = project uber data structure
%
% OUTPUT:
%  region = same as input, but with a matrix of epoch bounds attached
%           to the bout field of each session
%
% JBT 8/2017
% Colgin Lab




runThresh = 5; %cm/s
runTDRThresh = 2; %minimum RUN TDR
minRunTime = 0.5; %seconds - minimum run window duration
runGWinSize = 4; %frames - Gaussian window for smoothing

remTDRThresh = 1.5; %minimum REM TDR
minRemTime = 60; %seconds - minimum REM bout duration

nRemTDRThresh = 1; %maximum nREM TDR
minNonRemTime = 15; %seconds - minimum nonREM bout duration

tdrMwSize = 5; %seconds - win size for moving window of sleep TDR
tdrMwStep = 0.5; %seconds - win step for moving window of sleep TDR

vidSampRate = 29.96998; %frames per second

sleepStateNames = {'REM', 'nREM'};

curDir = pwd;
dataDir = 'C:\Users\John Trimper\Desktop\LAB_STUFF\PROJECTS\Grid_Cell_Correlations_TrettelProj\CORR_PROJECT_RERUN\DATASET';
cd(dataDir);

for reg = 1:2
    % for reg = 1
    fprintf('%s\n', region(reg).name)
    cd(region(reg).name)
    %     for r = 1:length(region(reg).rat)
    for r = 4
        fprintf('\t%s\n', region(reg).rat(r).name);
        cd(region(reg).rat(r).name)
        for s = 1:length(region(reg).rat(r).session)
            %         for s = 5
            fprintf('\t\tSession %d\n', s);
            cd(['Session' num2str(s)])
            for d = 1
                fprintf('\t\t\tDay %d\n', d);
                cd(['Day' num2str(d)])
                
                
                %% FIND RUN EPOCH BOUNDS
                
                if reg == 1 %MEC
                    tNum = 2; %Open Field
                else %CA1
                    tNum = 1; %Circular Track
                end
                cd(region(reg).rat(r).session(s).day(d).task(tNum).name);
                fprintf('\t\t\t\t%s\n', region(reg).rat(r).session(s).day(d).task(tNum).name)
                
                
                for b = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout)
                    fprintf('\t\t\t\t\tBout %d\n', b);
                    cd(['Begin' num2str(b)]);
                    
                    
                    %LOAD IN THE EEG AND LOOK FOR TDR EPOCHS
                    fprintf('\t\t\t\t\t\tFinding RUN TDR Epochs...\n');
                    eegFileInfo = dir('*.ncs');
                    eegStruct = read_in_eeg(eegFileInfo.name);
                    
                    %calculate delta power
                    deltaPow = traces2TFR(eegStruct.data,2:5,eegStruct.Fs,5);
                    deltaPow = mean(deltaPow,1); %average across the frequency range
                    
                    %calculate theta power
                    thetaPow = traces2TFR(eegStruct.data,6:10,eegStruct.Fs,5);
                    thetaPow = mean(thetaPow,1);  %average across the frequency range
                    
                    %calculate TDR
                    tdr = thetaPow./deltaPow;
                    
                    [mwTdr, mwInds] = mw_avg(tdr, tdrMwSize*eegStruct.Fs, tdrMwStep*eegStruct.Fs,0);
                    halfWin = (tdrMwSize*eegStruct.Fs)/2;
                    
                    tdrBinary = zeros(1,length(eegStruct.data));
                    tdrChunks = bwconncomp(mwTdr>=runTDRThresh);
                    for c = 1:length(tdrChunks.PixelIdxList)
                        tmpInds = tdrChunks.PixelIdxList{c};
                        startInd = round(mwInds(tmpInds(1))-halfWin);
                        if startInd == 0
                            startInd = 1;
                        end
                        
                        endInd = round(mwInds(tmpInds(end))+halfWin);
                        if endInd > length(eegStruct.data)
                            endInd = length(eegStruct.data);
                        end
                        
                        tdrBinary(startInd:endInd) = 1;
                    end
                    
                    
                    
                    % NOW IDENTIFY RUNSPEED EPOCHS
                    fprintf('\t\t\t\t\t\tFinding RUN speed Epochs...\n');
                    instRs = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).instRs;
                    coords = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).coords;
                    rsTs = coords(:,1);
                    
                    % smooth the runspeed with a Gaussian window
                    gWin = gausswin(runGWinSize);
                    gWin = gWin ./ sum(gWin); %normalize
                    smRs = conv(instRs, gWin); %convolve
                    
                    %convolution adds a few extra points (round(runGWinSize/2))
                    % so we gotta cut those off as evenly as possible from each side
                    lenDif = length(smRs) - length(instRs);
                    rem1 = round(lenDif/2);
                    rem2 = lenDif-rem1;
                    smRs(1:rem1) = [];
                    smRs(end-rem2+1:end) = [];
                    
                    %identify times when runspeed was above threshold
                    rsBinary = zeros(1,length(eegStruct.data));
                    runChunks = bwconncomp(smRs >= runThresh,4);
                    for c = 1:length(runChunks.PixelIdxList)
                        tmpInds = runChunks.PixelIdxList{c};
                        if length(tmpInds)/vidSampRate > minRunTime
                            startInd = tmpInds(1);
                            endInd = tmpInds(end);
                            
                            startTime = rsTs(startInd);
                            endTime = rsTs(endInd);
                            
                            startEegInd = find(eegStruct.ts<=startTime, 1, 'Last');
                            endEegInd = find(eegStruct.ts>=endTime,1,'First');
                            
                            rsBinary(startEegInd:endEegInd) = 1;
                        end
                    end
                    
                    %NOW GET THE EPOCH BOUNDS FOR WHEN BOTH RUNSPEED AND TDR WERE ABOVE THRESH
                    fprintf('\t\t\t\t\t\tFinding when they intersect...\n');
                    RUN_TIMES = [];
                    RUN_BINARY = rsBinary ==1 & tdrBinary == 1;
                    runChunks = bwconncomp(RUN_BINARY);
                    for c = 1:length(runChunks.PixelIdxList)
                        tmpInds = runChunks.PixelIdxList{c};
                        startInd = tmpInds(1);
                        endInd = tmpInds(end);
                        
                        startTime = eegStruct.ts(startInd);
                        endTime = eegStruct.ts(endInd);
                        
                        RUN_TIMES(c,:) = [startTime endTime]; %#ok
                        
                    end
                    fprintf('\t\t\t\t\t\t\t%d RUN epochs detected. (%0.04g s).\n', size(RUN_TIMES,1), sum(diff(RUN_TIMES,[],2)));
                    
                    region(reg).rat(r).session(s).day(d).task(tNum).bout(b).runTimes = RUN_TIMES;
                    
                    
                    %                     %% CHECK YOUR WORK
                    %                     figure
                    %                     for rt = 1:size(RUN_TIMES,1)
                    %                        tmpStartTime = RUN_TIMES(rt,1);
                    %                        tmpEndTime = RUN_TIMES(rt,2);
                    %
                    %                        tmpStartEegInd = find(eegStruct.ts<=tmpStartTime,1,'Last');
                    %                        tmpEndEegInd = find(eegStruct.ts>=tmpEndTime,1,'First');
                    %
                    %                        fh(1) = plot(eegStruct.ts(tmpStartEegInd:tmpEndEegInd), tdr(tmpStartEegInd:tmpEndEegInd), 'b');
                    %                        hold on;
                    %                        plot(eegStruct.ts(tmpStartEegInd:tmpEndEegInd), repmat(2, 1, length(eegStruct.ts(tmpStartEegInd:tmpEndEegInd))), '--b')
                    %
                    %                        tmpStartRsInd = find(coords(:,1)<=tmpStartTime, 1, 'Last');
                    %                        tmpEndRsInd = find(coords(:,1)>=tmpEndTime, 1, 'First');
                    %                        fh(2) = plot(coords(tmpStartRsInd:tmpEndRsInd,1), smRs(tmpStartRsInd:tmpEndRsInd), 'r');
                    %                        plot(coords(tmpStartRsInd:tmpEndRsInd,1), repmat(5, 1, length(coords(tmpStartRsInd:tmpEndRsInd,1))), '--r');
                    %
                    %                        leg = legend(fh, {'TDR', 'Speed'});
                    %                        set(leg, 'Box', 'Off');
                    %
                    %
                    %                        pause;
                    %                        clf
                    %                     end
                    
                    
                    cd ../
                end %bout
                cd ../
                
                
                %% FIND SLEEP EPOCH BOUNDS
                
                tNum = 3;
                cd(region(reg).rat(r).session(s).day(d).task(tNum).name);
                fprintf('\t\t\t\t%s\n', region(reg).rat(r).session(s).day(d).task(tNum).name)
                
                for b = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout)
                    fprintf('\t\t\t\t\tBout %d\n', b);
                    cd(['Sleep' num2str(b)]);
                    
                    
                    %LOAD IN THE EEG AND LOOK FOR TDR EPOCHS
                    fprintf('\t\t\t\t\t\tReading EEG; calculating TDR...\n');
                    eegFileInfo = dir('*.ncs');
                    tetFileCheck = dir('TT*.t');
                    if isempty(eegFileInfo) || isempty(tetFileCheck)
                        fprintf('\t\t\t\t\t\t\tNo data for this bout.\n');
                        region(reg).rat(r).session(s).day(d).task(tNum).bout(b).remTimes = [];
                        region(reg).rat(r).session(s).day(d).task(tNum).bout(b).nRemTimes = [];
                    else
                        eegStruct = read_in_lfp(eegFileInfo.name);
                        
                        %calculate delta power
                        deltaPow = traces2TFR(eegStruct.data,2:5,eegStruct.Fs,5);
                        deltaPow = mean(deltaPow,1);
                        
                        %calculate theta power
                        thetaPow = traces2TFR(eegStruct.data,6:10,eegStruct.Fs,5);
                        thetaPow = mean(thetaPow,1);
                        
                        %calculate TDR
                        tdr = thetaPow./deltaPow;
                        
                        [mwTdr, mwInds] = mw_avg(tdr, tdrMwSize*eegStruct.Fs, tdrMwStep*eegStruct.Fs,0);
                        halfWin = (tdrMwSize*eegStruct.Fs)/2;
                        
                        
                        
                        for ss = 1:2
                            fprintf('\t\t\t\t\t\tFinding %s TDR Epochs...\n', sleepStateNames{ss});
                            if ss == 1 %looking for REM times
                                tdrThresh = remTDRThresh;
                                minDur = minRemTime;
                            else %looking for nonREM times
                                tdrThresh = nRemTDRThresh;
                                minDur = minNonRemTime;
                            end
                            
                            
                            %find chunks of time when TDR met criteria
                            if ss == 1 %REM (checking against a minimum)
                                tdrChunks = bwconncomp(mwTdr>=tdrThresh);
                            else %nonREM (checking against a maximum)
                                tdrChunks = bwconncomp(mwTdr<=tdrThresh);
                            end
                            
                            %look for chunks of appropriate duration
                            SLEEP_TIMES = [];
                            cntr = 1;
                            for c = 1:length(tdrChunks.PixelIdxList)
                                tmpInds = tdrChunks.PixelIdxList{c};
                                startInd = round(mwInds(tmpInds(1))-halfWin);
                                if startInd == 0
                                    startInd = 1;
                                end
                                startTime = eegStruct.ts(startInd);
                                
                                endInd = round(mwInds(tmpInds(end))+halfWin);
                                if endInd > length(eegStruct.data)
                                    endInd = length(eegStruct.data);
                                end
                                endTime = eegStruct.ts(endInd);
                                
                                if endTime - startTime >= minDur
                                    SLEEP_TIMES(cntr,:) = [startTime endTime]; %#ok
                                    cntr = cntr + 1;
                                end
                            end
                            
                            fprintf('\t\t\t\t\t\t\t%d %s epochs detected (%0.04g s).\n', size(SLEEP_TIMES,1), sleepStateNames{ss}, sum(diff(SLEEP_TIMES,[],2)));
                            
                            
                            if ss == 1 %assign REM epochs
                                region(reg).rat(r).session(s).day(d).task(tNum).bout(b).remTimes = SLEEP_TIMES;
                            else %assign non-REM epochs
                                keyboard
                                
                                region(reg).rat(r).session(s).day(d).task(tNum).bout(b).nRemTimes = SLEEP_TIMES;
                            end
                            
                            
                            %                             %% CHECK YOUR WORK
                            %                             figure
                            %                             fh = [];
                            %                             for st = 1:size(SLEEP_TIMES,1)
                            %                                 tmpStartTime = SLEEP_TIMES(st,1);
                            %                                 tmpEndTime = SLEEP_TIMES(st,2);
                            %
                            %                                 tmpStartEegInd = find(eegStruct.ts<=tmpStartTime,1,'Last');
                            %                                 tmpEndEegInd = find(eegStruct.ts>=tmpEndTime,1,'First');
                            %
                            %                                 fh(1) = plot(eegStruct.ts(tmpStartEegInd:tmpEndEegInd), tdr(tmpStartEegInd:tmpEndEegInd), 'b');
                            %                                 hold on;
                            %                                 plot(eegStruct.ts(tmpStartEegInd:tmpEndEegInd), repmat(tdrThresh, 1, length(eegStruct.ts(tmpStartEegInd:tmpEndEegInd))), '--b')
                            %
                            %                                 leg = legend(fh, {'TDR'});
                            %                                 set(leg, 'Box', 'Off');
                            %
                            %                                 pause;
                            %                                 clf
                            %                             end
                            
                            
                        end %sleep state
                    end %no data for this bout
                    cd ../
                end %bout
                cd ../
                
                keyboard
                poly = fill([wholeNightBnds fliplr(wholeNightBnds)], [1 1 2 2], [0 0 0]);
                
                cd ../
            end %day
            cd ../
        end %session
        cd ../
    end %rat
    cd ../
end %region


cd(curDir)
end %fnctn


