function corrProj_7_5_3dPlots(cellRegion)
% function corrProj_7_5_3dPlots(cellRegion)
%
% PURPOSE:
%  Function to plot relative spatial phase in each direction (x&y) against
%  the sum of the spike time cross correlations (mid bins)
%
% INPUT:
%  cellRegion = uber data struct for each cell pair, outputted by corrProj_6...
%
% OUTPUT:
%  Figures
%
% JBT 8/2017
% Colgin Lab


binEdges = linspace(0, 1, 5); 

regNames = {'MEC', 'CA1'};
stateNames = {'RUN', 'REM', 'NREM'};
winSizeTtls = {'+/- 5 ms', '+/- 50 ms'};

reg = 1; %only an MEC plot

spatPhiVals = [];
midSum = [];
for cp = 1:length(cellRegion(reg).cellPair)
    spatPhiVals(cp,:) = cellRegion(reg).cellPair(cp).state(1).relSpatPhi2D;%#ok
    for s = 1:3
        midSum(cp,:,s) = cellRegion(reg).cellPair(cp).state(s).midSum;%#ok
    end
end


winSize(1).vals = nan(length(binEdges)-1,length(binEdges)-1,3);
winSize(2).vals = nan(length(binEdges)-1,length(binEdges)-1,3);
for b1 = 1:length(binEdges)-1
    tmpXEdges = [binEdges(b1) binEdges(b1+1)];
    xInds = find(spatPhiVals(:,1)>=tmpXEdges(1) & spatPhiVals(:,1)<tmpXEdges(2));
    for b2 = 1:length(binEdges)-1
        tmpYEdges = [binEdges(b2) binEdges(b2+1)];
        yInds = find(spatPhiVals(:,2)>=tmpYEdges(1) & spatPhiVals(:,2)<tmpYEdges(2));
        cpInds = intersect(xInds,yInds);
        for s = 1:3
            winSize(1).vals(b1,b2,s) = mean(midSum(cpInds,1,s),1);
            winSize(2).vals(b1,b2,s) = mean(midSum(cpInds,2,s),1);
        end
    end
end


%PLOTTING
figure('name', regNames{reg}, 'Position', [355    41   560   643]);
for ws = 1:2
    for s = 1:3
        subplot(3,2,(s-1)*2+ws);
        tmpVals = winSize(ws).vals(:,:,s);
        tmpVals = tmpVals ./ tmpVals(1,1);
        surf(binEdges(1:end-1), binEdges(1:end-1), tmpVals)
        xlim([0.0 0.8]);
        ylim([0.0 0.8]);
        zlim([0.0 1.2]);
        set(gca, 'XTick', 0.0:0.2:0.8, 'YTick', 0.0:0.2:0.8, 'FontName', 'Arial');
        view(125,16);
        colormap hot
        caxis([0 1]); 
        set(gca, 'ZTick', 0.0:0.2:1.2); 
        if s == 1
            title(winSizeTtls{ws})
        end
        if ws == 1
            zlabel({stateNames{s}; 'Normalized Cross-'; 'Correlation Coefficient'})
        end
        if s == 3
            xlabel('\Delta\Phi_{X}');
            ylabel('\Delta\Phi_{Y}');
        end
    end
end