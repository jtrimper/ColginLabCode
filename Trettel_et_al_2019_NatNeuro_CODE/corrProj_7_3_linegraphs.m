function corrProj_7_3_linegraphs(cellRegion)
% function corrProj_7_3_linegraphs(cellRegion)
%
% PURPOSE:
%   Function to plot line graphs for each region, with a line for each state, showing relative spatial
%   phase/distance plotted against the spike-time cross correlation coefficient, summed across the middle bins.
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
binSizes = {'+/-5ms', '+/-50ms'};
stateCols = {'Green', 'Gold', 'Purple'};

scaled5BinFig = figure('name', 'Normalized, 5 Bins', 'Position', [ 360   209   834   646]);
unscaled5BinFig = figure('name', 'Non-normalized, 5 Bins', 'Position', [ 360   209   834   646]);

scaled6BinFig = figure('name', 'Normalized, 6 Bins', 'Position', [ 360   209   834   646]);
unscaled6BinFig = figure('name', 'Non-normalized, 6 Bins', 'Position', [ 360   209   834   646]);

%MEC
binEdges{1,1} = 0:.25:1;
binEdges{1,2} = 0:.2:1;
%CA1
binEdges{2,1} = 0:36:180;
binEdges{2,2} = 0:30:180; %6 bins

