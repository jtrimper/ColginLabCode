function corrProj_9_8_analyzeIntraVsTransModuleCellPairs(modGrouping)
% function corrProj_9_8_analyzeIntraVsTransModuleCellPairs(modGrouping)


doAbs = 0; % set to 1 to use absolute values of midSums rather than raw vals. 

%% MAKE WATERFALL PLOTS

zVals = 1; %set to 1 to use zscore
cZLims = [-1.75 3.75];
% zScoring NOT used (set to 0) for the waterfall plot in the main paper (Fig 2)
%   but you DO want to keep it set to 1 here

modNames = {'Intra-', 'Trans-'};
binSizes = [0.002 0.005 0.010 0.050]; %ms
stateNames = {'RUN', 'REM', 'NREM'};
lagTtls = {'+/- 5 s', '+/- 1 s'};

binFig = zeros(1,4);
for b = 1:4
    binFig(b) = figure('name', ['Bin Size = ' num2str(binSizes(b)*1000) ' ms'], 'Position', [ 280    81   780   592]);
end

midSums = cell(1,2);
kVals = cell(1,2);
rmCcs = cell(1,2);
spatPerRats = cell(1,2);
for g = 1:2
    stXCorrsXState = cell(4,3); %binSize x state
    for cp = 1:length(modGrouping(g).cellPair)
        rmCcs{g} = [rmCcs{g} modGrouping(g).cellPair(cp).state(1).rmCorrCoeffs];
        spatPerRats{g} = [spatPerRats{g} modGrouping(g).cellPair(cp).state(1).spatPerRatio];
        for s = 1:3
            for b = 1:4 %bin
                
                %use non-normalized cross-corr
                tmpStXCorr = modGrouping(g).cellPair(cp).state(s).stXCorr{b};
                
                if zVals == 1
                    tmpStXCorr = zscore(tmpStXCorr);
                else
                    tmpStXCorr = tmpStXCorr ./ mean(tmpStXCorr);
                end
                
