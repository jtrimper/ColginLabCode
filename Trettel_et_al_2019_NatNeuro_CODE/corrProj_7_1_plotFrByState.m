function region = corrProj_7_1_plotFrByState(region)
% function region = corrProj_7_1_plotFrByState(region)
%
% PURPOSE:
%   Function to calculate firing rates by state for each unit. 
%
% INPUT:
%   region = project uber data structure after it has been passed through
%            at least the first 4 corrProj... functions
%
% OUTPUT:
%   Figures (bargraph and histograms) as well as printed stats.
%
% JBT 8/2017
% Colgin Lab

sleepStateNames = {'REM', 'nREM'}; 

for reg = 1:2
% for reg = 1
    fprintf('%s\n', region(reg).name)
    
      xRatUnitFrInfo = []; 
    
    for r = 1:length(region(reg).rat)
        fprintf('\t%s\n', region(reg).rat(r).name);
        
        xSesUnitFrInfo = []; 
        
        for s = 1:length(region(reg).rat(r).session)
            fprintf('\t\tSession %d\n', s);
            for d = 1
                fprintf('\t\t\tDay %d\n', d);
                
                if reg == 1 %MEC
                    tNum = 2; %Open Field
                else %CA1
                    tNum = 1; %Circular Track
                end
                fprintf('\t\t\t\t%s\n', region(reg).rat(r).session(s).day(d).task(tNum).name)
                
                
                % GET A LIST OF THE UNITS
                %  This is important because if we want to run a RM anova, we need the
                %  units paired. There can't be different numbers in different groups 
                %  and there could be as is because some sleep bouts didn't have all 
                %  the same units
                unitIDs = [];
                for u = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout(1).unit)
                    if region(reg).rat(r).session(s).day(d).task(tNum).bout(1).unit(u).type == 1
                        tmpID = region(reg).rat(r).session(s).day(d).task(tNum).bout(1).unit(u).ID;
                        unitIDs = [unitIDs; tmpID]; %#ok
                    end
                end
                
                
                
                %% FIRST GO THROUGH THE RUN EPOCHS
                unitInfo = []; 
                for b = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout)
                    fprintf('\t\t\t\t\tBout %d\n', b);
                    
                    runEpochBnds = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).runTimes;
                    
                    if ~isempty(runEpochBnds)

                        ttlRunTime = sum(diff(runEpochBnds,[],2));
                        fprintf('\t\t\t\t\t\t%0.04g sec of RUN for this bout.\n', ttlRunTime);
                        
                        for u = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit)
                          
                            if region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u).type ~= 1 %if it's a grid cell/CA1 pyram
                                %                                 fprintf('\t\t\t\t\t\t\tUnit is not a grid cell. Skipping.\n');
                            else
                                
                                spkTms = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u).spkTms;
                                
                                %get only the spikes that occurred during the sleep epochs
                                stateSpks = [];
                                for e = 1:size(runEpochBnds,1)
                                    startTime = runEpochBnds(e,1);
                                    endTime = runEpochBnds(e,2);
                                    
                                    spkInds = find(spkTms>=startTime & spkTms<=endTime);
                                    if ~isempty(spkInds)
                                        stateSpks = [stateSpks; spkTms(spkInds)]; %#ok
                                    end
                                end
                                
                                tmpID = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u).ID;
                                unitInfo = [unitInfo; length(stateSpks) ./ ttlRunTime tmpID]; %#ok - calculate bout FR
                                
                                
                            end %if unit is a grid cell/pyram
                        end %unit
                    end %if there were run epochs for this bout
                end %bout
                
                
                % Match calculcated FRs to their unit IDs
                unitBoutFrs = []; 
                for u = 1:size(unitIDs,1)
                    unitBoutInds = find(unitInfo(:,2) == unitIDs(u,1) & unitInfo(:,3) == unitIDs(u,2));
                    unitBoutFrs(u,1) = mean(unitInfo(unitBoutInds,1)); %#ok - average FR across bouts
                end
                
                %% THEN GO THROUGH THE SLEEP EPOCHS
                tNum = 3;
                fprintf('\t\t\t\t%s\n', region(reg).rat(r).session(s).day(d).task(tNum).name)
                unitInfo = cell(1,2); %one for each sleep state
                for b = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout)
