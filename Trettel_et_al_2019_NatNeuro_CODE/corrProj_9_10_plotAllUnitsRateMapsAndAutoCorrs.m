function corrProj_9_10_plotAllUnitsRateMapsAndAutoCorrs(region)
% function corrProj_9_10_plotAllUnitsRateMapsAndAutoCorrs(region)
%
% PURPOSE:
%   To plot rate maps and autocorrelations for all units, not just for grid cells (as
%   in plot_rateMaps_and_autoCorrs).
%
%
%



saveFigs = 1;
saveDir = 'F:\STORAGE\LAB_STUFF\COLGIN_LAB\PROJECTS\Grid_Cell_Correlations_TrettelProj\MANUSCRIPT\NATURE_NEURO_SUBMISSION\REVISIONS\NEW_RESULTS\rateMapsAndAutoCorrs';

curDir = pwd;

reg = 1;
t = 2;
d = 1;

for r = 1:length(region(reg).rat)
    fprintf('Rat %d\n', r);
    for s = 1:length(region(reg).rat(r).session)
        fprintf('\tSession %d\n', s);
        
        spkCnt = zeros(33,33,length(region(reg).rat(r).session(s).day(d).task(t).bout(1).unit));
        timePerBin = zeros(33,33,length(region(reg).rat(r).session(s).day(d).task(t).bout(1).unit));
        
        cellTypes = cell(1,length(region(reg).rat(r).session(s).day(d).task(t).bout(1).unit)); 
        ctFigAbbrevs = cell(1,length(region(reg).rat(r).session(s).day(d).task(t).bout(1).unit)); 
        for b = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout)
            fprintf('\t\tBout %d\n', b);
            coords = region(reg).rat(r).session(s).day(d).task(t).bout(b).coords;
            for u = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit)
                fprintf('\t\t\tUnit %d\n', u);
                spkTms = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).spkTms;
                
                [~, tmpCnt, tmpTpb] = get_ratemap(spkTms, coords, [100 100], 3, [], 1); %get velocity filtered ratemap
                
                spkCnt(:,:,u) = spkCnt(:,:,u) + tmpCnt;
                tmpTpb(isnan(tmpTpb)) = 0;
                timePerBin(:,:,u) = timePerBin(:,:,u) + tmpTpb;
                
                if b == 1
                    gridOrNot = region(reg).rat(r).session(s).day(d).task(t).bout(1).unit(u).type;
                    hdModOrNot = region(reg).rat(r).session(s).day(d).task(t).bout(1).unit(u).hdMod;
                    
                    if gridOrNot == 1 && hdModOrNot == 0
                        cellTypes{u} = 'Grid Cell';
                        ctFigAbbrevs{u} = 'GC';
                    elseif gridOrNot == 1 && hdModOrNot == 1
                        cellTypes{u} = 'Conjunctive Cell';
                        ctFigAbbrevs{u} = 'CJ';
                    elseif gridOrNot == 2 & hdModOrNot == 1 %#ok
                        cellTypes{u} = 'Head Direction Cell';
                        ctFigAbbrevs{u} = 'HD';
                    else
                        cellTypes{u} = 'Unclassified Cell';
                        ctFigAbbrevs{u} = 'UC';
                    end
                end
                
                
            end %unit
        end %bout
        
        rateMap = spkCnt ./ timePerBin;
        
        for u = 1:size(rateMap,3)
            
            rateMap(:,:,u) = gc_ratemap_smooth(rateMap(:,:,u)); % <- smooth with a normalized version of the window Sean said to use
            
            figure('Position', [2067 359 1019 500]);
            
            subplot(1,2,1);
            hold on;
            contourf(1:size(rateMap,1), 1:size(rateMap,1), rateMap(:,:,u), 50, 'LineStyle', 'none')
            axis xy
            set(gca, 'XTick', 0:8.25:33, 'XTickLabel', 0:25:100);
            set(gca, 'YTick', 0:8.25:33, 'YTickLabel', 0:25:100);
            axis([1 33 1 33]);
            axis square;
            ylabel('Position (cm)');
            xlabel('Position (cm)');
            title({[cellTypes{u} ' - R' num2str(r) 'S' num2str(s) 'U' num2str(u)]; 'Rate Map'});
            set(gca, 'FontSize', 12, 'FontName', 'Arial');
            
            autoCorr = rateMapXCorr(rateMap(:,:,u), rateMap(:,:,u));
            
            subplot(1,2,2);
            hold on;
            contourf(1:size(autoCorr,1), 1:size(autoCorr,1), autoCorr, 50, 'LineStyle', 'none')
            axis xy
            
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
                cd('contour');
                figName = [ctFigAbbrevs{u} '_R' num2str(r) 'S' num2str(s) 'U' num2str(u) '_contour'];
                %                     savefig(figName);
                print(figName, '-dpng');
                %                     print(figName, '-dpdf');
                close all;
            end
            
        end
        
    end %session
end %rat

cd(curDir);


end %function