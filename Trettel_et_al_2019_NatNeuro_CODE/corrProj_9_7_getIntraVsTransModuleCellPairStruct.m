function modGrouping = corrProj_9_7_getIntraVsTransModuleCellPairStruct(region)
% function modGrouping = corrProj_9_7_getIntraVsTransModuleCellPairStruct(region)
%
% PURPOSE:
%   Thus far, all metrics for cell pairs have been calculated and stored separately for each bout.
%   Here, I'm going to do all the averaging/medianing/separating/whatever to get everything in the right
%   format for plotting and running the final analyses.
%     THIS FUNCTION DOES THIS SEPARATELY FOR INTRA- vs TRANS-MODULE MEC GRID CELL PAIRS
%
% INPUT:
%   region = project uber data structure
%
% OUTPUT:
%   modGrouping = data structure, for just MEC, splitting intra- (1) and trans-modular (2) cell pairs
%
% JBT 8/2017
% Colgin Lab


stateNames = {'RUN', 'REM', 'nREM'};
cellPair = struct;

reg = 1;

fprintf('%s\n', region(reg).name)

cpCntr = 1;
sameTetBadPairs = [];
spatPerBadPairs = [];
noSpksBadPairs = [];

for r = 1:length(region(reg).rat)
    fprintf('\t%s\n', region(reg).rat(r).name);
    for s = 1:length(region(reg).rat(r).session)
        fprintf('\t\tSession %d\n', s);
        for d = 1
            fprintf('\t\t\tDay %d\n', d);
            
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
                    fprintf('\t\t\t\tCell Pair %d\n', cp);
                    badFlag = 0;
                    for ss = 1:3
                        fprintf('\t\t\t\t\t%s\n', stateNames{ss});
                        
                        if badFlag ~= 1 %if the pair was flagged, in a previous state, as a bad pair based on minimum spike count in non-norm spike cross corr
                            
                            if ss == 1
                                % STORE IDENTIFYING INFO FOR EACH CELL PAIR
                                unitInfo = region(reg).rat(r).session(s).state(ss).cellPair(cp).unitIDs;
                                u1TetNum = unitInfo(1,1);
                                u1UnitNum = unitInfo(1,2);
                                u2TetNum = unitInfo(2,1);
                                u2UnitNum = unitInfo(2,2);
                                
                                cellPair(cpCntr).info = [r s cp u1TetNum u1UnitNum u2TetNum u2UnitNum]; %[rat# ses# wInSesCellPair# ...]
                            end
                            
                            % SUM THE NON-NORMALIZED CROSS CORRELATIONS ACROSS BOUTS
                            for bs = 1:4
                                stXCorrVals = zeros(length(region(reg).rat(r).session(s).state(1).cellPair(cp).stXCorr{1}{bs}),1);
                                for b = 1:length(region(reg).rat(r).session(s).state(ss).cellPair(cp).stXCorr)
                                    if ~isempty(region(reg).rat(r).session(s).state(ss).cellPair(cp).stXCorr{b})
                                        stXCorrVals = stXCorrVals + region(reg).rat(r).session(s).state(ss).cellPair(cp).stXCorr{b}{bs}';
                                    end
                                end
                                cellPair(cpCntr).state(ss).stXCorr{bs} = stXCorrVals;
                                
                                
                                %if units were on the same tetrode, then ask if the center bin for the spike-time cross correlation,
                                % binned into 2ms bins, is greater than the average across the cross-correlation. If it is, flag
                                % the pair as a bad pair to be thrown out
                                if u1TetNum == u2TetNum
                                    if bs == 1
                                        avgStXCorr = mean(stXCorrVals);
                                        ctrBinInd = median(1:length(stXCorrVals)); %i.e., 2501
                                        if stXCorrVals(ctrBinInd) > avgStXCorr
                                            badFlag = 1;
                                            sameTetBadPairs = [sameTetBadPairs cpCntr]; %#ok
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
                                cellPair(cpCntr).state(ss).normStXCorr{bs} = normStXCorr;
                                
                                if bs == 1
                                    midSum = zeros(1,2);
                                    if ~isempty(normStXCorr)
                                        
                                        %sum over middle 5 bins
                                        tmpInds = median(1:length(normStXCorr))-2:median(1:length(normStXCorr))+2;
                                        midSum(1) = sum(normStXCorr(tmpInds));
                                        
                                        %sum over middle 50 bins
                                        
                                        tmpInds = median(1:length(normStXCorr))-25:median(1:length(normStXCorr))+25;
                                        midSum(2) = sum(normStXCorr(tmpInds));
                                    else
                                        badFlag = 1;
                                        noSpksBadPairs = [noSpksBadPairs cpCntr]; %#ok
                                    end
                                    
                                    cellPair(cpCntr).state(ss).midSum = midSum;
                                end
                                
                                clear normStXCorr;
                                
                            end
                            
                            
                            if ss == 1
                                
                                % FOR RATE MAP CORRELATION COEFFICIENTS, GET THE MEDIAN ACROSS BOUTS
                                cellPair(cpCntr).state(ss).rmCorrCoeffs = region(reg).rat(r).session(s).state(1).cellPair(cp).rmCorrCoeffs;
                                
                                
                                % FOR RATE MAP CROSS CORRELATIONS, GET THE MEDIAN ACROSS BOUTS
                                cellPair(cpCntr).state(ss).rmXCorr = region(reg).rat(r).session(s).state(1).cellPair(cp).rmXCorr;
                                
                                
                                % FOR RELATIVE SPATIAL PHASE, GET THE MEDIAN ACROSS BOUTS
                                %   2D
                                cellPair(cpCntr).state(ss).relSpatPhi2D = region(reg).rat(r).session(s).state(1).cellPair(cp).relSpatPhi;
                                %   1D
                                cellPair(cpCntr).state(ss).relSpatPhiMag = region(reg).rat(r).session(s).state(1).cellPair(cp).spatPhiMag;
                                
                                
                                % FOR GRID SIZE, GET THE AVERAGE ACROSS BOUTS
                                cellPair(cpCntr).state(ss).gridSize = region(reg).rat(r).session(s).state(1).cellPair(cp).gridSize;
                                
                                
                                % GET SPATIAL PERIOD RATIO
                                spatPerRatio = region(reg).rat(r).session(s).state(1).cellPair(cp).spatPerRatio;
                                cellPair(cpCntr).state(ss).spatPerRatio = spatPerRatio;
                                
                                if spatPerRatio < 0.7  %if grid cell sizes are not within 30% of one another, discard this grid cell pair
                                    spatPerBadPairs = [spatPerBadPairs cpCntr]; %#ok
                                end
                                
                                
                            end
                            
                            
                        end %if cell spike-count > 5 for non-norm cross-corr
                    end %state (RUN,REM,nREM)
                    cpCntr = cpCntr + 1;
                end %cell pair
            end %if there is data for this state
        end %day
        
    end %session
end %rat


%Set up to separate all the intra- vs trans-module cell pairs
modGrouping(1).cellPair = cellPair;

%Get rid of trans-modular pairs that were disqualified for being on the same tetrode or having no spikes at all in the xCorr
spatPerBadPairs(ismember(spatPerBadPairs, [sameTetBadPairs noSpksBadPairs])) = [];

%Group the trans-modular cell pairs
modGrouping(2).cellPair = cellPair(spatPerBadPairs);

%Get rid of cell pairs in the intra-struct struct that didn't pass exclusionary criteria
modGrouping(1).cellPair(unique([spatPerBadPairs sameTetBadPairs noSpksBadPairs])) = [];



end
