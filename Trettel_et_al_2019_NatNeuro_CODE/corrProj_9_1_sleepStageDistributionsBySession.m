function corrProj_9_1_sleepStageDistributionsBySession(region)
% function corrProj_9_1_sleepStageDistributionsBySession(region)
%
% PURPOSE: 
%  To get a look at how nREM (and REM), as well as sleep bouts as a whole, are distributed throughout the overnight
%  recordings. If we want to look at how correlations change across the night, we need a sufficient amount of time
%  in nREM for each period of the night. 
%
% INPUT: 
%  region = corr project uber data structure
%
% OUTPUT: 
%  Figures saved in 'saveDir' specified at top of function. One figure shows, color-coded, where sleep bouts, REM
%  epochs, and nREM epochs occur throughout the night. The other figure shows the amount of time in nREM across the night. 
%
% JBT 12/2017
% Colgin Lab


saveDir = 'I:\STORAGE\LAB_STUFF\COLGIN_LAB\PROJECTS\Grid_Cell_Correlations_TrettelProj\MANUSCRIPT\NATURE_NEURO_SUBMISSION\REVISIONS\NEW_RESULTS\Distrib_of_nRem_x_Night_by_Ses'; 

curDir = pwd;
dataDir = 'C:\Users\John Trimper\Desktop\LAB_STUFF\PROJECTS\Grid_Cell_Correlations_TrettelProj\CORR_PROJECT_RERUN\DATASET';
cd(dataDir);

binWidthInMin = 10; %minute bins

t = 3; %Overnight
d = 1; %Day

regNames = {'MEC', 'CA1'};
stateCols = {'Gold', 'Purple'};

