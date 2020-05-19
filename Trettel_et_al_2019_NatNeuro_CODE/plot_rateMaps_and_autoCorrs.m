function plot_rateMaps_and_autoCorrs(region)


saveFigs = 1;
saveDir = 'I:\STORAGE\LAB_STUFF\COLGIN_LAB\PROJECTS\Grid_Cell_Correlations_TrettelProj\MANUSCRIPT\NATURE_NEURO_SUBMISSION\REVISIONS\NEW_RESULTS\rateMapsAndAutoCorrs';

curDir = pwd;

reg = 1; %MEC
t = 2; %Task
d = 1; %Day


for r = 3:length(region(reg).rat)
    for s = 1:length(region(reg).rat(r).session)
        for u  = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(1).unit)
            if region(reg).rat(r).session(s).day(d).task(t).bout(1).unit(u).type == 1 %If a grid cell
                numBouts = length(region(reg).rat(r).session(s).day(d).task(t).bout);
                rateMap = zeros(33,33,numBouts);
                
                for b = 1:numBouts
                    
                    rateMap(:,:,b) = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).rateMap;
                    
                end %bout
                
                rateMap = nanmean(rateMap,3);
                autoCorr = rateMapXCorr(rateMap, rateMap);
                
%                 [~, ~, elpsCoords, ~, ~, angLnCoords] = get_gridfield_stats(autoCorr);
                
                
                % PLOT A VERSION USING IMAGESC
                figure('Position', [2067 359 1019 500]); 
                
                subplot(1,2,1);
                hold on;
                imagesc(rateMap);
                axis xy
                set(gca, 'XTick', 0:8.25:33, 'XTickLabel', 0:25:100); 
                set(gca, 'YTick', 0:8.25:33, 'YTickLabel', 0:25:100); 
                axis([.5 33.5 .5 33.5])
                axis square; 
                ylabel('Position (cm)'); 
                xlabel('Position (cm)'); 
                title({['R' num2str(r) 'S' num2str(s) 'U' num2str(u)]; 'Rate Map'}); 
                set(gca, 'FontSize', 12, 'FontName', 'Arial'); 
                
                subplot(1,2,2);
                hold on;
                imagesc(autoCorr)
                axis xy
%                 plot(elpsCoords(1,:), elpsCoords(2,:), 'r', 'LineWidth', 2);
%                 plot(angLnCoords(1,:,1), angLnCoords(2,:,1), 'r')
%                 for i = 2:3
%                     plot(angLnCoords(1,:,i), angLnCoords(2,:,i), 'k')
%                 end
                set(gca, 'XTick', [1 17.5 33 50.5 65], 'XTickLabel', -96:48:96)
                set(gca, 'YTick', [1 17.5 33 50.5 65], 'YTickLabel', -96:48:96)
                axis square; 
                ylabel('Spatial Lag (cm)'); 
                xlabel('Spatial Lag (cm)'); 
                title('Autocorrelation Map'); 
                set(gca, 'FontSize', 12, 'FontName', 'Arial'); 
                axis([.5 65.5 .5 65.5])
                
                if saveFigs == 1
                    cd(saveDir); 
                    figName = ['R' num2str(r) 'S' num2str(s) 'U' num2str(u) '_imagesc'];
                    savefig(figName); 
                    print(figName, '-dpng'); 
e                    print(figName, '-dpdf'); 
                    close all; 
                end
                
                
                
                 % PLOT A VERSION USING CONTOURF
                figure('Position', [2067 359 1019 500]); 
                
                subplot(1,2,1);
                hold on;
                contourf(1:size(rateMap,1), 1:size(rateMap,1), rateMap, 50, 'LineStyle', 'none')
                axis xy
                set(gca, 'XTick', 0:8.25:33, 'XTickLabel', 0:25:100); 
                set(gca, 'YTick', 0:8.25:33, 'YTickLabel', 0:25:100); 
                axis([1 33 1 33]); 
                axis square; 
                ylabel('Position (cm)'); 
                xlabel('Position (cm)'); 
                title({['R' num2str(r) 'S' num2str(s) 'U' num2str(u)]; 'Rate Map'}); 
                set(gca, 'FontSize', 12, 'FontName', 'Arial'); 
                
                subplot(1,2,2);
                hold on;
                 contourf(1:size(autoCorr,1), 1:size(autoCorr,1), autoCorr, 50, 'LineStyle', 'none')
                axis xy
%                 plot(elpsCoords(1,:), elpsCoords(2,:), 'r', 'LineWidth', 2);
%                 plot(angLnCoords(1,:,1), angLnCoords(2,:,1), 'r')
%                 for i = 2:3
%                     plot(angLnCoords(1,:,i), angLnCoords(2,:,i), 'k')
%                 end
                set(gca, 'XTick', [1 17.5 33 50.5 65], 'XTickLabel', -96:48:96)
                set(gca, 'YTick', [1 17.5 33 50.5 65], 'YTickLabel', -96:48:96)
                axis square; 
                ylabel('Spatial Lag (cm)'); 
                xlabel('Spatial Lag (cm)'); 
                title('Autocorrelation Map'); 
                set(gca, 'FontSize', 12, 'FontName', 'Arial'); 
                axis([1 66 1 66]); 
                
                if saveFigs == 1
                    cd(saveDir); 
                    figName = ['R' num2str(r) 'S' num2str(s) 'U' num2str(u) '_contour'];
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


