function corrProj_9_16_plotRateMapsAndCrossCorrsForGoodPairs(cellRegion, region)

%            r  s  b  tt1  u1  tt2  u2
exampUsed = [3  3  1   12   3   11  1]; 
exampUsed = [6  4  1    6   4    9  1]; 


curDir = pwd;
cd('C:\Users\John\Desktop\LAB_STUFF\PROJECTS\Grid_Cell_Correlations_TrettelProj\MANUSCRIPT\NATURE_NEURO_SUBMISSION\REVISIONS\RND_3\CellPair_RateMapsAndCrossCorrs');

for cp = 1:length(cellRegion(1).cellPair)
   
    
    fprintf('Cell Pair %d\n', cp);
    
    rNum = cellRegion(1).cellPair(cp).info(1);
    sNum = cellRegion(1).cellPair(cp).info(2);
    u1TetNum = cellRegion(1).cellPair(cp).info(4);
    u1UnitNum = cellRegion(1).cellPair(cp).info(5);
    u2TetNum = cellRegion(1).cellPair(cp).info(6);
    u2UnitNum = cellRegion(1).cellPair(cp).info(7);
    
    
    
    
    for sesCp = 1:length(region(1).rat(rNum).session(sNum).state(1).cellPair)
        inSesUIDs = region(1).rat(rNum).session(sNum).state(1).cellPair(sesCp).unitIDs;
        if inSesUIDs(1,1)==u1TetNum   &&   inSesUIDs(1,2)==u1UnitNum  &&  inSesUIDs(2,1)==u2TetNum   &&   inSesUIDs(2,2)==u2UnitNum
            
            rateMaps = mean(region(1).rat(rNum).session(sNum).state(1).cellPair(sesCp).rateMaps,4);
            rmXCorr = region(1).rat(rNum).session(sNum).state(1).cellPair(sesCp).rmXCorr;
            
            tmpFig = figure('Position', [394 227 1029 626], 'name', ['Cell Pair #' num2str(cp)]);
            for u = 1:2
                subplot(2,3,u)
                imagesc(rateMaps(:,:,u))
                colormap jet
                set(gca, 'XTick', [1 8.25 16.5 24.75 33], 'XTickLabel', {-50 [] 0 [] 50});
                set(gca, 'YTick', [1 8.25 16.5 24.75 33], 'YTickLabel', {-50 [] 0 [] 50});
                line([0 33], [8.25 8.25], 'Color', [1 1 1], 'LineWidth', 1.5);
                line([0 33], [16.5 16.5], 'Color', [1 1 1], 'LineWidth', 1.5);
                line([0 33], [24.75 24.75], 'Color', [1 1 1], 'LineWidth', 1.5);
                line([8.25 8.25],[0 33], 'Color', [1 1 1], 'LineWidth', 1.5);
                line([16.5 16.5],[0 33], 'Color', [1 1 1], 'LineWidth', 1.5);
                line([24.75 24.75],[0 33], 'Color', [1 1 1], 'LineWidth', 1.5);
                axis square;
                
                subplot(2,3,3+u)
                contourf(rateMaps(:,:,u), 30, 'LineStyle', 'none')
                colormap jet
                set(gca, 'XTick', [1 8.25 16.5 24.75 33], 'XTickLabel', {-50 [] 0 [] 50});
                set(gca, 'YTick', [1 8.25 16.5 24.75 33], 'YTickLabel', {-50 [] 0 [] 50});
                line([0 33], [8.25 8.25], 'Color', [1 1 1], 'LineWidth', 1.5);
                line([0 33], [16.5 16.5], 'Color', [1 1 1], 'LineWidth', 1.5);
                line([0 33], [24.75 24.75], 'Color', [1 1 1], 'LineWidth', 1.5);
                line([8.25 8.25],[0 33], 'Color', [1 1 1], 'LineWidth', 1.5);
                line([16.5 16.5],[0 33], 'Color', [1 1 1], 'LineWidth', 1.5);
                line([24.75 24.75],[0 33], 'Color', [1 1 1], 'LineWidth', 1.5);
                axis square;
            end
            
            subplot(2,3,3);
            imagesc(rmXCorr)
            colormap jet;
            set(gca, 'XTick', [1 16.25 32.5 48.75 65], 'XTickLabel', {-100 [] 0 [] 100});
            set(gca, 'YTick', [1 16.25 32.5 48.75 65], 'YTickLabel', {-100 [] 0 [] 100});
            line([0 65], [32.5 32.5], 'Color', [0 0 0], 'LineWidth', 1.5);
            line([32.5 32.5], [0 65], 'Color', [0 0 0], 'LineWidth', 1.5);
            axis square;
            axis xy; 
            
            subplot(2,3,6);
            contourf(rmXCorr, 30, 'LineStyle', 'none')
            colormap jet;
            set(gca, 'XTick', [1 16.25 32.5 48.75 65], 'XTickLabel', {-100 [] 0 [] 100});
            set(gca, 'YTick', [1 16.25 32.5 48.75 65], 'YTickLabel', {-100 [] 0 [] 100});
            line([0 65], [32.5 32.5], 'Color', [0 0 0], 'LineWidth', 1.5);
            line([32.5 32.5], [0 65], 'Color', [0 0 0], 'LineWidth', 1.5);
            axis square;
            axis xy; 
            
            print(['CP' num2str(cp)], '-dpng');
            close(tmpFig);
        end
    end
    
end %cellPair

cd(curDir)

end %fnctn


