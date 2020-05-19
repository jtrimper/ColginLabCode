function region = corrProj_9_13_calcSpatialMetricsForAllCellPairs(region)
% function region = corrProj_9_13_calcSpatialMetricsForAllCellPairs(region)
%
% PURPOSE:
%  To calculate spatial correlations for pairs of grid cells with non-grid cells and non-grid cell pairs.
%
% INPUT:
%  region = uber data struct (12/30/17 vers) that was then run through corrProj_9_12...
%           NOTE: It has to go through 9_12 right before it goes through this because the structure is
%                 too big to save after 9_12 so I can't just specify you load that version then run it.
%
% OUTPUT:
%  region = same as input, but with many additional fields added to the cell pair field for state(1) [i.e., REM]
%             New fields:
%               - rateMaps = self explanatory
%               - rmCorr = rate map correlation coefficient
%               - rmAutoCorr = auto-correlation maps for each unit
%               - rmXCorr = cross-correlation map
%
% JB Trimper
% 5/25/2018
% Colgin Lab



curDir = pwd;
dataDir = 'C:\Users\John Trimper\Desktop\LAB_STUFF\PROJECTS\Grid_Cell_Correlations_TrettelProj\CORR_PROJECT_RERUN\DATASET\MEC';
cd(dataDir);

reg = 1; %MEC only
tNum = 2; %Open Field

