function region = corrProj_5_calcSpatialMetrics(region)
% function region = corrProj_5_calcSpatialMetrics(region)
%
% PURPOSE:
%   Function to calculate all the spatial metrics necessary (e.g., auto/cross
%   correlations, rate map corr coeffs, relative spatial phase, etc).
%
% INPUT:
%   region = project uber data structure after it has been passed through
%            the other 3 corrProj functions
%
% OUTPUT:
%   region = same as input, but with many additional fields added to the cell pair field for state(1) [i.e., REM]
%             For MEC, new fields:
%                                 - rateMaps = self explanatory
%                                 - rmCorr = rate map correlation coefficient
%                                 - rmAutoCorr = auto-correlation maps for each unit
%                                 - rmXCorr = cross-correlation map
%                                 - relSpatPhi = [relative_x_spatial_phase  relative_y_spatial phase]
%                                 - spatPhimag = 1D magnitude of relative spatial phase
%                                 - spatPerRatio = ratio of spatial periods
%                                 - orientRatio = ratio of grid orientations
%             For CA1, new fields =
%                                 - rateMaps = self explanatory
%                                 - rmCorr = rate map correlation coefficient
%                                 - relSpatPhi = relative spatial distance between peak firing locations (degrees)
%
% JBT 8/2017
% Colgin Lab



curDir = pwd;
dataDir = 'C:\Users\John Trimper\Desktop\LAB_STUFF\PROJECTS\Grid_Cell_Correlations_TrettelProj\CORR_PROJECT_RERUN\DATASET\';
cd(dataDir);

ca1RadRmBinMids = 2.5:5:360;