%                     fprintf('\t\t\t\t\tBout %d\n', b);
                   
                        for ss = 1:2
%                             fprintf('\t\t\t\t\t\t%s\n', sleepStateNames{ss});
                            
                            if ss == 1
                                sleepEpochBnds = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).remTimes;
                            else
                                sleepEpochBnds = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).nRemTimes;
                            end
                            
                            if ~isempty(sleepEpochBnds)
                                
                                ttlSleepTime = sum(diff(sleepEpochBnds,[],2));
%                                 fprintf('\t\t\t\t\t\t\t%0.04g sec of %s for this bout.\n', ttlSleepTime, sleepStateNames{ss});
                                
                                
                                % GET SPIKE TIMES FOR UNIT 1
                                for u = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit)
                                    if region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u).type ~= 1 %if it's a grid cell/CA1 pyram
                                        %                                         fprintf('\t\t\t\t\t\t\t\tMEC unit is not a grid cell. Moving on.\n');
                                    else
                                        
                                        spkTms = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u).spkTms;
                                        
                                        %get only the spikes that occurred during the sleep epochs
                                        stateSpks = [];
                                        for e = 1:size(sleepEpochBnds,1)
                                            startTime = sleepEpochBnds(e,1);
                                            endTime = sleepEpochBnds(e,2);
                                            
                                            spkInds = find(spkTms>=startTime & spkTms<=endTime);
                                            if ~isempty(spkInds)
                                                stateSpks = [stateSpks; spkTms(spkInds)]; %#ok
                                            end
                                        end
                                       
                                        tmpID = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u).ID;
                                        unitInfo{ss} = [unitInfo{ss}; length(stateSpks) ./ ttlSleepTime tmpID]; %calculate bout FR
                                        
                                    end %if unit1 is a grid cell/pyram
                                end %unit1
                            else
%                                 fprintf('\t\t\t\t\t\t\tNo %s epochs for this bout.\n', sleepStateNames{ss});
                            end %if there were sleep epochs for this bout
                            
                        end %REM then nREM
                end %bout
                
                
                % Match calculcated FRs to their unit IDs
                for ss = 1:2
                     for u = 1:size(unitIDs,1)
                        unitBoutInds = find(unitInfo{ss}(:,2) == unitIDs(u,1) & unitInfo{ss}(:,3) == unitIDs(u,2));
                        if ~isempty(unitBoutInds)
                            unitBoutFrs(u,ss+1) = mean(unitInfo{ss}(unitBoutInds,1)); %average FR across bouts
                        else
                            unitBoutFrs(u,ss+1) = NaN; 
                        end
                    end
                end
                
                
                
            end %day
            
            xSesUnitFrInfo = [xSesUnitFrInfo; unitBoutFrs]; %#ok -- concatenate across sessions
            xRatUnitFrInfo = [xRatUnitFrInfo; unitBoutFrs]; %#ok -- concatenate across sessions and rats
            
        end %session
        
        unitFrsByRat(r,:) = nanmean(xSesUnitFrInfo,1); %#ok 
        
    end %rat
    
    
    %get rid of units that weren't there for all three states
    badUnits = find(isnan(xRatUnitFrInfo(:,1)) | isnan(xRatUnitFrInfo(:,3)) | isnan(xRatUnitFrInfo(:,2))); 
    if ~isempty(badUnits)
        xRatUnitFrInfo(badUnits,:) = []; %#ok 
    end
    
    %run RM ANOVA
    [A, ~, pEta2] = one_way_rm_anova(xRatUnitFrInfo); 
    
    %run t-tests
    combos = [1 2; 1 3; 2 3]; 
    for c = 1:3
       g1FrData = xRatUnitFrInfo(:,combos(c,1));  
       g2FrData = xRatUnitFrInfo(:,combos(c,2));  
       [~,P,~,STATS] = ttest(g1FrData, g2FrData); 
       difVals = g1FrData - g2FrData; 
       cohD = mean(difVals) / std(difVals); 
       statReg(reg).tTestStats(c,:) = [STATS.df STATS.tstat  P cohD];%#ok
    end
        
    
    statReg(reg).frXUnits = xRatUnitFrInfo; 
    statReg(reg).ANOVA_stats = [A.df A.F A.p pEta2];
    statReg(reg).cellCount = size(xRatUnitFrInfo,1); 
    statReg(reg).avgsAndErr = [mean(xRatUnitFrInfo,1); semfunct(xRatUnitFrInfo,1)]; 
    
    