%                 %use non-normalized cross-corr
%                 tmpStXCorr = modGrouping(g).cellPair(cp).state(s).normStXCorr{b}';
                
                stXCorrsXState{b,s} = [stXCorrsXState{b,s}; tmpStXCorr'];
                
            end
        end
    end
    [rmCcs{g},srtInds] = sort(rmCcs{g});
    
    spatPerRats{g} = spatPerRats{g}(srtInds);
    midSums{g} = zeros(5,3,length(rmCcs{g}));
    kVals{g} = zeros(4,3,length(rmCcs{g}));
    for b = 1:4
        
        figure(binFig(b));
        
        for s = 1:3
            
            % Plot +/-5 s
            subplot(2,4,(g-1)*4+s);
            hold on;
            tmpXCorrs = stXCorrsXState{b,s};
            tmpXCorrs = tmpXCorrs(srtInds,:);
            xVals = 0:binSizes(b):(size(tmpXCorrs,2)-1)*binSizes(b);
            xVals = xVals - 5;
            
            % Get mid-sums
            midInd = median(1:length(xVals));
            startMid = find(xVals(1:midInd)>=-.005, 1, 'First');
            endMid = find(xVals(midInd:end)<=.005, 1, 'Last');
            endMid = endMid + midInd - 1;
            if doAbs == 1
                midSums{g}(b+1,s,:) = abs(sum(tmpXCorrs(:,startMid:endMid),2));
                if b == 1
                    midSums{g}(b,s,:) = abs(tmpXCorrs(:,midInd));
                end
            else
                midSums{g}(b+1,s,:) = sum(tmpXCorrs(:,startMid:endMid),2);
                if b == 1
                    midSums{g}(b,s,:) = tmpXCorrs(:,midInd);
                end
            end
            
            % Get kurtosis
            startMid = find(xVals(1:midInd)>=-1, 1, 'First');
            endMid = find(xVals(midInd:end)<=1, 1, 'Last');
            endMid = endMid + midInd - 1;
            kVals{g}(b,s,:) = kurtosis(tmpXCorrs(:,startMid:endMid),[],2);
            
            
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
            
            if g == 1
                title({stateNames{s}; lagTtls{1}})
            end
            
            if s == 1
                ylabel({[modNames{g} 'Module']; [num2str(binSizes(b)*1000) ' ms Bins']; 'Cell Pair ID'})
            end
            if g == 2
                xlabel('Time Lag (s)');
            end
            
        end
        
        % Plot +/-1 s
        subplot(2,4,(g-1)*4+4);
        midInd = median(1:size(tmpXCorrs,2));
        oneSecNumInds = 1/binSizes(b);
        numInds = 2*oneSecNumInds+1;
        xVals = 0:binSizes(b):(numInds-1)*binSizes(b);
        xVals = xVals - 1;
        imagesc(xVals, 1:size(tmpXCorrs,1), tmpXCorrs(:,midInd-oneSecNumInds:midInd+oneSecNumInds))
        xlim([-1 1]);
        axis xy
        colormap hot
        
        if zVals == 1
            caxis(cZLims);
        else
            caxis([.5 2]);
        end
        
        ylim([0 size(tmpXCorrs,1)]);
        set(gca, 'FontName', 'Arial')
        if g == 1
            title({stateNames{s}; lagTtls{2}})
        end
        if g == 2
            xlabel('Time Lag (s)');
        end
        
    end %bin Size
    
end



%% PLOT CUMULATIVE DISTRIBUTIONS OF MID-SUMS
midSumRanges = [-1 1; -5 5; -7.5 7.5; -5 5; -25 25];
modCols = {'Blue', 'Black'};

figure('Position', [1 31  1680  943])
for b = 1:5
    for s = 1:3
        subplot(5,3,(b-1)*3+s);
        hold on;
        xMax = -inf;
        for g = 1:2
            [yy,xx] = cdfcalc(midSums{g}(b,s,:));
            k = length(xx);
            n = reshape(repmat(1:k, 2, 1), 2*k, 1);
            xCDF    = [-Inf; xx(n); Inf];
            yCDF    = [0; 0; yy(1+n)];
            ln(g) = plot(xCDF, yCDF, 'Color', rgb(modCols{g}));
            if max(xCDF)>xMax
                xMax = xCDF(end);
            end
        end
        %         xlim([0 xMax]);
        if b == 1
            title(stateNames{s});
        end
        if b == 5
            xlabel('Central Cross-Corr Sum');
        end
        if s == 1
            if b > 1
                tmpB = b -1;
            else
                tmpB = b;
            end
            ylabel({[num2str(binSizes(tmpB)*1000) ' ms bins']; ['[' num2str(midSumRanges(b,1)) '  ' num2str(midSumRanges(b,2)) ' ms]']; 'Cum. Probability'});
        end
        set(gca, 'FontName', 'Arial');
    end
    if b == 1
        leg = legend(ln, modNames);
        set(leg, 'Box', 'Off', 'Location', 'SouthEast', 'FontSize', 12);
    end
end


%% RUN ANSARI-BRADLEY DISPERSION TEST
fprintf('\n\nANSARI-BRADLEY DISPERSION TEST:\n'); 
for b = 1:5
    if b == 1
        fprintf('\tBin Size: Mid 2ms Bin Only, Summed from %0.02g to %0.02g ms\n', round(midSumRanges(b,:),2));
    else
        fprintf('\tBin Size: %d ms, , Summed from %0.02g to %0.02g ms\n', binSizes(b-1)*1000, round(midSumRanges(b,:),2));
    end
    for s = 1:3
        group = struct();
        for g = 1:2
            group(g).data = squeeze(midSums{g}(b,s,:));
        end
        [~,P,STATS] = ansaribradley(group(1).data, group(2).data);
        fprintf('\t\t%s: W* = %0.04g, p = %0.04g\n', stateNames{s}, STATS.Wstar, P);
    end
end


%% PLOT HISTOGRAMS OF MID-SUMS
figure('Position', [1 31  1680  943])
for b = 1:5
    for s = 1:3
        subplot(5,3,(b-1)*3+s);
        hold on;
        xMax = -inf;
        for g = 1:2
            [cnts,edges] = histcounts(midSums{g}(b,s,:), 'Normalization', 'Probability', 'BinWidth', 1);
            edges = edges_to_x_vals(edges);
            edges = [edges(1) - mean(diff(edges))  edges   edges(end) + mean(diff(edges))]; %#ok
            cnts = [0 cnts 0]; %#ok
            ln(g) = plot(edges,cnts, 'Color', rgb(modCols{g}));
            if max(edges)>xMax
                xMax = edges(end);
            end
        end
%         xlim([0 xMax]);
        if b == 1
            title(stateNames{s});
        end
        if b == 5
            xlabel('Central Cross-Corr Sum');
        end
        if s == 1
            if b > 1
                tmpB = b -1;
            else
                tmpB = b;
            end
            ylabel({[num2str(binSizes(tmpB)*1000) ' ms bins']; ['[' num2str(midSumRanges(b,1)) '  ' num2str(midSumRanges(b,2)) ' ms]']; 'Probability'});
        end
        set(gca, 'FontName', 'Arial');
    end
    if b == 1
        leg = legend(ln, modNames);
        set(leg, 'Box', 'Off', 'Location', 'SouthEast', 'FontSize', 12);
    end
end






%% PLOT AVERAGE OF MID-SUMS BARGRAPH

stateCols = {'Green', 'Gold', 'Purple'};

xVals = [1 4 7; 2 5 8];
AVG = zeros(5,3,2);
ERR = zeros(5,3,2);
yMaxs = [2 10 6 2 2];

figure('Position', [494    72   595   879])
for g = 1:2
    AVG(:,:,g) = nanmean(midSums{g},3);
    ERR(:,:,g) = nansemfunct(midSums{g},3);
end

fprintf('\n\nINDEPENDENT T-TEST RESULTS FOR MID-SUMS:\n');
for b = 1:5
    if b == 1
        fprintf('\tBin Size: Mid 2ms Bin Only Summed from %0.02g to %0.02g ms\n', round(midSumRanges(b,:),2));
        tmpB = b; 
    else
        fprintf('\tBin Size: %d ms, , Summed from %0.02g to %0.02g ms\n', binSizes(b-1)*1000, round(midSumRanges(b,:),2));
        tmpB = b-1; 
    end
    for s = 1:3
        fprintf('\t\t%s: ', stateNames{s});
        subplot(5,1,b);
        hold on;
        group = struct();
        for g = 1:2
            
            bg = bar(xVals(g,s), AVG(b,s,g));
            if g == 1
                set(bg, 'FaceColor', rgb(stateCols{s}));
            else
                set(bg, 'FaceColor', [1 1 1], 'EdgeColor', rgb(stateCols{s}), 'LineWidth', 1.5);
            end
            tmpERR = reshape(squeeze(ERR(b,:,:))',1,6);
            tmpAVG = reshape(squeeze(AVG(b,:,:))',1,6);
            eb = errorbar(sort(xVals(:)), tmpAVG, tmpERR);
            set(eb, 'LineStyle', 'none', 'Color', [0 0 0], 'LineWidth', 1, 'CapSize', 0)
            
            %             ylim([0 yMaxs(b)]);
            
            group(g).data = squeeze(midSums{g}(b,s,:));
        end
        
        [~,P,~,STATS] = ttest2(group(1).data, group(2).data);
        fprintf('t(%d) = %0.04g, p = %0.04g\n', STATS.df, STATS.tstat, P);
        
    end
    title([num2str(binSizes(tmpB)*1000) ' ms Bins; Cross-Corr Summed Across [' num2str(midSumRanges(b,1)) '  ' num2str(midSumRanges(b,2)) ' ms]'])
    ylabel('Cross-Corr Sum');
    set(gca, 'XTick', [1.5 4.5 7.5], 'XTickLabel', stateNames, 'FontName', 'Arial')
end





%% PLOT KURTOSIS BAR GRAPH

stateCols = {'Green', 'Gold', 'Purple'};

xVals = [1 4 7; 2 5 8];
AVG = zeros(4,3,2);
ERR = zeros(4,3,2);

figure('Position', [494    72   595   879])
for g = 1:2
    AVG(:,:,g) = nanmean(kVals{g},3);
    ERR(:,:,g) = nansemfunct(kVals{g},3);
end

for b = 1:4
    for s = 1:3
        subplot(4,1,b);
        hold on;
        
        for g = 1:2
            
            bg = bar(xVals(g,s), AVG(b,s,g));
            if g == 1
                set(bg, 'FaceColor', rgb(stateCols{s}));
            else
                set(bg, 'FaceColor', [1 1 1], 'EdgeColor', rgb(stateCols{s}), 'LineWidth', 1.5);
            end
            tmpERR = reshape(squeeze(ERR(b,:,:))',1,6);
            tmpAVG = reshape(squeeze(AVG(b,:,:))',1,6);
            eb = errorbar(sort(xVals(:)), tmpAVG, tmpERR);
            set(eb, 'LineStyle', 'none', 'Color', [0 0 0], 'LineWidth', 1, 'CapSize', 0)
            
        end
        
    end
    title([num2str(binSizes(b)*1000) ' ms Bins; Cross-Corr Summed Across [' num2str(midSumRanges(b,1)) '  ' num2str(midSumRanges(b,2)) ' ms]'])
    ylabel('Kurtosis');
    set(gca, 'XTick', [1.5 4.5 7.5], 'XTickLabel', stateNames, 'FontName', 'Arial')
end




%% PLOT KURTOSIS DIFFERENCE BAR GRAPH

stateCols = {'Green', 'Gold', 'Purple'};

figure('Position', [494    72   595   879])

fprintf('\n\nINDEPENDENT T-TEST RESULTS FOR KURTOSIS:\n');
for b = 1:4
    fprintf('\tBin Size: %d ms\n', binSizes(b)*1000);
    
    subplot(4,1,b);
    hold on;
    
    pSem = zeros(1,3);
    meanDif = zeros(1,3);
    
    for s = 1:3
        fprintf('\t\t%s: ', stateNames{s});
        
        group = struct;
        AVG = zeros(1,2);
        for g = 1:2
            group(g).data = squeeze(kVals{g}(b,s,:));
            AVG(g) = nanmean(group(g).data);
        end
        pSem(s) = pooled_var(group); %pooled standard deviation
        meanDif(s) = diff(AVG);
        bg = bar(s,meanDif(s));
        set(bg, 'FaceColor', rgb(stateCols{s}));
        
        [~,P,~,STATS] = ttest2(group(1).data, group(2).data);
        fprintf('t(%d) = %0.04g, p = %0.04g\n', STATS.df, STATS.tstat, P);
    end
    
    eb = errorbar(1:3, meanDif, pSem);
    set(eb, 'LineStyle', 'none', 'Color', [0 0 0], 'LineWidth', 1, 'CapSize', 0)
    
    title([num2str(binSizes(b)*1000) ' ms Bins; Cross-Corr Summed Across [' num2str(midSumRanges(b,1)) '  ' num2str(midSumRanges(b,2)) ' ms]'])
    ylabel('Kurtosis Difference');
    set(gca, 'XTick', 1:3, 'XTickLabel', stateNames, 'FontName', 'Arial')
    
end


%% SCATTERPLOT OF SPAT PER RATIOS vs. MIDSUMS

figure('Position', [1921  1  1920 1003])

for b = 1:5
    if b == 1
        tmpB = b;
    else
        tmpB = b - 1;
    end
    for s = 1:3
        subplot(5,3,(b-1)*3+s);
        hold on;
        
        for g = 1:2
            sp = plot(spatPerRats{g}, squeeze(midSums{g}(b,s,:)), 'o');
            set(sp, 'MarkerFaceColor', modCols{g}, 'MarkerEdgeColor', 'none')
        end
        
        if b == 5
            xlabel('Grid Size Ratio');
        end
        
                
        yBnds = get(gca, 'YLim');
        ylim(yBnds);
        
        ln = line([.7 .7], yBnds);
        set(ln, 'LineStyle', '--', 'Color', 'k');
        zero_line;
        
        if b == 1
            title(stateNames{s})
        end
        
        if s == 1
            ylabel({[num2str(binSizes(tmpB)*1000) ' ms Bins']; ['[' num2str(midSumRanges(b,1)) '  ' num2str(midSumRanges(b,2)) ' ms]']; 'Cross-Corr'});
        end
        
    end
end



%% DO BOOTSTRAPPING APPROACH TO TEST FOR SIGNIFICANCE 
fprintf('\n\nBOOTSTRAPPING TEST OF VARIANCE:\n'); 
figure('name', 'Bootstrapping Approach', 'Position', [1921  1  1920 1003]); 
numShufs = 10000;
for b = 1:5 
    if b == 1
        tmpB = 1;
    else
        tmpB = b - 1; 
    end
    fprintf('\tBin Size: %d ms, Summed Across [%s %s ms]:\n', binSizes(tmpB)*1000, num2str(midSumRanges(b,1)), num2str(midSumRanges(b,2))); 
    if b == 1
        tmpB = b;
    else
        tmpB = b - 1;
    end
    for s = 1:3
        varDifs = zeros(1,numShufs);
        for sh = 1:numShufs
            sigma2 = zeros(1,2);
            for g = 1:2
                tmpLen = length(midSums{g}(b,s,:));
                tmpVals = squeeze(midSums{g}(b,s,:));
                ssVals = randsample(tmpVals,tmpLen,1);
                sigma2(g) = var(ssVals);
            end
            varDifs(sh) = diff(sigma2);
        end %numShufs
        
        cutOffInds = round([.025 .975] .* numShufs);
        varDifs = sort(varDifs);
        cutOffs = varDifs(cutOffInds);
        
        subplot(5,3,(b-1)*3+s);
        histogram(varDifs)
        hold on;
        yBnds = get(gca, 'YLim');
        ylim(yBnds);
        for c = 1:2
            ln = line([cutOffs(c) cutOffs(c)], yBnds);
            set(ln, 'Color', [1 0 0], 'LineStyle', '--');
        end
        y_zero_line;
        
        if s == 1
            ylabel({[num2str(binSizes(tmpB)*1000) ' ms Bins']; ['[' num2str(midSumRanges(b,1)) '  ' num2str(midSumRanges(b,2)) ' ms]']; 'Cross-Corr'});
        end
        
        if b == 1
            title(stateNames{s})
        end
        
        if b == 5
            xlabel('Variance Difference [Intra - Trans]'); 
        end
    
        pVal = 1 - sum(varDifs<0) / numShufs;
        if cutOffs(2) < 0
            sigOrNot = 'Significant'; 
        else
            sigOrNot = 'Nonsignificant'; 
        end
        
        fprintf('\t\t%s: %s, p = %0.04g\n ', stateNames{s}, sigOrNot, pVal);
        fprintf('\t\t\tShuffle Average +/- STD: %0.04g +/- %0.04g\n', mean(varDifs), std(varDifs)); 
        fprintf('\t\t\t\t95%% Cutoffs: %0.04g and %0.04g\n', cutOffs);
        
    end
end




%% DO PERMUTATION APPROACH TO TEST FOR SIGNIFICANCE 
fprintf('\n\nPERMUTATION TEST OF VARIANCE:\n'); 
figure('name', 'Permutation Approach', 'Position', [1921  1  1920 1003]); 
numShufs = 10000;
for b = 1:5
    if b == 1
        tmpB = b;
    else
        tmpB = b - 1;
    end
    fprintf('\tBin Size: %d ms, Summed Across [%s %s ms]:\n', binSizes(tmpB)*1000, num2str(midSumRanges(b,1)), num2str(midSumRanges(b,2))); 
    for s = 1:3
        
        obsDif = var(midSums{1}(b,s,:)) - var(midSums{2}(b,s,:)); 
        
        shufDifs = zeros(1,numShufs);
        allVals = [squeeze(midSums{1}(b,s,:)); squeeze(midSums{2}(b,s,:))]; 
        for sh = 1:numShufs
            allVals = allVals(randperm(size(allVals,1))); 
            g1Vals = allVals(1:length(midSums{1}(b,s,:))); 
            g2Vals = allVals(length(midSums{1}(b,s,:))+1:end); 
            shufDifs(sh) = var(g1Vals) - var(g2Vals); 
        end
            
        cutOffInds = round([.025 .975] .* numShufs);
        shufDifs = sort(shufDifs);
        cutOffs = shufDifs(cutOffInds);
        
        subplot(5,3,(b-1)*3+s);
        histogram(shufDifs);%, 'BinWidth', .1)
        hold on;
        yBnds = get(gca, 'YLim');
        ylim(yBnds);
        for c = 1:2
            ln = line([cutOffs(c) cutOffs(c)], yBnds);
            set(ln, 'Color', [1 0 0], 'LineStyle', '--');
        end
        y_zero_line;
        
        ln = line([obsDif obsDif], yBnds); 
        set(ln, 'LineWidth', 2, 'Color', [0 1 0]); 
        
        if s == 1
            ylabel({[num2str(binSizes(tmpB)*1000) ' ms Bins']; ['[' num2str(midSumRanges(b,1)) '  ' num2str(midSumRanges(b,2)) ' ms]']; 'Cross-Corr'});
        end
        
        if b == 1
            title(stateNames{s})
        end
        
        if b == 5
            xlabel('Variance Difference [Intra - Trans]'); 
        end
        
        
        pVal = 1 - sum(shufDifs<obsDif) / numShufs;
        if cutOffs(2) < obsDif
            sigOrNot = 'Significant';
        else
            sigOrNot = 'Nonsignificant';
        end
        
        fprintf('\t\t%s: %s, p = %0.04g\n ', stateNames{s}, sigOrNot, pVal);
        fprintf('\t\t\tShuffle Average +/- STD: %0.04g +/- %0.04g\n', mean(shufDifs), std(shufDifs));
        fprintf('\t\t\t\t95%% Cutoffs: %0.04g and %0.04g\n', cutOffs);
        
        
    end
end







keyboard

