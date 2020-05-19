function pairType = corrProj_9_14_reduceMetricsForGridAndNonGridPairs(region)
% function pairType = corrProj_9_14_reduceMetricsForGridAndNonGridPairs(region)
%
% PURPOSE:
%  This function will get  the spatial corr and cross-corr measures you need to do further analysis based on cellPair
%  for three different types of cell pairings
%                  [GC = grid cell (includes conjunctive); nGC = non-grid cell (does NOT include head direction)]
%    1 = GC/GC
%    2 = GC/nGC
%    3 = nGC/nGC
%
% INPUT:
%   region = project uber data structure that just went through 9_12 and 9_13
%
% OUTPUT:
%   pairType = the structure holding all the info you need for further analyses
%
% JBT 1/2018
% Colgin Lab



pairTypeNames = {'GC/GC', 'GC/nGC', 'nGC/nGC'};
pairType = struct;
for pt = 1:3
    pairType(pt).name = pairTypeNames{pt};
end

reg = 1; %MEC only
d = 1; %Day 1
t = 2; %Open Field

cpCntr = zeros(1,3);
badPairs = cell(1,3);

pkCcBadPairs = cell(1,3);
sameTetBadPairs = cell(1,3);
spatPerBadPairs = [];

for r = 1:length(region(reg).rat)
    fprintf('%s\n', region(reg).rat(r).name);
    for s = 1:length(region(reg).rat(r).session)
        fprintf('\tSession %d\n', s);
        
        
        % For non-grid cells, get list of cell IDs and whether they're HD mod or not
        b = 1; %for getting list, just use bout 1
        nGcHDModList = [];
        for u = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit)
            uID = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).ID;
            uType = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).type;
            if uType == 2
                uHDMod = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).hdMod;
                if isempty(uHDMod) %there was an error in corrProj_9_3... that didn't match up IDs correctly so that led to some empties.
                    %               I checked all the polar plots and it doesn't make a difference though. These 3 or so units are all not HD mod.
                    
                    uHDMod = 0;
                end
                nGcHDModList = [nGcHDModList; uID uHDMod]; %#ok
            end
        end
        
        
        
        if ~isempty(region(reg).rat(r).session(s).state) %one rat only had 1 cell on one of the days, so there is no data there
            
            % # of cell pairs might not be even across all states, since sometimes cells didn't fire during sleep, so figure out the min #
            %   NOTE: Order of cell pairs is the same across all states
            numCps = [0 0 0];
            for ss = 1:3
                numCps(ss) = length(region(reg).rat(r).session(s).state(ss).cellPair);
                if numCps(ss) == 0
                    break
                end
            end
            numCps = min(numCps);
            
            for cp = 1:numCps
                %                 fprintf('\t\t\t\tCell Pair %d\n', cp);
                badFlag = 0;
                for ss = 1:3
                    
                    if badFlag ~= 1 %if the pair was flagged, in a previous state, as a bad pair based on minimum spike count in non-norm spike cross corr
                        
                        if ss == 1
                            % STORE IDENTIFYING INFO FOR EACH CELL PAIR
                            unitInfo = region(reg).rat(r).session(s).state(ss).cellPair(cp).unitIDs;
                            
                            tmpPairType = region(reg).rat(r).session(s).state(ss).cellPair(cp).pairType;
                            
                            u1TetNum = unitInfo(1,1);
                            u1UnitNum = unitInfo(1,2);
                            u1Type = unitInfo(1,3);
                            u1HdMod = 0; %assume no, since if it's a grid cell we don't care and won't check
                            if u1Type == 2
                                u1HdMod = nGcHDModList(nGcHDModList(:,1)==u1TetNum  &  nGcHDModList(:,2)==u1UnitNum,3);
                            end
                            
                            u2TetNum = unitInfo(2,1);
                            u2UnitNum = unitInfo(2,2);
                            u2Type = unitInfo(2,3);
                            u2HdMod = 0;
                            if u2Type == 2
                                u2HdMod = nGcHDModList(nGcHDModList(:,1)==u2TetNum  &  nGcHDModList(:,2)==u2UnitNum,3);
                            end
                            
                            
                            pt = 0;
                            if tmpPairType == 1 %GC/GC
                                pt = 1;
                            elseif tmpPairType == 2  &  u2HdMod == 0 %GC/nGC
                                %Unit 1 will never be the nGC in this situation so no need to check it for HD mod (cuz we're including conjunctive as grid cells)
                                pt = 2;
                            elseif tmpPairType == 3  &  u1HdMod == 0  &  u2HdMod == 0%nGC/nGC
                                pt = 3;
                            end
                            
                            
                            if pt == 0
                                badFlag = 1;
                                %                                 fprintf('\t\t\t\t\t\tPair did not fit in any pre-defined group.\n');
                            else
                                cpCntr(pt) = cpCntr(pt) + 1;
                                pairType(pt).cellPair(cpCntr(pt)).info = [r s cp u1TetNum u1UnitNum u2TetNum u2UnitNum]; %[rat# ses# wInSesCellPair# ...]
                            end
                            
                        end
                        
                        
                        
                        if badFlag == 1 %if the pair was flagged, in a previous state, as a bad pair based on minimum spike count in non-norm spike cross corr
                            break
                        else
                            %                             fprintf('\t\t\t\t\t\t%s\n', stateNames{ss});
                            
                            
                            % SUM THE NON-NORMALIZED CROSS CORRELATIONS ACROSS BOUTS
                            for bs = 1:4
                                stXCorrVals = zeros(length(region(reg).rat(r).session(s).state(1).cellPair(cp).stXCorr{1}{bs}),1);
                                for b = 1:length(region(reg).rat(r).session(s).state(ss).cellPair(cp).stXCorr)
                                    if ~isempty(region(reg).rat(r).session(s).state(ss).cellPair(cp).stXCorr{b})
                                        stXCorrVals = stXCorrVals + region(reg).rat(r).session(s).state(ss).cellPair(cp).stXCorr{b}{bs}';
                                    end
                                end
                                pairType(pt).cellPair(cpCntr(pt)).state(ss).stXCorr{bs} = stXCorrVals;
                                
                                %check to make sure there was a peak cross-correlation of at least 5 spikes
                                if bs == 1
                                    maxVal = max(stXCorrVals);
                                    if maxVal < 5
                                        badPairs{pt} = [badPairs{pt} cpCntr(pt)]; %if not, mark it as a bad pair, don't continue going through the data for this pair
                                        badFlag = 1;
                                        pkCcBadPairs{pt} = [pkCcBadPairs{pt} cpCntr(pt)];
                                    end
                                end
                                
                                %if units were on the same tetrode, then ask if the center bin for the spike-time cross correlation,
                                % binned into 2ms bins, is greater than the average across the cross-correlation. If it is, flag
                                % the pair as a bad pair to be thrown out
                                if u1TetNum == u2TetNum
                                    if bs == 1
                                        avgStXCorr = mean(stXCorrVals);
                                        ctrBinInd = median(1:length(stXCorrVals)); %i.e., 2501
                                        if stXCorrVals(ctrBinInd) > avgStXCorr
                                            badPairs{pt} = [badPairs{pt} cpCntr(pt)]; %if not, mark it as a bad pair, don't continue going through the data for this pair
                                            badFlag = 1;
                                            sameTetBadPairs{pt} = [sameTetBadPairs{pt} cpCntr(pt)];
                                        end
                                    end
                                end
                                
                            end
                            clear stXCorrVals
                        end
                        
                        
                        if badFlag ~= 1 %if the pair was flagged, within this state, as a bad pair based on minimum spike count in non-norm spike cross corr
                            
                            
                            % AVERAGE THE NORMALIZED SPIKE TIME CROSS CORRELATIONS ACROSS BOUTS
                            %  And sum across the middle bins
                            for bs = 1:4
                                normStXCorr = [];
                                for b = 1:length(region(reg).rat(r).session(s).state(ss).cellPair(cp).normStXCorr)
                                    if ~isempty(region(reg).rat(r).session(s).state(ss).cellPair(cp).normStXCorr{b})
                                        normStXCorr = [normStXCorr; region(reg).rat(r).session(s).state(ss).cellPair(cp).normStXCorr{b}{bs}]; %#ok
                                    end
                                end
                                normStXCorr = nanmean(normStXCorr,1);
                                pairType(pt).cellPair(cpCntr(pt)).state(ss).normStXCorr{bs} = normStXCorr;
                                
                                if bs == 1 %2 ms bin
                                    midSum = zeros(1,2);
                                    
                                    %sum over middle 5 bins
                                    tmpInds = median(1:length(normStXCorr))-2:median(1:length(normStXCorr))+2;
                                    midSum(1) = sum(normStXCorr(tmpInds));
                                    
                                    %sum over middle 50 bins
                                    tmpInds = median(1:length(normStXCorr))-25:median(1:length(normStXCorr))+25;
                                    midSum(2) = sum(normStXCorr(tmpInds));
                                    
                                    pairType(pt).cellPair(cpCntr(pt)).state(ss).midSum = midSum;
                                end
                                clear normStXCorr;
                            end
                            
                        end
                        
                        
                        if ss == 1
                            
                            % FOR RATE MAP CORRELATION COEFFICIENTS, GET THE MEDIAN ACROSS BOUTS
                            pairType(pt).cellPair(cpCntr(pt)).state(ss).rmCorrCoeffs = region(reg).rat(r).session(s).state(1).cellPair(cp).rmCorrCoeffs;
                            
                            
                            % FOR RATE MAP CROSS CORRELATIONS, GET THE MEDIAN ACROSS BOUTS
                            pairType(pt).cellPair(cpCntr(pt)).state(ss).rmXCorr = region(reg).rat(r).session(s).state(1).cellPair(cp).rmXCorr;
                            
                            if pt == 1
                                % GET SPATIAL PERIOD RATIO
                                spatPerRatio = region(reg).rat(r).session(s).state(1).cellPair(cp).spatPerRatio;
                                pairType(pt).cellPair(cpCntr(pt)).state(ss).spatPerRatio = spatPerRatio;
                                
                                if spatPerRatio < 0.7  %if grid cell sizes are not within 30% of one another, discard this grid cell pair
                                    badPairs{pt} = [badPairs{pt} cpCntr(pt)];
                                    spatPerBadPairs = [spatPerBadPairs cpCntr(pt)]; %#ok
                                end
                            end
                            
                            
                            
                        end %if RUN
                        
                    end %badFlag
                end %sub-state
            end %cellpairs
        end %any cells at all
    end %ses
end %rat



% GET RID OF BAD PAIRS
fprintf('\n\nRESULTS:\n');
for pt = 1:3
    if ~isempty(badPairs{pt})
        pairType(pt).cellPair(badPairs{pt}) = [];
    end
    fprintf('\t%s: %d good cell pairs\n', pairType(pt).name, length(pairType(pt).cellPair));
    fprintf('\t\t\t%d pairs removed because same tetrode\n', length(sameTetBadPairs{pt}));
    fprintf('\t\t\t%d pairs removed because low peak cross correlation\n', length(pkCcBadPairs{pt}));
    if pt == 1
        fprintf('\t\t\t%d pairs removed because of low spatial period ratio\n', length(spatPerBadPairs));
    end
end



end %fnctn