% for reg = 1:2
for reg = 2
    fprintf('%s\n', regNames{reg});
    cd(region(reg).name)
    %     for r = 1:length(region(reg).rat)
    for r = 3:length(region(reg).rat)
        colCodeFig = figure('name', ['Color Coded - Reg ' num2str(reg) ', Rat ' num2str(r) '(' region(reg).rat(r).name ')'], 'Position', [1681 1 1680 973]);
        saveColCodeFigName= ['ColCode__Reg' num2str(reg) '_Rat ' num2str(r)];
        distFig = figure('name', ['Time Distribution - Reg ' num2str(reg) ', Rat ' num2str(r) '(' region(reg).rat(r).name ')'], 'Position', [ 1 31 1680  943]);
        saveDistFigName = ['TempDist__Reg' num2str(reg) '_Rat ' num2str(r)];
        fprintf('\tRat %d/%d\n', r, length(region(reg).rat));
        cd(region(reg).rat(r).name)
        for s = 1:length(region(reg).rat(r).session)
            fprintf('\t\tSession %d/%d\n', s, length(region(reg).rat(r).session));
            cd(['Session' num2str(s) '\Day1\Overnight'])
            sleepEpochBnds = [];
            sleepTypeBnds = cell(1,2);
            for b = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout)
                fprintf('\t\t\t\tBout %d/%d\n', b, length(region(reg).rat(r).session(s).day(d).task(t).bout));
                cd(['Sleep' num2str(b)]);
                
                
                eegFInfo = dir('*.ncs');
                try
                    eegStruct = read_in_eeg(eegFInfo(1).name);
                    goodRead = 1;
                catch
                    goodRead = 0;
                end
                
                if goodRead == 1
                    startBout = eegStruct.ts(1);
                    endBout = eegStruct.ts(end);
                    
                    sleepEpochBnds = [sleepEpochBnds; startBout endBout]; %#ok
                    
                    if b == 1
                        firstTs = startBout;
                    elseif b == length(region(reg).rat(r).session(s).day(d).task(t).bout)
                        lastTs = endBout;
                        wholeNightBnds = [firstTs lastTs];
                    end
                    
                    
                    if ~isempty(region(reg).rat(r).session(s).day(d).task(t).bout(b).remTimes)
                        sleepTypeBnds{1} = [sleepTypeBnds{1}; region(reg).rat(r).session(s).day(d).task(t).bout(b).remTimes];
                    end
                    if ~isempty(region(reg).rat(r).session(s).day(d).task(t).bout(b).nRemTimes)
                        sleepTypeBnds{2} = [sleepTypeBnds{2}; region(reg).rat(r).session(s).day(d).task(t).bout(b).nRemTimes];
                    end
                end
                cd ..
            end %bout
            
            
            % Make a color-coded plot of when the rat is in each state across the whole night
            figure(colCodeFig);
            subplot(7,1,s);
            hold on;
            
            wholeNightBnds = wholeNightBnds ./ 60^2; %convert to hours
            poly = fill([wholeNightBnds fliplr(wholeNightBnds)], [1 1 2 2], [0 0 0]);
            
            sleepEpochBnds = sleepEpochBnds ./ 60^2;
            for b = 1:size(sleepEpochBnds,1)
                poly = fill([sleepEpochBnds(b,:) fliplr(sleepEpochBnds(b,:))], [1 1 2 2], [.5 .5 .5]);
            end
            
            for st = 1:2
                sleepTypeBnds{st} = sleepTypeBnds{st} ./ 60^2;
                for e = 1:size(sleepTypeBnds{st},1)
                    poly = fill([sleepTypeBnds{st}(e,:) fliplr(sleepTypeBnds{st}(e,:))], [1 1 2 2], rgb(stateCols{st}));
                end
            end
            xlim([0 3]);
            set(gca, 'YTick', [], 'FontName', 'Arial');
            title(['Session ' num2str(s)]);
            if s == length(region(reg).rat(r).session)
                xlabel('Time (Hrs)');
            end
             
            
            
            % Make a plot showing the distribution of time in nREM across the night
            wholeNightBnds = wholeNightBnds .* 60^2; %convert back from hours
            wholeNightTsVctr = wholeNightBnds(1):1/2000:wholeNightBnds(2);
            
            sleepBnryVctr = zeros(1,length(wholeNightTsVctr));
            for e = 1:size(sleepEpochBnds,1)
                tmpBnds = sleepEpochBnds(e,:) .* 60^2;
                sleepBoutStartInd = find(wholeNightTsVctr<=tmpBnds(1), 1, 'Last');
                sleepBoutEndInd = find(wholeNightTsVctr>=tmpBnds(2), 1, 'First');
                sleepBnryVctr(sleepBoutStartInd:sleepBoutEndInd) = 1;
            end
            
            nRemBnryVctr = zeros(1,length(wholeNightTsVctr));
            for e = 1:size(sleepTypeBnds{2},1)
                tmpBnds = sleepTypeBnds{2}(e,:) .* 60^2;
                nRemStartInd = find(wholeNightTsVctr<=tmpBnds(1), 1, 'Last');
                nRemEndInd = find(wholeNightTsVctr>=tmpBnds(2), 1, 'First');
                nRemBnryVctr(nRemStartInd:nRemEndInd) = 1;
            end
            
            numSampsPerCol = (binWidthInMin*60)*2000;
            numCols = floor(length(nRemBnryVctr)/((binWidthInMin*60)*2000));
            ttlNumSamps = numCols * numSampsPerCol;
            nRemBnryVctr(ttlNumSamps+1:end) = [];
            nRemMtx = reshape(nRemBnryVctr,numSampsPerCol,numCols);
            nRemBinned = sum(nRemMtx,1);
            
            
            figure (distFig);
            subplot(7,1,s);
            hold on;
            
            xVals = 1:length(nRemBinned);
            xVals = (xVals .* binWidthInMin) - binWidthInMin/2;
            xVals = xVals / 60;
            xVals = round(xVals,2);
            bg = bar(xVals, nRemBinned/2000);
            set(bg, 'FaceColor', rgb(stateCols{2}));
            ylabel({'Time in';'non-REM (s)'});
            set(gca, 'XTick', 0:.5:ceil(xVals(end)), 'FontName', 'Arial');
            title(['Session ' num2str(s)]);
            if s == length(region(reg).rat(r).session)
                xlabel('Time (Hrs)');
            end
            xlim([0 3]); 
            
            cd ../../..
        end %ses
        
        
        % Save and close the figures
        tmpDir = pwd;
        cd(saveDir);
        
        savefig(colCodeFig, saveColCodeFigName);
        print(saveColCodeFigName, colCodeFig, '-dpng');
        close(colCodeFig);
        savefig(distFig, saveDistFigName);
        print(saveDistFigName, distFig, '-dpng');
        close(distFig);
        
        cd(tmpDir);
        
        
        cd ..
    end %rat
    
    
    cd ..
end %region



cd (curDir)
end %fnctn




