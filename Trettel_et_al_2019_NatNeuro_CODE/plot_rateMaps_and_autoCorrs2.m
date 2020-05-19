function plot_rateMaps_and_autoCorrs2(region)
% function plot_rateMaps_and_autoCorrs2(region)
%
% This version plots the rate maps and auto-correlations for each begin window, rather than averaged across.
%
% JBT 2/2018
% Colgin Lab


saveFigs = 1;
saveDir = 'I:\STORAGE\LAB_STUFF\COLGIN_LAB\PROJECTS\Grid_Cell_Correlations_TrettelProj\MANUSCRIPT\NATURE_NEURO_SUBMISSION\REVISIONS\NEW_RESULTS\rateMapsAndAutoCorrs_splitByBout';

curDir = pwd;

reg = 1; %MEC
t = 2; %Task
d = 1; %Day


for r = 1:length(region(reg).rat)
    for s = 1:length(region(reg).rat(r).session)
        for u  = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(1).unit)
            if region(reg).rat(r).session(s).day(d).task(t).bout(1).unit(u).type == 1 %If a grid cell
                numBouts = length(region(reg).rat(r).session(s).day(d).task(t).bout);
                
                
                % PLOT RATE MAPS USING CONTOURF
                figure('Position', [2294 186 1241 671]);
                for b = 1:numBouts
                    
                    
                    % CALCULATE/PLOT RATEMAP
                    rateMap = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).rateMap;
                    
                    subplot(2,numBouts,b);
                    contourf(1:size(rateMap,1), 1:size(rateMap,1), rateMap, 50, 'LineStyle', 'none')
                    colormap jet
                    axis square
                    
                    set(gca, 'XTick', 0:8.25:33, 'XTickLabel', 0:25:100);
                    set(gca, 'YTick', 0:8.25:33, 'YTickLabel', 0:25:100);
                    axis([1 33 1 33])
                    
                    ylabel('Position (cm)');
                    xlabel('Position (cm)');
                    set(gca, 'FontSize', 12, 'FontName', 'Arial');
                    
                    title(['Bout ' num2str(b)]); 
                    
                    
                    % CALCULATE/PLOT AUTO-CORRELATION
                    autoCorr = rateMapXCorr(rateMap, rateMap);
                    
                    subplot(2,numBouts,numBouts+b);
                    contourf(1:size(autoCorr,1), 1:size(autoCorr,1), autoCorr, 50, 'LineStyle', 'none')
                    colormap jet
                    axis square
                    
                    set(gca, 'XTick', [1 17.5 33 50.5 65], 'XTickLabel', -96:48:96)
                    set(gca, 'YTick', [1 17.5 33 50.5 65], 'YTickLabel', -96:48:96)
                    axis([1 66 1 66])
                    
                    ylabel('Spatial Lag (cm)');
                    xlabel('Spatial Lag (cm)');
                    set(gca, 'FontSize', 12, 'FontName', 'Arial');
                    
                    
                end %bout
                
                if saveFigs == 1
                    cd(saveDir);
                    figName = ['R' num2str(r) 'S' num2str(s) 'U' num2str(u) '_contour'];
                    savefig(figName);
                    print(figName, '-dpng');
                    print(figName, '-dpdf');
                    close all;
                end
                
                
                
                % PLOT RATE-MAPS USING IMAGESC
                figure('Position', [2294 186 1241 671]);
                for b = 1:numBouts
                    
                    
                    % CALCULATE/PLOT RATEMAP
                    rateMap = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).rateMap;
                    
                    subplot(2,numBouts,b);
                    imagesc(1:size(rateMap,1), 1:size(rateMap,1), rateMap);
                    colormap jet
                    axis square
                    
                    set(gca, 'XTick', 0:8.25:33, 'XTickLabel', 0:25:100);
                    set(gca, 'YTick', 0:8.25:33, 'YTickLabel', 0:25:100);
                    axis([.5 33.5 .5 33.5])
                    
                    ylabel('Position (cm)');
                    xlabel('Position (cm)');
                    set(gca, 'FontSize', 12, 'FontName', 'Arial');
                    
                    title(['Bout ' num2str(b)]); 
                    
                    
                    % CALCULATE/PLOT AUTO-CORRELATION
                    autoCorr = rateMapXCorr(rateMap, rateMap);
                    
                    subplot(2,numBouts,numBouts+b);
                    imagesc(1:size(autoCorr,1), 1:size(autoCorr,1), autoCorr);
                    colormap jet
                    axis square
                    
                    set(gca, 'XTick', [1 17.5 33 50.5 65], 'XTickLabel', -96:48:96)
                    set(gca, 'YTick', [1 17.5 33 50.5 65], 'YTickLabel', -96:48:96)
                    axis([.5 66.5 .5 66.5])
                    
                    ylabel('Spatial Lag (cm)');
                    xlabel('Spatial Lag (cm)');
                    set(gca, 'FontSize', 12, 'FontName', 'Arial');
                    
                    
                end %bout
                
                if saveFigs == 1
                    cd(saveDir);
                    figName = ['R' num2str(r) 'S' num2str(s) 'U' num2str(u) '_imagesc'];
                    savefig(figName);
                    print(figName, '-dpng');
                    print(figName, '-dpdf');
                    close all;
                end
               
            end %if a grid cell
            
        end %unit
    end %session
end %rat




cd(curDir)
end %fnctn