for reg = 1:2
    
    fiveBinVals = cell(2,5);
    sixBinVals = cell(2,6);
    
    for cp = 1:length(cellRegion(reg).cellPair)
        for s = 1:3
            
            if s == 1
                if reg == 1
                    relSpatDist = cellRegion(reg).cellPair(cp).state(s).relSpatPhiMag;
                else
                    relSpatDist = cellRegion(reg).cellPair(cp).state(s).relSpatDist;
                end
            end
            
            midSum5(s) = cellRegion(reg).cellPair(cp).state(s).midSum(1);%#ok
            midSum50(s) = cellRegion(reg).cellPair(cp).state(s).midSum(2);%#ok
            
        end %state
        
        %for 5 bins
        binInd = find(binEdges{reg,1}<=relSpatDist, 1, 'Last');
        fiveBinVals{1,binInd} = [fiveBinVals{1,binInd}; midSum5];
        fiveBinVals{2,binInd} = [fiveBinVals{2,binInd}; midSum50];
        
        %for 6 bins
        binInd = find(binEdges{reg,2}<=relSpatDist, 1, 'Last');
        sixBinVals{1,binInd} = [sixBinVals{1,binInd}; midSum5];
        sixBinVals{2,binInd} = [sixBinVals{2,binInd}; midSum50];
        
    end %cell pair
    
    
    
    
    %% PLOT FIVE BIN VERSION
    
    %   First, plot the non-normalized version
    figure(unscaled5BinFig);
    AVG = zeros(5,3);
    SEM = zeros(5,3);
    for bs = 1:2 %bin size (5 or 50)
        for bn = 1:5 %bin # (1-5)
            AVG(bn,:) = mean(fiveBinVals{bs,bn},1);
            SEM(bn,:) = semfunct(fiveBinVals{bs,bn},1);
        end
        
        subplot(2,2,(reg-1)*2+bs);
        hold on;
        for s = 1:3
            tmpLn(s) = plot(1:5, AVG(:,s));%#ok
            set(tmpLn(s), 'Color', rgb(stateCols{s}), 'LineWidth', 2);
            errorbar(1:5, AVG(:,s), SEM(:,s), 'Color', rgb(stateCols{s}), 'LineStyle', 'None', 'LineWidth', 1.5, 'CapSize', 0);
        end
        set(gca, 'XLim', [.9 5.1], 'XTick', 1:5, 'FontName', 'Arial');
        if bs == 1
            ylabel({regNames{reg}; 'Cross-Correlation Coefficient'});
        end
        if reg == 1
            xlabel('Relative Spatial Phase');
            set(gca, 'XTickLabel', {'0.00 - 0.25', '0.25 - 0.50', '0.50 - 0.75', '0.75 - 1.00', '>1.00'})
            title(binSizes{bs});
        else
            xlabel('Relative Angular Distance');
            set(gca, 'XTickLabel', {'0-36', '36-72', '72-108', '108-144', '144-180'})
        end
        yBnds = get(gca, 'YLim');
        ylim([0 yBnds(2)]);
        
        maxAVG(bs,:) = max(AVG); %#ok -- for scaled figure
        
        if (reg-1)*2+bs == 2
            leg = legend(tmpLn, stateNames);
            set(leg, 'Box', 'Off', 'FontName', 'Arial', 'FontWeight', 'Bold');
        end
        
    end
    
    
    %  Then, plot the normalized version
    figure(scaled5BinFig);
    for bs = 1:2 %bin size (5 or 50)
        for bn = 1:5 %bin # (1-5)
            
            for s = 1:3
                %normalize all individual values to the max average across bins for each state
                tmpNormVals = fiveBinVals{bs,bn}(:,s) ./ maxAVG(bs,s);
                
                AVG(bn,s) = mean(tmpNormVals,1);
                SEM(bn,s) = semfunct(tmpNormVals,1);
            end
        end
        
        subplot(2,2,(reg-1)*2+bs);
        hold on;
        for s = 1:3
            tmpLn(s) = plot(1:5, AVG(:,s));
            set(tmpLn(s), 'Color', rgb(stateCols{s}), 'LineWidth', 2);
            errorbar(1:5, AVG(:,s), SEM(:,s), 'Color', rgb(stateCols{s}), 'LineStyle', 'None', 'LineWidth', 1.5, 'CapSize', 0);
        end
        set(gca, 'XLim', [.9 5.1], 'XTick', 1:5, 'FontName', 'Arial');
        if bs == 1
            ylabel({regNames{reg}; 'Cross-Correlation Coefficient'});
        end
        if reg == 1
            xlabel('Relative Spatial Phase');
            set(gca, 'XTickLabel', {'0.00 - 0.25', '0.25 - 0.50', '0.50 - 0.75', '0.75 - 1.00', '>1.00'})
            title(binSizes{bs});
        else
            xlabel('Relative Angular Distance');
            set(gca, 'XTickLabel', {'0-36', '36-72', '72-108', '108-144', '144-180'})
        end
        ylim([0 1.4]);
        
        if (reg-1)*2+bs == 2
            leg = legend(tmpLn, stateNames);
            set(leg, 'Box', 'Off', 'FontName', 'Arial', 'FontWeight', 'Bold');
        end
    end
    
    
    
    
    
    %% PLOT 6 BIN VERSION
    
    %  First, plot the non-normalized version
    figure(unscaled6BinFig);
    AVG = zeros(6,3);
    SEM = zeros(6,3);
    for bs = 1:2 %bin size (5 or 50)
        for bn = 1:6 %bin # (1-5)
            AVG(bn,:) = mean(sixBinVals{bs,bn},1);
            SEM(bn,:) = semfunct(sixBinVals{bs,bn},1);
        end
        
        subplot(2,2,(reg-1)*2+bs);
        hold on;
        for s = 1:3
            tmpLn(s) = plot(1:6, AVG(:,s)); 
            set(tmpLn(s), 'Color', rgb(stateCols{s}), 'LineWidth', 2);
            errorbar(1:6, AVG(:,s), SEM(:,s), 'Color', rgb(stateCols{s}), 'LineStyle', 'None', 'LineWidth', 1.5, 'CapSize', 0);
        end
        set(gca, 'XLim', [.9 6.1], 'XTick', 1:6, 'FontName', 'Arial');
        if bs == 1
            ylabel({regNames{reg}; 'Cross-Correlation Coefficient'});
        end
        if reg == 1
            xlabel('Relative Spatial Phase');
            set(gca,'XTickLabel', {'0.0-0.2', '0.2-0.4', '0.4-0.6', '0.6-0.8', '0.8-1.0', '>1.0'});
            title(binSizes{bs});
        else
            xlabel('Relative Angular Distance');
            set(gca,'XTickLabel', {'0-30', '30-60', '60-90', '90-120', '120-150', '150-180'});
        end
        yBnds = get(gca, 'YLim');
        ylim([0 yBnds(2)]);
        
         maxAVG(bs,:) = max(AVG); %for scaled figure
         
         if (reg-1)*2+bs == 2
             leg = legend(tmpLn, stateNames); 
             set(leg, 'Box', 'Off', 'FontName', 'Arial', 'FontWeight', 'Bold'); 
         end
    end
    
    
    %  Then, plot the normalized version
    figure(scaled6BinFig);
    for bs = 1:2 %bin size (5 or 50)
        for bn = 1:6 %bin # (1-5)
            
            for s = 1:3
                %normalize all individual values to the max average across bins for each state
                tmpNormVals = sixBinVals{bs,bn}(:,s) ./ maxAVG(bs,s);
                
                AVG(bn,s) = mean(tmpNormVals,1);
                SEM(bn,s) = semfunct(tmpNormVals,1);
            end
        end
        
        subplot(2,2,(reg-1)*2+bs);
        hold on;
        for s = 1:3
            tmpLn(s) = plot(1:6, AVG(:,s));
            set(tmpLn(s), 'Color', rgb(stateCols{s}), 'LineWidth', 2);
            errorbar(1:6, AVG(:,s), SEM(:,s), 'Color', rgb(stateCols{s}), 'LineStyle', 'None', 'LineWidth', 1.5, 'CapSize', 0);;
        end
        set(gca, 'XLim', [.9 6.1], 'XTick', 1:6, 'FontName', 'Arial');
        if bs == 1
            ylabel({regNames{reg}; 'Cross-Correlation Coefficient'});
        end
        if reg == 1
            xlabel('Relative Spatial Phase');
           set(gca,'XTickLabel', {'0.0-0.2', '0.2-0.4', '0.4-0.6', '0.6-0.8', '0.8-1.0', '>1.0'});
            title(binSizes{bs});
        else
            xlabel('Relative Angular Distance');
            set(gca,'XTickLabel', {'0-30', '30-60', '60-90', '90-120', '120-150', '150-180'});
        end
        ylim([0 1.6]);
        
        if (reg-1)*2+bs == 2
            leg = legend(tmpLn, stateNames);
            set(leg, 'Box', 'Off', 'FontName', 'Arial', 'FontWeight', 'Bold');
        end
    end
    
    
    
end %region


end%fnctn