function plot_grid_cell_examples_for_LSRF_grant(region)

reg = 1;
d = 1;
t = 2;

curDir = pwd; 
saveDir = 'I:\STORAGE\LAB_STUFF\COLGIN_LAB\OTHER\LSRF_FELLOWSHIP_APP\IMGS\GridCellMaps'; 
cd(saveDir); 

% for r = 1:length(region(reg).rat)
for r = 2
    %     for s = 1:length(region(reg).rat(r).session)
    for s = 2
        coords = [];
        
        numGCs = 0;
        for u = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(1).unit)
            if region(reg).rat(r).session(s).day(d).task(t).bout(1).unit(u).type == 1
                numGCs = numGCs + 1;
            end
        end
        
        rateMaps = nan(33,33,numGCs,length(region(reg).rat(r).session(s).day(d).task(t).bout));
        spkTms = cell(1,numGCs); 
        for b = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout)
            coords = [coords; region(reg).rat(r).session(s).day(d).task(t).bout(b).coords]; %#ok
            for u = 1:numGCs
                spkTms{u} = [spkTms{u}; region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).spkTms];
                rateMaps(:,:,u,b) = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).rateMap;
            end %unit
        end %bout
        
        rateMaps = nanmean(rateMaps,4); 
        
        for u = 1:numGCs
            figure('name', ['R' num2str(r) '; S' num2str(s) '; U' num2str(u)], 'Position', [560 528 560 210]); 
            
            if u == 3; keyboard; end
            
            % Plot spikes superimposed over path
            subplot(1,3,1); 
            plot(coords(:,2), coords(:,3), 'Color', [.5 .5 .5])
            hold on; 
            spkCrds = []; 
            for st = 1:length(spkTms{u})
                tmpSpk = spkTms{u}(st); 
                coordInd = find(coords(:,1)<=tmpSpk, 1, 'Last'); 
                spkCrds = [spkCrds; coords(coordInd,2), coords(coordInd,3)]; %#ok
            end
            plot(spkCrds(:,1), spkCrds(:,2), 'r.'); 
            set(gca, 'FontName', 'Arial', 'FontSize', 9); 
            axis([0 100 0 100])
            axis square
            title('Spike Locations'); 
            ylabel('Position (cm)'); 
            xlabel('Position (cm)'); 
            
            % Plot average rate map
            subplot(1,3,2); 
            plot_2d_nan_ratemap(rateMaps(:,:,u)); 
            axis([0 33 0 33])
            axis square
            set(gca, 'XTick', [0 16.5 33], 'XTickLabel', [0 50 100]); 
            set(gca, 'YTick', [0 16.5 33], 'YTickLabel', [0 50 100]); 
            set(gca, 'FontName', 'Arial', 'FontSize', 9); 
            title('Rate Map'); 
            xlabel('Position (cm)'); 
            
            if u == 3; keyboard; end
            
            % Plot autocorrelation
            subplot(1,3,3); 
            hold on; 
            ccMap = rateMapXCorr(rateMaps(:,:,u),rateMaps(:,:,u));
            plot_2d_nan_ratemap(ccMap); 
            axis([0 65 0 65])
            set(gca, 'XTick', [0 32.5 65], 'XTickLabel', [-100 0 100]); 
            set(gca, 'YTick', [0 32.5 65], 'YTickLabel', [-100 0 100]); 
            set(gca, 'FontName', 'Arial', 'FontSize', 9); 
            xlabel('Position (cm)'); 
            axis square
            title('Auto-Correlation'); 
            
            print(['R' num2str(r) 'S' num2str(s) 'U', num2str(u)], '-dpdf'); 
            close all; 
            
        end
        
    end %session
end %rat

cd(curDir); 

end %fnctn