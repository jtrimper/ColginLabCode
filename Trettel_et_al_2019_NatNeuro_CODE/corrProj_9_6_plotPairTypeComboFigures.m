function corrProj_9_6_plotPairTypeComboFigures(pairType)
% function corrProj_9_6_plotPairTypeComboFigures(pairType)
%
% PURPOSE: 
%  Function to make a bunch of different figures for spatially modulated
%  and directionally tuned cell pairs. 
%
% INPUT: 
%  pairType = the structure outputted by corrProj_9_5... 
%
% OUTPUT: 
%  Figures
%
% JBT 1/2018
% Colgin Lab



%% MAKE WATERFALL PLOTS

zVals = 0; %set to 1 to use zscore
cZLims = [-1.75 3.75];
% zScoring NOT used (set to 0) for the waterfall plot in the paper,
%   but using it for measuring dispersion for revisions

binSize = 0.010; %ms
stateNames = {'RUN', 'REM', 'NREM'};
lagTtls = {'+/- 5 s'};

figNames = {'Spatially Modulated Cell Pairs', 'Direction Modulated Cell Pairs'};

for pc = 1:2 %pair combinations
    
    if pc == 1
        ptNums = [1 2 3];
    else
        ptNums = [3 4 6];
    end
    
    figure('name', figNames{pc}, 'Position', [ 280    81   780   592]);
    
    pCntr = 1;
    
    for pt = ptNums
        
        stXCorrsXState = cell(1,3); %1 x state
        srtVals = [];
        for cp = 1:length(pairType(pt).cellPair)
            if pc == 1
                srtVals = [srtVals pairType(pt).cellPair(cp).state(1).rmCorrCoeffs];  %#ok
            else
                srtVals = [srtVals pairType(pt).cellPair(cp).state(1).phiDifRatio]; %#ok
            end
            
            for s = 1:3
                
                %use non-normalized cross-corr
                tmpStXCorr = pairType(pt).cellPair(cp).state(s).stXCorr{3}; %10 ms bins
                
                if zVals == 1
                    tmpStXCorr = zscore(tmpStXCorr);
                else
                    tmpStXCorr = tmpStXCorr ./ mean(tmpStXCorr);
                end
                
                stXCorrsXState{s} = [stXCorrsXState{s}; tmpStXCorr'];
                
            end
        end
        
        if pc == 1
            [~,srtInds] = sort(srtVals);
        else
            [~,srtInds] = sort(srtVals, 'descend');
        end
        
        
        for s = 1:3
            
            % Plot +/-5 s
            subplot(3,3,(pCntr-1)*3+s);
            hold on;
            tmpXCorrs = stXCorrsXState{s};
            tmpXCorrs = tmpXCorrs(srtInds,:);
            xVals = 0:binSize:(size(tmpXCorrs,2)-1)*binSize;
            xVals = xVals - 5;
            imagesc(xVals, 1:size(tmpXCorrs,1),tmpXCorrs);
            axis xy
            colormap hot
            if zVals == 1
                caxis(cZLims);
            else
                caxis([.5 2]);
            end
            xlim([-5 5]);
            ylim([0 size(tmpXCorrs,1)]);
            set(gca, 'FontName', 'Arial')
            
            if pCntr == 1
                title({stateNames{s}; lagTtls{1}})
            end
            if s == 1
                ylabel({pairType(pt).name; 'Cell Pair ID'})
            end
            if pCntr == 3
                xlabel('Time Lag (s)');
            end
        end
        
        pCntr = pCntr + 1;
    end %pairType
end %pairCombos (spatial vs. direction mod)








%% MAKE SCATTER PLOTS
stateCols = {'Green', 'Gold', 'Purple'};


figNames = {'Spatially Modulated Cell Pairs', 'Direction Modulated Cell Pairs'};

for pc = 1:2 %pair combinations
    
    if pc == 1
        ptNums = [1 2 3];
    else
        ptNums = [3 4 6];
    end
    
    figure('name', figNames{pc}, 'Position', [ 280    81   780   592]);
    
    pCntr = 1;
    
    for pt = ptNums
        cpCorrVals = [];
        for cp = 1:length(pairType(pt).cellPair)
            for s = 1:3
                
                if s == 1
                    if pc == 1
                        srtVal = pairType(pt).cellPair(cp).state(s).rmCorrCoeffs;
                    else
                        srtVal = pairType(pt).cellPair(cp).state(s).phiDifRatio;
                    end
                end
                
                midSum(s) = pairType(pt).cellPair(cp).state(s).midSum(1);%#ok
            end %state
            
            cpCorrVals = [cpCorrVals; srtVal midSum ]; %#ok
            
        end %cell pair
        
        
        % PLOTTING
        for s = 1:3
            
            %Calculate correlation coefficients
            [rVal, pVal] = corr(cpCorrVals(:,1), cpCorrVals(:,s+1));
            
            %Do the actual plotting
            subplot(3,3,(pCntr-1)*3+s);
            hold on;
            plot(cpCorrVals(:,1), cpCorrVals(:,s+1), 'o', 'Color', rgb(stateCols{s}), 'MarkerFaceColor', rgb(stateCols{s}), 'MarkerSize', 3);
            
            lineCoefs = polyfit(cpCorrVals(:,1), cpCorrVals(:,s+1), 1);
            slope = lineCoefs(1);
            yInt = lineCoefs(2);
            lnCoords = [-.3*slope+yInt 1*slope+yInt];
            ln = line([-.3 1], lnCoords);
            set(ln, 'Color', [0 0 0], 'LineWidth', 2);
            
            if pCntr == 1
                title({stateNames{s}; ['r = ' num2str(round(rVal,4)) '; p = ' num2str(round(pVal,4))]})
            else
                title(['r = ' num2str(round(rVal,4)) '; p = ' num2str(round(pVal,4))])
            end
            if s == 1
                ylabel({pairType(pt).name; 'Cross-Correlation'; 'Coefficient'})
            end
            if pCntr == 3 && s == 2
                if pc == 1
                    xlabel('Rate Map Correlation Coefficient')
                else
                    xlabel('Relative Angular Distance')
                end
            end
            set(gca, 'FontName', 'Arial');
            ylim([0 .2]);
            set(gca, 'YTick', 0:.05:.2);
            if pc == 1
                xlim([-.4 1]);
                set(gca, 'XTick', -.3:.3:.9);
            else
                xlim([0 1]);
                set(gca, 'XTick', 0:.25:1, 'XTickLabel', 0:45:180);
            end
            stats(1,pCntr,s) = rVal; %#ok
            stats(2,pCntr,s) = pVal; %#ok
        end
        
        pCntr = pCntr + 1;
    end %pairType
    
    % Print out stats
    fprintf('\n%s:\n', figNames{pc});
    fprintf('\t\tStats:\n');
    for pt = 1:3
        fprintf('\t\t\t%s\n', pairType(pt).name);
        for s = 1:3
            fprintf('\t\t\t\t%s:\n', stateNames{s});
            fprintf('\t\t\t\t\tr = %0.06g\n', stats(1,pt,s));
            fprintf('\t\t\t\t\tp = %0.06g\n', stats(2,pt,s));
        end
    end
    
    
end %pairCombos (spatial vs. direction mod)




%% MAKE LINE GRAPHS

stateNames = {'RUN', 'REM', 'NREM'};
binSizes = {'+/-5ms', '+/-50ms'};
stateCols = {'Green', 'Gold', 'Purple'};

binEdges(1,:) = 0:.25:1;
binEdges(2,:) = 0:.2:.8;

for pc = 1:2 %pair combinations
    
    if pc == 1
        ptNums = [1 2 3];
    else
        ptNums = [3 4 6];
    end
    
    scaled5BinFig = figure('name', [figNames{pc} ': Normalized, 5 Bins'], 'Position', [ 360   209   834   646]);
    unscaled5BinFig = figure('name', [figNames{pc} ': Non-normalized, 5 Bins'], 'Position', [ 360   209   834   646]);
    
    pCntr = 1;
    
    for pt = ptNums
        
        fiveBinVals = cell(2,5);
        
        for cp = 1:length(pairType(pt).cellPair)
            for s = 1:3
                
                if s == 1
                    if pc == 1
                        relDist = pairType(pt).cellPair(cp).state(s).relSpatPhiMag;
                    else
                        relDist = pairType(pt).cellPair(cp).state(s).phiDifRatio;
                    end
                end
                
                midSum5(s) = pairType(pt).cellPair(cp).state(s).midSum(1);%#ok
                midSum50(s) = pairType(pt).cellPair(cp).state(s).midSum(2);%#ok
                
            end %state
            
            %for 5 bins
            binInd = find(binEdges(pc,:)<=relDist, 1, 'Last');
            fiveBinVals{1,binInd} = [fiveBinVals{1,binInd}; midSum5];
            fiveBinVals{2,binInd} = [fiveBinVals{2,binInd}; midSum50];
            
        end %cell pair
        
        
        %% PLOT FIVE BIN VERSION
        
        %   First, plot the non-normalized version
        figure(unscaled5BinFig);
        AVG = zeros(5,3);
        SEM = zeros(5,3);
        goodXVals = [];
        for bs = 1:2 %bin size (5 or 50)
            for bn = 1:5 %bin # (1-5)
                if ~isempty(fiveBinVals{bs,bn})
                    AVG(bn,:) = mean(fiveBinVals{bs,bn},1);
                    SEM(bn,:) = semfunct(fiveBinVals{bs,bn},1);
                    if bs == 1
                        goodXVals = [goodXVals bn];%#ok
                    end
                end
            end
            
            subplot(3,2,(pCntr-1)*2+bs);
            hold on;
            for s = 1:3
                tmpLn(s) = plot(goodXVals, AVG(goodXVals,s));%#ok
                set(tmpLn(s), 'Color', rgb(stateCols{s}), 'LineWidth', 2);
                errorbar(goodXVals, AVG(goodXVals,s), SEM(goodXVals,s), 'Color', rgb(stateCols{s}), 'LineStyle', 'None', 'LineWidth', 1.5, 'CapSize', 0);
            end
            set(gca, 'XLim', [.9 5.1], 'XTick', 1:5, 'FontName', 'Arial');
            if bs == 1
                if pCntr == 2
                    ylabel({pairType(pt).name; 'Cross-Correlation Coefficient'});
                else
                    ylabel({pairType(pt).name; ''});
                end
            end
            
            if pc == 1
                set(gca, 'XTickLabel', {'0.00 - 0.25', '0.25 - 0.50', '0.50 - 0.75', '0.75 - 1.00', '>1.00'})
                if pCntr == 1
                    title(binSizes{bs});
                elseif pCntr == 3
                    xlabel('Relative Spatial Phase');
                end
            else
                set(gca, 'XTickLabel', {'0-36', '36-72', '72-108', '108-144', '144-180'})
                if pCntr == 1
                    title(binSizes{bs});
                elseif pCntr == 3
                    xlabel('Relative Angular Distance');
                end
            end
            
            yBnds = get(gca, 'YLim');
            ylim([0 yBnds(2)]);
            
            maxAVG(bs,:) = max(AVG); %#ok -- for scaled figure
            
            if (pCntr-1)*2+bs == 2
                leg = legend(tmpLn, stateNames);
                set(leg, 'Box', 'Off', 'FontName', 'Arial', 'FontWeight', 'Bold');
            end
            
        end
        
        
        %  Then, plot the normalized version
        figure(scaled5BinFig);
        goodXVals = [];
        for bs = 1:2 %bin size (5 or 50)
            for bn = 1:5 %bin # (1-5)
                for s = 1:3
                    if ~isempty(fiveBinVals{bs,bn})
                        %normalize all individual values to the max average across bins for each state
                        tmpNormVals = fiveBinVals{bs,bn}(:,s) ./ maxAVG(bs,s);
                        
                        AVG(bn,s) = mean(tmpNormVals,1);
                        SEM(bn,s) = semfunct(tmpNormVals,1);
                        
                        if bs == 1
                            goodXVals = [goodXVals bn];%#ok
                        end
                    end
                end
            end
            
            subplot(3,2,(pCntr-1)*2+bs);
            hold on;
            for s = 1:3
                tmpLn(s) = plot(goodXVals, AVG(goodXVals,s));
                set(tmpLn(s), 'Color', rgb(stateCols{s}), 'LineWidth', 2);
                errorbar(goodXVals, AVG(goodXVals,s), SEM(goodXVals,s), 'Color', rgb(stateCols{s}), 'LineStyle', 'None', 'LineWidth', 1.5, 'CapSize', 0);
            end
            set(gca, 'XLim', [.9 5.1], 'XTick', 1:5, 'FontName', 'Arial');
            if bs == 1
                if pCntr == 2
                    ylabel({pairType(pt).name; 'Cross-Correlation Coefficient'});
                else
                    ylabel({pairType(pt).name; ''});
                end
            end
            
            if pc == 1
                set(gca, 'XTickLabel', {'0.00 - 0.25', '0.25 - 0.50', '0.50 - 0.75', '0.75 - 1.00', '>1.00'})
                if pCntr == 1
                    title(binSizes{bs});
                elseif pCntr == 3
                    xlabel('Relative Spatial Phase');
                end
            else
                set(gca, 'XTickLabel', {'0-36', '36-72', '72-108', '108-144', '144-180'})
                if pCntr == 1
                    title(binSizes{bs});
                elseif pCntr == 3
                    xlabel('Relative Angular Distance');
                end
            end
            
        end
        ylim([0 1.4]);
        
        if (pCntr-1)*2+bs == 2
            leg = legend(tmpLn, stateNames);
            set(leg, 'Box', 'Off', 'FontName', 'Arial', 'FontWeight', 'Bold');
        end
        
        pCntr = pCntr + 1;
    end %pairType
end %pairCombos (spatial vs. direction mod)




end%fnctn