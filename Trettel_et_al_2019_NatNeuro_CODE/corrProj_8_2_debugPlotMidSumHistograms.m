function corrProj_8_2_debugPlotMidSumHistograms(cellRegion)
% function corrProj_8_2_debugPlotMidSumHistograms(cellRegion)
%
% PURPOSE:
%  Function to plot the distribution of spike-time cross-correlation coefficients
%  summed over the five middle 2ms bins.
%
% JBT 9/2017
% Colgin Lab


regNames = {'MEC', 'CA1'};
stateNames = {'RUN', 'REM', 'NREM'};
stateCols = {'Green', 'Gold', 'Purple'};
yMax = [150 40]; 

figure('Position', [560    71   779   877]); 
for reg = 1:2
    allMidSums = zeros(length(cellRegion(reg).cellPair),3);
    for cp = 1:length(cellRegion(reg).cellPair)
        for s = 1:3
            tmpSum = cellRegion(reg).cellPair(cp).state(s).midSum(1);
            allMidSums(cp,s) = tmpSum;
        end
    end
    
    for s = 1:3
        subplot(3,2,(s-1)*2+reg);
        [cnts,edges] = histcounts(allMidSums(:,s), 'BinWidth', 0.01, 'BinLimits', [0 .2]);
        edges = edges(2:end) - mean(diff(edges));
        bg = bar(edges,cnts);
        xlim([-0.005 .2]); 
        set(bg, 'FaceColor', rgb(stateCols{s}));
        if s == 3
            xlabel('SpkTm Cross-Corr Sum');
        end
        if reg == 1
            ylabel({stateNames{s}; 'Counts'});
        end
        if s == 1
            title(regNames{reg})
        end
        ylim([0 yMax(reg)]); 
    end
    
end


end %fnctn