for r = 1:length(region(reg).rat)
    fprintf('\t%s\n', region(reg).rat(r).name);
    cd(region(reg).rat(r).name)
    for s = 1:length(region(reg).rat(r).session)
        fprintf('\t\tSession %d\n', s);
        cd(['Session' num2str(s)])
        for d = 1
            fprintf('\t\t\tDay %d\n', d);
            cd(['Day' num2str(d)])
            
            cd(region(reg).rat(r).session(s).day(d).task(tNum).name);
            
            
            %% GET A LIST OF ALL POSSIBLE GC/nGC and nGC/nGC CELL PAIRS
            cellPairList = [];
            cellPair = struct();
            cpCntr = 1;
            for u1 = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout(1).unit)
                u1Type = region(reg).rat(r).session(s).day(d).task(tNum).bout(1).unit(u1).type;
                u1ID = region(reg).rat(r).session(s).day(d).task(tNum).bout(1).unit(u1).ID;
                for u2 = u1+1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout(1).unit)
                    u2Type = region(reg).rat(r).session(s).day(d).task(tNum).bout(1).unit(u2).type;
                    u2ID = region(reg).rat(r).session(s).day(d).task(tNum).bout(1).unit(u2).ID;
                    if u2Type == 2
                        cellPairList(:,:,cpCntr) = [u1ID u1Type; u2ID u2Type]; %#ok
                        cpCntr = cpCntr + 1;
                    end
                end
            end
            
            
            %% GET THE SPATIAL METRICS FROM THE OPEN FIELD BOUTS
            for b = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout)
                fprintf('\t\t\t\tBout %d\n', b);
                cd(['Begin' num2str(b)]);
                
                runEpochBnds = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).runTimes;
                
                if ~isempty(runEpochBnds)
                    
                    % GET SPATIAL METRICS FOR UNIT 1
                    for u1 = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit)
                        u1ID = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u1).ID;
                        u1Type = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u1).type;
                        
                        %get the ratemap
                        u1Rm = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u1).rateMap;
                        
                        %rate map auto-correlation
                        u1AutoCorr = rateMapXCorr(u1Rm, u1Rm);
                        
                        %vectorize the rate map and remove nans
                        u1RmVctr = u1Rm(:);
                        u1RmVctr(isnan(u1RmVctr)) = [];
                        
                        
                        % GET SPATIAL METRICS FOR UNIT 2, THEN FOR THE PAIR
                        for u2 = u1+1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit)
                            
                            u2ID = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u2).ID; %get unit 2 ID
                            u2Type = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u2).type;
                            
                            if u2Type ~= 1 %if it's NOT a grid cell
                                
                                %get the ratemap
                                u2Rm = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u2).rateMap;
                                
                                %calculate rate-map cross correlation
                                rmXCorr = rateMapXCorr(u1Rm, u2Rm);
                                
                                %rate map auto-correlation
                                u2AutoCorr = rateMapXCorr(u2Rm, u2Rm);
                                
                                %vectorize the rate map and remove nans
                                u2RmVctr = u2Rm(:);
                                u2RmVctr(isnan(u2RmVctr)) = [];
                                
                                % calculate rate-map correlation coefficient
                                corrMat = corrcoef(u1RmVctr,u2RmVctr);
                                rmCorr = corrMat(2,1); % take off-diagonal value
                                
                                % find out which cell pair this is in the list
                                cpInd = find(cellPairList(1,1,:)==u1ID(1) & cellPairList(1,2,:)==u1ID(2) & cellPairList(1,3,:)==u1Type ...
                                    & cellPairList(2,1,:)==u2ID(1) & cellPairList(2,2,:)==u2ID(2) & cellPairList(2,3,:)==u2Type);
                                
                                %store all the variables we might need
                                cellPair(cpInd).unitIDs(:,:,b) = [u1ID u1Type; u2ID u2Type];
                                cellPair(cpInd).rmCorr(b) = rmCorr;
                                
                                cellPair(cpInd).rateMaps(:,:,1,b) = u1Rm;
                                cellPair(cpInd).rateMaps(:,:,2,b) = u2Rm;
                                cellPair(cpInd).rmAutoCorr(:,:,1,b) = u1AutoCorr;
                                cellPair(cpInd).rmAutoCorr(:,:,2,b) = u2AutoCorr;
                                cellPair(cpInd).rmXCorr(:,:,b) = rmXCorr;
                                
                            end %if unit2 is a grid cell/pyram
                        end %unit2
                    end %unit1
                end %if there were run epochs for this bout
                
                cd ../
            end %bout
            cd ../
            
            
            %% REDUCE THE METRICS ACROSS BOUTS (i.e., median/average)
            if ~isempty(cellPairList)
                
                % Get a list of all cell pair IDs for the session so that you can match up the new cell pair list (only containing GC/nGC pairs)
                %  to the one you already have in the main data struct
                allCPIDs = [];
                for cp = 1:length(region(reg).rat(r).session(s).state(1).cellPair)
                    allCPIDs = cat(3,allCPIDs, region(reg).rat(r).session(s).state(1).cellPair(cp).unitIDs);
                end
                
                
                for cp = 1:length(cellPair)
                    
                    % Match the GC/nGC pair you just got data for with the current list
                    u1ID = cellPairList(1,:,cp);
                    u2ID = cellPairList(2,:,cp);
                    cpInd = find(allCPIDs(1,1,:) == u1ID(1) & allCPIDs(1,2,:) == u1ID(2) & allCPIDs(1,3,:) == u1ID(3) &...
                        allCPIDs(2,1,:) == u2ID(1) & allCPIDs(2,2,:) == u2ID(2) & allCPIDs(2,3,:) == u2ID(3));
                    
                    % STORE UNIT PAIR INFO
                    region(reg).rat(r).session(s).state(1).cellPair(cpInd).unitIDs = cellPair(cp).unitIDs(:,:,1); %same for every bout (3rd d)
                    
                    % STORE RATE MAPS
                    region(reg).rat(r).session(s).state(1).cellPair(cpInd).rateMaps = cellPair(cp).rateMaps;
                    
                    % FOR RATE MAP CORRELATION COEFFICIENTS, TAKE THE MEDIAN ACROSS BOUTS
                    region(reg).rat(r).session(s).state(1).cellPair(cpInd).rmCorrCoeffs = median(cellPair(cp).rmCorr);
                    
                    % FOR RATE MAP CROSS CORRELATIONS, TAKE THE MEDIAN ACROSS BOUTS
                    region(reg).rat(r).session(s).state(1).cellPair(cpInd).rmXCorr = median(cellPair(cp).rmXCorr,3);
                    
                end %for each cell pair

            end
            
            cd ../
        end %day
        cd ../
    end %session
    cd ../
end %rat



cd(curDir)
end %fnctn