for reg = 1:2
    fprintf('%s\n', region(reg).name)
    cd(region(reg).name)
    for r = 1:length(region(reg).rat)
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
                cellPair = struct();
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
                
                
                
                
                %% GO THROUGH THE RUN TASKS [OPEN FIELD FOR MEC, LINEAR TRACK FOR CA1]
                
                for b = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout)
                    fprintf('\t\t\t\t\tBout %d\n', b);
                    cd(['Begin' num2str(b)]);
                    
                    runEpochBnds = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).runTimes;
                    
                    if ~isempty(runEpochBnds)
                        
                        % GET SPATIAL METRICS FOR UNIT 1
                        for u1 = 1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit)
                            u1ID = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u1).ID;
                            %                             fprintf('\t\t\t\t\t\tUnit %d (Tet#%d, Unit#%d)\n', u1, u1ID(1), u1ID(2));
                            if region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u1).type ~= 1 %if it's a grid cell/CA1 pyram
                                %                                 fprintf('\t\t\t\t\t\t\tUnit is not a grid cell. Skipping.\n');
                            else
                                
                                %get the ratemap
                                u1Rm = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u1).rateMap;
                                
                                if reg == 1 %for grid cells only
                                    %rate map auto-correlation
                                    u1AutoCorr = rateMapXCorr(u1Rm, u1Rm);
                                    
                                    %calculate spatial period and grid orientation
                                    [u1GridSize, ~] = THorientation_size(u1AutoCorr, 0.5);%0.5 = threshold for peak detection
                                    
                                    %get the grid field ellipse coorsd
                                    u1ElpsCrds = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u1).ellipseCoords; 
                                end
                                
                                %vectorize the rate map and remove nans
                                u1RmVctr = u1Rm(:);
                                u1RmVctr(isnan(u1RmVctr)) = [];
                                
                                
                                % GET SPATIAL METRICS FOR UNIT 2, THEN FOR THE PAIR
                                for u2 = u1+1:length(region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit)
                                    
                                    u2ID = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u2).ID; %get unit 2 ID
                                    %                                     fprintf('\t\t\t\t\t\t\tPaired with Unit %d (Tet#%d, Unit#%d)\n', u2, u2ID(1), u2ID(2));
                                    
                                    if region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u2).type ~= 1 %if it's a grid cell/CA1 pyram
                                        %                                         fprintf('\t\t\t\t\t\t\t\tUnit is not a grid cell. Skipping.\n');
                                    else
                                        
                                        %get the ratemap
                                        u2Rm = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u2).rateMap;
                                        
                                        % GET SEVERAL GRID CELL METRICS, FOR MEC ONLY
                                        if reg == 1
                                            
                                            %calculate rate-map cross correlation
                                            rmXCorr = rateMapXCorr(u1Rm, u2Rm);
                                            
                                            %get relative spatial phase
                                            [relSpatPhiX, relSpatPhiY] = getSpacePhase(rmXCorr);
                                            
                                            % wrap around 0.5
                                            %   "because distance of least overlap is one half the spatial period" (from manuscript)
                                            if relSpatPhiX > 0.5
                                                relSpatPhiX = 1 - relSpatPhiX;
                                            end
                                            if relSpatPhiY > 0.5
                                                relSpatPhiY = 1 - relSpatPhiY;
                                            end
                                            %normalize so to 1
                                            relSpatPhiX = relSpatPhiX / 0.5;
                                            relSpatPhiY = relSpatPhiY / 0.5;
                                            
                                            %get 1D magnitude of relative spatial phase
                                            spatPhimag = hypot(relSpatPhiX, relSpatPhiY);
                                            
                                            %rate map auto-correlation
                                            u2AutoCorr = rateMapXCorr(u2Rm, u2Rm);
                                            
                                            %calculate spatial period and grid orientation
                                            [u2GridSize, ~] = THorientation_size(u2AutoCorr, 0.5); %0.5 = threshold for peak detection
                                       
                                            %calculate spatial period ratio 
                                            spatPerRatio = min([u1GridSize/u2GridSize u2GridSize/u1GridSize]);%calculate spatial period ratio
                                            
                                            % find coordinates for ellipse best fit to grid field hexagon
                                            u2ElpsCrds = region(reg).rat(r).session(s).day(d).task(tNum).bout(b).unit(u2).ellipseCoords;
                                            
                                            %Find ellipse overlap ratio
                                            CP(1).x = u1ElpsCrds(1,:); 
                                            CP(1).y = u1ElpsCrds(2,:); 
                                            CP(1).hole = 0;
                                            CP(2).x = u2ElpsCrds(1,:); 
                                            CP(2).y = u2ElpsCrds(2,:); 
                                            CP(2).hole = 0;
                                            
                                            intersectPoly = PolygonClip(CP(1), CP(2), 1); %area that is both A & B
                                            intersectArea = polyarea(intersectPoly.x, intersectPoly.y); 
                                            unionPoly = PolygonClip(CP(1), CP(2), 3); %area that is A, B, or both
                                            unionArea = polyarea(unionPoly.x, unionPoly.y); 
                                            
                                            elpsAreaRatio = intersectArea / unionArea; 
                                                                                        
                                        end
                                        
                                        
                                        %vectorize the rate map and remove nans
                                        u2RmVctr = u2Rm(:);
                                        u2RmVctr(isnan(u2RmVctr)) = [];
                                        
                                        % GET RELATIVE FIELD DISTANCE, FOR CA1 ONLY
                                        if reg == 2
                                            
                                            %get radial peak firing positions, in radians
                                            [~,u1PkInd] = max(u1RmVctr);
                                            [~, u2PkInd] = max(u2RmVctr);
                                            
                                            u1RadPos = deg2rad(ca1RadRmBinMids(u1PkInd));
                                            u2RadPos = deg2rad(ca1RadRmBinMids(u2PkInd));
                                            
                                            relSpatDist = rad2deg(abs(circ_dist(u1RadPos, u2RadPos)));
                                        end
                                        
                                        
                                        % calculate rate-map correlation coefficient
                                        corrMat = corrcoef(u1RmVctr,u2RmVctr);
                                        rmCorr = corrMat(2,1); % take off-diagonal value
                                        
                                        % find out which cell pair this is in the list
                                        cpInd = find(cellPairList(1,1,:)==u1ID(1) & cellPairList(1,2,:)==u1ID(2) & cellPairList(2,1,:)==u2ID(1) & cellPairList(2,2,:)==u2ID(2));
                                        
                                        %store all the variables we might need
                                        cellPair(cpInd).unitIDs(:,:,b) = [u1ID; u2ID];
                                        cellPair(cpInd).rmCorr(b) = rmCorr;
                                        if reg == 1 %MEC
                                            cellPair(cpInd).rateMaps(:,:,1,b) = u1Rm;
                                            cellPair(cpInd).rateMaps(:,:,2,b) = u2Rm;
                                            cellPair(cpInd).rmAutoCorr(:,:,1,b) = u1AutoCorr;
                                            cellPair(cpInd).rmAutoCorr(:,:,2,b) = u2AutoCorr;
                                            cellPair(cpInd).rmXCorr(:,:,b) = rmXCorr;
                                            cellPair(cpInd).relSpatPhi(:,b) = [relSpatPhiX, relSpatPhiY];
                                            cellPair(cpInd).spatPhiMag(b) = spatPhimag;
                                            cellPair(cpInd).gridInfoByUnit(:,b) = [u1GridSize; u2GridSize];
                                            cellPair(cpInd).spatPerRatio(b) = spatPerRatio;
                                            cellPair(cpInd).elpsAreaRatio(b) = elpsAreaRatio; 
                                        else %CA1
                                            cellPair(cpInd).rateMaps(:,1,b) = u1Rm;
                                            cellPair(cpInd).rateMaps(:,2,b) = u2Rm;
                                            cellPair(cpInd).relSpatDist(b) = relSpatDist;
                                        end
                                        
                                    end %if unit2 is a grid cell/pyram
                                end %unit2
                            end %if unit1 is a grid cell/pyram
                        end %unit1
                    end %if there were run epochs for this bout
                    
                    cd ../
                end %bout
                cd ../
                
                
                
                %% REDUCE THE METRICS ACROSS BOUTS (i.e., median/average)
                if ~isempty(cellPairList)
                    for cp = 1:length(cellPair)
                        
                        % STORE UNIT PAIR INFO
                        region(reg).rat(r).session(s).state(1).cellPair(cp).unitIDs = cellPair(cp).unitIDs(:,:,1); %same for every bout (3rd d)
                        
                        % STORE RATE MAPS
                        region(reg).rat(r).session(s).state(1).cellPair(cp).rateMaps = cellPair(cp).rateMaps;
                        
                        % FOR RATE MAP CORRELATION COEFFICIENTS, TAKE THE MEDIAN ACROSS BOUTS
                        region(reg).rat(r).session(s).state(1).cellPair(cp).rmCorrCoeffs = median(cellPair(cp).rmCorr);
                        
                        if reg == 1 %MEC
                            
                            % FOR RATE MAP CROSS CORRELATIONS, TAKE THE MEDIAN ACROSS BOUTS
                            region(reg).rat(r).session(s).state(1).cellPair(cp).rmXCorr = median(cellPair(cp).rmXCorr,3);
                            
                            
                            % FOR RELATIVE SPATIAL PHASE, TAKE THE MEDIAN ACROSS BOUTS
                            %   2D
                            relSpatPhi = median(cellPair(cp).relSpatPhi,2);
                            region(reg).rat(r).session(s).state(1).cellPair(cp).relSpatPhi = relSpatPhi; 
                            %   1D
                            region(reg).rat(r).session(s).state(1).cellPair(cp).spatPhiMag = hypot(relSpatPhi(1), relSpatPhi(2));
                            
                            
                            % FOR GRID SIZE, TAKE THE AVERAGE ACROSS BOUTS
                            gridSizes = mean(cellPair(cp).gridInfoByUnit(:,1,:),3)';
                            region(reg).rat(r).session(s).state(1).cellPair(cp).gridSize = gridSizes;
                            
                            % CALCULATE SPATIAL PERIOD RATIO
                            spatPerRatio = min([gridSizes(1)/gridSizes(2) gridSizes(2)/gridSizes(1)]);
                            region(reg).rat(r).session(s).state(1).cellPair(cp).spatPerRatio = spatPerRatio;
                            
                            % GET AVERAGE GRID FIELD ELLIPSE RATIO
                            region(reg).rat(r).session(s).state(1).cellPair(cp).elpsAreaRatio = nanmean(cellPair(cpInd).elpsAreaRatio); 

                        else %CA1
                            
                            % FOR RELATIVE ANGULAR DISTANCE, TAKE THE MEDIAN ACROSS BOUTS
                            region(reg).rat(r).session(s).state(1).cellPair(cp).relSpatDist = median(cellPair(cp).relSpatDist);
                            
                        end
                        
                    end %for each cell pair
                else
                    region(reg).rat(r).session(s).state(1).cellPair = [];
                end
                
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

