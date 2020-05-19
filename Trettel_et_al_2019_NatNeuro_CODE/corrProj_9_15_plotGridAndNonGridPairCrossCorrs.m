function corrProj_9_15_plotGridAndNonGridPairCrossCorrs(pairType)
% function corrProj_9_15_plotGridAndNonGridPairCrossCorrs(pairType)
%
% PURPOSE:
%  To plot spike time correlation coefficients (summed across mid 5 or 50 ms) against
%  rate map correlation coefficients for GC/GC, GC/nGC, and nGC/nGC pairs.
%
% INPUT:
%  pairType = data structure for cell pairs outputted by corrProj_9_14
%
% OUTPUT:
%  Scatterplots for each state/pair-type, a figure for each bin size
%
% JB Trimper
% 5/2018
% Colgin Lab



%% PLOTTING SPECIFICS
ptSyms = {'o', 's', 'd'};
stateNames = {'RUN', 'REM', 'nREM'};
stateCols = {'Green', 'Gold', 'Purple'};
yLims = [.2 2];


rmOutlier = 0; %set to 1 to remove the outliers present [for GC/nGCs, see high end of nREM plot; for nGC/nGCs, see low end of nREM plot]

binFig(1) = figure('name', 'Bin 1', 'Position', [334 51 1102 929]);
binFig(2) = figure('name', 'Bin 2', 'Position', [334 51 1102 929]);
for pt = 1:3
    
    %% GET THE DATA TO BE PLOTTED FOR EACH PAIRTYPE
    rmCcs = zeros(length(pairType(pt).cellPair),1);
    midSums = zeros(length(pairType(pt).cellPair),2,3);
    for cp = 1:length(pairType(pt).cellPair)
        for ss = 1:3
            for bin = 1:2
                if ss == 1
                    rmCcs(cp) = pairType(pt).cellPair(cp).state(ss).rmCorrCoeffs;
                end
                midSums(cp,bin,ss) = pairType(pt).cellPair(cp).state(ss).midSum(bin);
            end %stXCorr bin size
        end %state
    end %cellPair
    
  
    
    if rmOutlier == 1
        if pt == 2
            rmCcs(258) = [];
            midSums(258,:,:) = [];
        elseif pt == 3
            rmCcs(15) = [];
            midSums(15,:,:) = [];
        end
    end
    
    %% DO THE PLOTTING
    for bin = 1:2
        figure(binFig(bin))
        for ss = 1:3
            
            subplot(3,3,(pt-1)*3+ss);
            hold on;
            
            plot(rmCcs, midSums(:,bin,ss), ptSyms{pt}, 'Color', rgb(stateCols{ss}));
            
            [rho, pVal] = corr(rmCcs, midSums(:,bin,ss));
            rho = num2str(round(rho,4));
            pVal = num2str(round(pVal,4));
            
            linCoefs = polyfit(rmCcs, midSums(:,bin,ss),1);
            linXVals = [-0.4 0.7];
            linYVals = polyval(linCoefs, linXVals);
            lg = line(linXVals, linYVals);
            set(lg, 'LineWidth', 1, 'Color', [0 0 0]);
            
            if ss == 1
                ylabel({pairType(pt).name; 'Spk Tm Corr Coeff'});
            end
            if pt == 3 && ss == 2
                xlabel('Rate Map Correlation Coefficient');
            end
            if pt == 1
                title({stateNames{ss}; ['r = ' rho '; p = ' pVal]});
            else
                title(['r = ' rho '; p = ' pVal]);
            end
            
            ylim([0 yLims(bin)]);
            xlim([-0.4 .7]);
            
            set(gca, 'FontName', 'Arial', 'FontSize', 12)
        end %state
    end %stXCorr bin size
    
    
end%pairType



end %fnctn