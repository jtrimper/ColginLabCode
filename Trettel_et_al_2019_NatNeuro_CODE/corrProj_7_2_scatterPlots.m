function corrProj_7_2_scatterPlots(cellRegion)
% function corrProj_7_2_scatterPlots(cellRegion)
%
% PURPOSE:
%   Function to plot scatterplots and calculate correlations for the spike-time cross-correlation
%   (2ms bins, summed across middle 5 bins) correlated with the rate map correlation coefficients.
%
% INPUT:
%   cellRegion = the output of corrProj_6... which has data for each cell pair by state and region
%
% OUTPUT:
%   Figures (scatterplots) as well as printed stats.
%
% JBT 8/2017
% Colgin Lab


regNames = {'MEC', 'CA1'}; 
stateNames = {'RUN', 'REM', 'NREM'}; 
regSymbs = {'.', '^'}; 
stateCols = {'Green', 'Gold', 'Purple'};

figure('name', 'Scatterplots by Region and State', 'Position', [364 168 1051 663]); 
for reg = 1:2
    cpCorrVals = []; 
    for cp = 1:length(cellRegion(reg).cellPair)
        for s = 1:3
            
            if s == 1
                rmCc = cellRegion(reg).cellPair(cp).state(s).rmCorrCoeffs; 
            end
            
            midSum(s) = cellRegion(reg).cellPair(cp).state(s).midSum(1);%#ok 
        end %state
        
        cpCorrVals = [cpCorrVals; rmCc midSum ]; %#ok 
        
    end %cell pair

    keyboard
    
    % PLOTTING
    for s = 1:3
        
        %Calculate correlation coefficients
        [rVal, pVal] = corr(cpCorrVals(:,1), cpCorrVals(:,s+1));
        
        %Do the actual plotting
        subplot(2,3,(reg-1)*3+s);
        hold on; 
        plot(cpCorrVals(:,1), cpCorrVals(:,s+1), regSymbs{reg}, 'Color', rgb(stateCols{s}));
        
        lineCoefs = polyfit(cpCorrVals(:,1), cpCorrVals(:,s+1), 1);
        slope = lineCoefs(1); 
        yInt = lineCoefs(2); 
        lnCoords = [-.3*slope+yInt 1*slope+yInt]; 
        ln = line([-.3 1], lnCoords); 
        set(ln, 'Color', [0 0 0], 'LineWidth', 2); 
        
        if reg == 1
            title({stateNames{s}; ['r = ' num2str(round(rVal,4)) '; p = ' num2str(round(pVal,4))]})
        else
            title(['r = ' num2str(round(rVal,4)) '; p = ' num2str(round(pVal,4))])
        end
        if s == 1
            ylabel({regNames{reg}; 'Cross-Correlation'; 'Coefficient'})
        end
        if reg == 2 && s == 2
            xlabel('Rate Map Correlation Coefficient')
        end
        set(gca, 'FontName', 'Arial');
        ylim([0 .2]); 
        xlim([-.4 1]); 
        set(gca, 'YTick', 0:.05:.2); 
        set(gca, 'XTick', -.3:.3:.9); 
        stats(1,reg,s) = rVal; %#ok
        stats(2,reg,s) = pVal; %#ok
    end
    
end %region


% Print out stats
fprintf('STATS:\n'); 
for reg = 1:2
    fprintf('\t%s\n', regNames{reg}); 
    for s = 1:3
        fprintf('\t\t%s:\n', stateNames{s}); 
        fprintf('\t\t\tr = %0.06g\n', stats(1,reg,s)); 
        fprintf('\t\t\tp = %0.06g\n', stats(2,reg,s)); 
    end
end
    
end %fncnt