function pairType = corrProj_9_5_reduceSpatMetsForHDModCellPairs(region)
% function pairType = corrProj_9_5_reduceSpatMetsForHDModCellPairs(region)
%
% PURPOSE:
%  This function will get all the cross-corr measures and spatial measures and head direction measures
%  you need to do further analysis based on cellPair for six different types of pairings
%                  [GC = grid cell; CJ = conjunctive; HD = head direction]
%    1 = GC/GC 
%    2 = GC/CJ
%    3 = CJ/CJ
%    4 = CJ/HD
%    5 = GC/HD
%    6 = HD/HD
%
% INPUT:
%   region = project uber data structure
%
% OUTPUT:
%   pairType = the structure holding all the info you need for further analyses
%
% JBT 1/2018
% Colgin Lab



stateNames = {'RUN', 'REM', 'nREM'};
pairTypeNames = {'GC/GC', 'GC/CJ', 'CJ/CJ', 'CJ/HD', 'GC/HD', 'HD/HD'};
pairType = struct;
for pt = 1:6
    pairType(pt).name = pairTypeNames{pt};
end

reg = 1; %MEC only
d = 1; %Day 1

cpCntr = zeros(1,6);
badPairs = cell(1,6);

pkCcBadPairs = cell(1,6);
sameTetBadPairs = cell(1,6);
spatPerBadPairs = cell(1,6);

getAngs = 0;