end %region


% PRINT OUT STATS
stateNames = {'RUN', 'REM', 'NREM'};
fprintf('\n\n\n\nSTATS:\n');
for reg = 1:2
    fprintf('\t%s\n', region(reg).name);
    fprintf('\t\t# Units: %d\n', statReg(reg).cellCount);
    fprintf('\t\tAvgs +/- SEM:\n');
    for s = 1:3
        fprintf('\t\t\t%s: %0.04g +/- %0.04g Hz\n', stateNames{s}, statReg(reg).avgsAndErr(1,s), statReg(reg).avgsAndErr(2,s));
    end
    fprintf('\t\tRM ANOVA Stats:\n');
    tmpStats = statReg(reg).ANOVA_stats;
    fprintf('\t\t\tF(%d,%d) = %0.04g, p = %0.04g, pEta2 = %0.04g\n', tmpStats)
    
    
    fprintf('\t\tT-TEST STATS:\n');
    for c = 1:3
        fprintf('\t\t\t%s vs %s: t(%d) = %0.04f, p = %d, d = %0.04f\n\n',...
            stateNames{combos(c,1)}, stateNames{combos(c,2)}, statReg(reg).tTestStats(c,:));
    end
end


% PLOT AVERAGE FIRING RATE BY STATE AND REGION
figure('name', 'Firing Rate By Region and State', 'Position', [  320   408   967   420]); 
stateCols = {'Green', 'Gold', 'Purple'};
for reg = 1:2
    subplot(1,2,reg); 
    hold on; 
    avgAndErr = statReg(reg).avgsAndErr;
    for s = 1:3
        bg = bar(s,avgAndErr(1,s)); 
        set(bg, 'FaceColor', rgb(stateCols{s}))
    end
    errorbar(1:3, avgAndErr(1,:), avgAndErr(2,:), 'k', 'LineStyle', 'none'); 
    set(gca, 'XTick', 1:3, 'XTickLabel', stateNames, 'FontName', 'Arial')
    ylim([0 2.2]); 
    set(gca, 'YTick', 0:.5:2); 
    title(region(reg).name); 
    if reg == 1
        ylabel('Firing Rate (Hz)'); 
    end
end

%PLOT DISTRIBUTIONS OF FIRING RATES ACROSS NEURONS
figure('name', 'Firing Rate Distributions', 'Position', [560   224   608   724]);
for reg = 1:2
    for s = 1:3
        subplot(3,2,(s-1)*2+reg);
        hold on;
        [cnts,edges] = histcounts(statReg(reg).frXUnits(:,s), 'BinWidth', .25, 'BinLimits', [0 6]);
        edges = edges(2:end) - (mean(diff(edges))/2);
        bg = bar(edges, cnts);
        set(bg, 'FaceColor', rgb(stateCols{s}));
        
        xlim([-.125 6]);
        ylim([0 40]);
        set(gca, 'XTick', 0:2:6, 'YTick', 0:20:70, 'FontName', 'Arial')
        
        if s == 1
            title(region(reg).name);
        elseif s == 3
            xlabel('Firing Rate (Hz)'); 
        end
        
        if reg == 1
            ylabel('Count');
        end
    end
end


end %fnctn

