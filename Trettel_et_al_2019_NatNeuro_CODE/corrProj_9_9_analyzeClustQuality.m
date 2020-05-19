function corrProj_9_9_analyzeClustQuality(region)
% function corrProj_9_9_analyzeClustQuality(region)
%
% PURPOSE: 
%  To report the average isolation distance and L-ratio for MEC (split by grid vs. non-grid) and CA1 units. 
%  Median is taken for each unit, then average and SEM of the medians is reported. 
%
% INPUT: 
%  region = cluster quality data structure
%
% OUTPUT: 
%  Info printed on command line. 
%
% JBT 2/2018
% Colgin Lab




isoDist = cell(2,2); %region x cellType
LRat = cell(2,2); %region x cellType
for i = 1:2
    for j = 1:2
        isoDist{i,j} = [];
        LRat{i,j} = [];
    end
end

failCntr = 1;

d = 1;
for reg = 1:2
    for r = 1:length(region(reg).rat)
        for s = 1:length(region(reg).rat(r).session)
            
            unitIDs = [];
            for u = 1:length(region(reg).rat(r).session(s).day(d).task(1).bout(1).unit)
                unitIDs = [unitIDs; region(reg).rat(r).session(s).day(d).task(1).bout(1).unit(u).ID region(reg).rat(r).session(s).day(d).task(1).bout(1).unit(u).type]; %#ok
            end
            clusterStats = cell(size(unitIDs,1),1);
            
            for t = 1:3
                for b = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout)
                    for u = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit)
                        
                        tmpID = [region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).ID ...
                            region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).type];
                        
                        unitInd = find(ismember(unitIDs, tmpID, 'rows') == 1);
                        if ~isempty(unitInd)
                            try
                                clusterStats{unitInd} = [clusterStats{unitInd}; ...
                                    region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).clusterQual.ClusterSeperationStats.IsolationDist ...
                                    region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).clusterQual.ClusterSeperationStats.Lratio];          
                            catch
                                %                                 fprintf('Reg%d-R%d-S%d-T%d-B%d-U%d\n', reg, r, s, t, b, u)
                                failCntr = failCntr + 1;
                            end
                        end
                        
                    end %unit
                end %bout
            end %task
            
            
            for u = 1:size(unitIDs,1)
                if unitIDs(u,3) == 1 %if a place or grid cell
                    isoDist{reg,1} = [isoDist{reg,1} nanmedian(clusterStats{u}(:,1))];
                    LRat{reg,1} = [LRat{reg,1} nanmedian(clusterStats{u}(:,2))];
                else
                    isoDist{reg,2} = [isoDist{reg,2} nanmedian(clusterStats{u}(:,1))];
                    LRat{reg,2} = [LRat{reg,2} nanmedian(clusterStats{u}(:,2))];
                end
            end
            
            
        end %session
    end %rat
end %region

fprintf('\n\n\n'); 

regNames = {'MEC', 'CA1'};
ctNames = {'Grid Cells', 'Non-Grid Cells'; 'Place Cells', ''};
for reg = 1:2
    fprintf('%s\n', regNames{reg});
    for ct = 1:2
        if ~isempty(isoDist{reg,ct})
            fprintf('\t%s\n', ctNames{reg,ct});
            
            avg = nanmean(isoDist{reg,ct});
            err = nansemfunct(isoDist{reg,ct});
            fprintf('\t\tIso Dist: %0.04g +/- %0.04g\n', avg, err);
%             fprintf('\t\tIso Dist: %0.04g\n', avg);
            
            avg = nanmean(LRat{reg,ct});
            err = nansemfunct(LRat{reg,ct});
            fprintf('\t\tL-Ratio: %0.04g +/- %0.04g\n', avg, err);
        end
    end
end



end %fnctn