function corrProj_7_6_overlapHistograms(cellRegion)
% function corrProj_7_6_overlapHistograms(cellRegion)
%
% PURPOSE:
%  To plot the histograms of cross correlation coefficient
%  distributions by spatial overlap.
%
% INPUT:
%  cellRegion = uber data struct for each cell pair, outputted by corrProj_6...
%
% OUTPUT:
%  Figures
%
% JBT 8/2017
% Colgin Lab


stateNames = {'RUN', 'REM', 'NREM'};
groupNames = {'High', 'Mid', 'Low'};
stateCols = {'Green', 'Gold', 'Purple'};

ratioCuts = [0.0 0.3;... %HIGH
    0.4 0.6;... %MID
    0.7 1.0]; %LOW

reg = 1; %only an MEC plot

allSpatPhiMags = []; 
for cp = 1:length(cellRegion(reg).cellPair)
    allSpatPhiMags(cp) = cellRegion(reg).cellPair(cp).state(1).relSpatPhiMag;%#ok
end
ratioCuts = ratioCuts .* max(allSpatPhiMags);

gCntr = [1 1 1]; 
group = struct(); 
for cp = 1:length(cellRegion(reg).cellPair)
    cpSpatPhiMag = allSpatPhiMags(cp); 
    grpNum = [];
    if cpSpatPhiMag <= ratioCuts(1,2)
        grpNum = 1; %HIGH
    elseif cpSpatPhiMag >= ratioCuts(2,1) && cpSpatPhiMag <= ratioCuts(2,2) 
        grpNum = 2; %MID
    elseif cpSpatPhiMag >= ratioCuts(3,1)
        grpNum = 3; %LOW
    end
    
    if ~isempty(grpNum)
        for s = 1:3
            midSum = cellRegion(reg).cellPair(cp).state(s).midSum(1);
            group(grpNum).xCorrs(gCntr(grpNum),s) = midSum; 
        end
        gCntr(grpNum) = gCntr(grpNum) + 1; 
    end
end

% PLOTTING
figure('Position', [ 377    65   608   606])
for s = 1:3
    for g = 1:3
        subplot(3,3,(s-1)*3+g);
        [cnts,edges] = histcounts(group(g).xCorrs(:,s), 'Normalization', 'Probability', 'BinWidth', .01, 'BinLimits', [0 .1]); 
        edges = edges(2:end)-mean(diff(edges)); 
        bg = bar(edges,cnts); 
        set(bg, 'FaceColor', rgb(stateCols{s})); 
        xlim([0 .1]); 
        ylim([0 .8]); 
        if s == 1
            title([groupNames{g} ' Overlap']); 
        end
        if g == 1
            ylabel({stateNames{s} ; 'Probability'}); 
        end
        if s == 3 && g == 2
            xlabel('Cross-Correlation Coefficient'); 
        end
    end
end



end%fnctn