for r = 1:length(region(reg).rat)
    fprintf('%s\n', region(reg).rat(r).name);
    for s = 1:length(region(reg).rat(r).session)
        fprintf('\tSession %d\n', s);
        if ~isempty(region(reg).rat(r).session(s).state) %one rat only had 1 cell on one of the days, so there is no data there
            
            %Get a list of the unit IDs for pulling their head direction info
            t = 2; %Open field
            b = 1; %1st begin bout
            hdModUnits = [];
            for u = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit)
                if region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).hdMod == 1
                    uID = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).ID;
                    uType = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).type;
                    hdModUnits = [hdModUnits; u uID uType]; %#ok
                    
                    if getAngs == 0
                        getAngs = 1;
                        distAngs = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).spkHDDist(:,1);
                    end
                    
                end
            end %unit
            
            
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
                fprintf('\t\t\t\tCell Pair %d\n', cp);
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
                            u2TetNum = unitInfo(2,1);
                            u2UnitNum = unitInfo(2,2);
                            u2Type = unitInfo(2,3);
                            
                            if ~isempty(hdModUnits)
                                u1HdModLgcl = ismember(hdModUnits(:,2:end), [u1TetNum u1UnitNum u1Type], 'rows');
                                u1HdMod = sum(u1HdModLgcl);
                                if u1HdMod == 1
                                    u1InSesUnitNum = hdModUnits(u1HdModLgcl,1);
                                end
                                
                                u2HdModLgcl = ismember(hdModUnits(:,2:end), [u2TetNum u2UnitNum u2Type], 'rows');
                                u2HdMod = sum(u2HdModLgcl);
                                if u2HdMod == 1
                                    u2InSesUnitNum = hdModUnits(u2HdModLgcl,1);
                                end
                                
                            else
                                u1HdMod = 0;
                                u2HdMod = 0;
                            end
                            
                            pt = 0;
                            if tmpPairType == 1 %GC/GC
                                if u1HdMod + u2HdMod == 0
                                    pt = 1; %GC/GC
                                elseif u1HdMod + u2HdMod == 1
                                    pt = 2; %GC/CJ
                                elseif u1HdMod + u2HdMod == 2
                                    pt = 3; %CJ/CJ
                                end
                            elseif tmpPairType == 2 %GC/nGC
                                if u1HdMod + u2HdMod == 2
                                    pt = 4; %CJ/HD
                                elseif u1Type == 1 && u1HdMod == 0 && u2Type == 2 && u2HdMod == 1
                                    pt = 5; %GC/HD
                                elseif u1Type == 2 && u1HdMod == 1 && u2Type == 1 && u2HdMod == 0
                                    pt = 5; %HD/GC
                                end
                            elseif tmpPairType == 3 %nGC/nGC
                                if u1HdMod + u2HdMod == 2
                                    pt = 6; %HD/HD
                                end
                            end
                            
                            
                            if pt == 0
                                badFlag = 1;
                                fprintf('\t\t\t\t\t\tPair did not fit in any pre-defined group.\n');
                            else
                                cpCntr(pt) = cpCntr(pt) + 1;
                                pairType(pt).cellPair(cpCntr(pt)).info = [r s cp u1TetNum u1UnitNum u2TetNum u2UnitNum]; %[rat# ses# wInSesCellPair# ...]
                            end
                            
                        end
                        
                        
                        
                        if badFlag == 1 %if the pair was flagged, in a previous state, as a bad pair based on minimum spike count in non-norm spike cross corr
                            break
                        else
                            fprintf('\t\t\t\t\t\t%s\n', stateNames{ss});
                            
                            
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
                            
                            if pt <= 3 %GET SPATIAL METRICS IF IT'S A GC/GC, GC/CJ, OR CJ/CJ PAIR
                                
                                % FOR RATE MAP CORRELATION COEFFICIENTS, GET THE MEDIAN ACROSS BOUTS
                                pairType(pt).cellPair(cpCntr(pt)).state(ss).rmCorrCoeffs = region(reg).rat(r).session(s).state(1).cellPair(cp).rmCorrCoeffs;
                                
                                
                                % FOR RATE MAP CROSS CORRELATIONS, GET THE MEDIAN ACROSS BOUTS
                                pairType(pt).cellPair(cpCntr(pt)).state(ss).rmXCorr = region(reg).rat(r).session(s).state(1).cellPair(cp).rmXCorr;
                                
                                
                                % FOR RELATIVE SPATIAL PHASE, GET THE MEDIAN ACROSS BOUTS
                                %   2D
                                pairType(pt).cellPair(cpCntr(pt)).state(ss).relSpatPhi2D = region(reg).rat(r).session(s).state(1).cellPair(cp).relSpatPhi;
                                %   1D
                                pairType(pt).cellPair(cpCntr(pt)).state(ss).relSpatPhiMag = region(reg).rat(r).session(s).state(1).cellPair(cp).spatPhiMag;
                                
                                
                                % FOR GRID SIZE, GET THE AVERAGE ACROSS BOUTS
                                pairType(pt).cellPair(cpCntr(pt)).state(ss).gridSize = region(reg).rat(r).session(s).state(1).cellPair(cp).gridSize;
                                
                                
                                % GET SPATIAL PERIOD RATIO
                                spatPerRatio = region(reg).rat(r).session(s).state(1).cellPair(cp).spatPerRatio;
                                pairType(pt).cellPair(cpCntr(pt)).state(ss).spatPerRatio = spatPerRatio;
                                
                                if spatPerRatio < 0.7  %if grid cell sizes are not within 30% of one another, discard this grid cell
                                    badPairs{pt} = [badPairs{pt} cpCntr(pt)];
                                    spatPerBadPairs{pt} = [spatPerBadPairs{pt} cpCntr(pt)];
                                end
                                
                            end
                            
                            if pt == 3 || pt == 4 || pt == 6 %GET HEAD DIRECTION INFORMATION IF IT'S AN HD MOD CELL PAIR
                                
                                % GET FIRING RATE X HEAD DIRECTION DISTRIBUTION
                                hdDists = zeros(60,2,2);
                                for b = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout)
                                    hdDists(:,:,1) = hdDists(:,:,1) + region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u1InSesUnitNum).spkHDDist(:,2:3);
                                    hdDists(:,:,2) = hdDists(:,:,2) + region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u2InSesUnitNum).spkHDDist(:,2:3);
                                end
                                frDist = squeeze(hdDists(:,2,:) ./ hdDists(:,1,:));
                                
                                % GET WEIGHTED CIRCULAR AVERAGE OF PREFERRED FIRING ANGLE
                                wAvg = zeros(1,size(frDist,2));
                                for u = 1:size(frDist,2)
                                    frAngs = [];
                                    for a = 1:size(frDist,1)
                                        frAngs = [frAngs repmat(distAngs(a), 1, round(frDist(a,u) .* 10^4))]; %#ok
                                    end
                                    wAvg(u) = circ_mean(frAngs');
                                end
                                
                                % FIND THE RATIO OF PREFERRED PHASE (0 = 0* apart; 1 = 180* apart)
                                phiDifRatio = abs(circ_dist(wAvg(1), wAvg(2))/pi);
                                pairType(pt).cellPair(cpCntr(pt)).state(ss).phiDifRatio = phiDifRatio;
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
for pt = 1:6
    if ~isempty(badPairs{pt})
        pairType(pt).cellPair(badPairs{pt}) = [];
    end
    fprintf('\t%s: %d good cell pairs\n', pairType(pt).name, length(pairType(pt).cellPair)); 
    fprintf('\t\t\t%d pairs removed because same tetrode\n', length(sameTetBadPairs{pt})); 
    fprintf('\t\t\t%d pairs removed because different modules\n', length(spatPerBadPairs{pt})); 
    fprintf('\t\t\t%d pairs removed because low peak cross correlation\n', length(pkCcBadPairs{pt})); 
end



end %fnctn
