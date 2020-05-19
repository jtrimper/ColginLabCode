function corrProj_7_4_waterFallPlots(cellRegion)
% function corrProj_7_4_waterFallPlots(cellRegion)
%
% PURPOSE:
%   Function to plot "waterfall plots for CA1 and MEC
%
% INPUT:
%   cellRegion = the output of corrProj_6... which has data for each cell pair by state and region
%
% OUTPUT:
%   Figures (scatterplots) as well as printed stats.
%
% JBT 8/2017
% Colgin Lab

zVals = 0; %set to 1 to use zscore 
cZLims = [-1.75 3.75]; 
% zScoring NOT used (set to 0) for the waterfall plot in the paper, 
%   but using it for measuring dispersion for revisions

stateCols = {'Green', 'Gold', 'Purple'};

regNames = {'Intra-', 'Trans-'}; 
binSizes = [0.005 0.010 0.050]; %ms
stateNames = {'RUN', 'REM', 'NREM'}; 
lagTtls = {'+/- 5 s', '+/- 1 s'}; 

reg = 1; 

for g = 1:2
    stXCorrsXState = cell(3,3); %binSize x state
    rmCcs = []; 
    for cp = 1:length(cellRegion(reg).cellPair)
        rmCcs = [rmCcs cellRegion(reg).cellPair(cp).state(1).rmCorrCoeffs];  %#ok
        for s = 1:3
            for b = 1:3 %bin
                tmpB = b+1; %wasn't plotted for the 2ms bin
                
                %use non-normalized cross-corr
                tmpStXCorr = cellRegion(reg).cellPair(cp).state(s).stXCorr{tmpB};
                
                if zVals == 1
                    tmpStXCorr = zscore(tmpStXCorr);
                else
                    tmpStXCorr = tmpStXCorr ./ mean(tmpStXCorr);
                end
                
                stXCorrsXState{b,s} = [stXCorrsXState{b,s}; tmpStXCorr'];
                
            end
        end
    end
    [~,srtInds] = sort(rmCcs);
    mainFig = figure('name', regNames{reg}, 'Position', [ 280    81   780   592]);
    for b = 1:3
        for s = 1:3
            
            figure(mainFig); 
            
            % Plot +/-5 s
            subplot(3,4,(b-1)*4+s);
            hold on;
            tmpXCorrs = stXCorrsXState{b,s};
            tmpXCorrs = tmpXCorrs(srtInds,:);
            xVals = 0:binSizes(b):(size(tmpXCorrs,2)-1)*binSizes(b);
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
            
            if b == 1
                title({stateNames{s}; lagTtls{1}})
            end
            if s == 1
                ylabel({[num2str(binSizes(b)*1000) ' ms Bins']; 'Cell Pair ID'})
            end
            if b == 3
                xlabel('Time Lag (s)'); 
            end
            
            if b == 1
                startPeak = find(xVals<=-1, 1, 'Last');
                endPeak = find(xVals>=1, 1, 'First');
                kVals(s).data = kurtosis(tmpXCorrs(:,startPeak:endPeak),[],2); %#ok
                
                peakDurs(s).data = []; %#ok
                for i = 1:size(tmpXCorrs)
                    [vals, inds] = mw_avg(tmpXCorrs(i,:), 5, 1);
                    midInd = find(inds == median(1:size(tmpXCorrs,2)));
                    if vals(midInd) > 2
                        
                        % Base duration on half-max width
                        pkVal = vals(midInd); 
                        halfMax = pkVal / 2;                         
                        startPeak = find(vals(1:midInd)<=halfMax, 1, 'Last');
                        startTime = xVals(inds(startPeak));
                        endPeak = find(vals(midInd:end)<=halfMax, 1, 'First');
                        endPeak = endPeak + midInd - 1;
                        endTime = xVals(inds(endPeak));                        
                        
%                         % Base duration on when zScore falls below edge threshold
%                         startPeak = find(vals(1:midInd)<=0, 1, 'Last');
%                         startTime = xVals(inds(startPeak));
%                         endPeak = find(vals(midInd:end)<=0, 1, 'First');
%                         endPeak = endPeak + midInd - 1;
%                         endTime = xVals(inds(endPeak));

                        peakDurs(s).data = [peakDurs(s).data endTime-startTime]; 
                        
                    end
                end
            end
        end
        
        if b == 1
            
            %KURTOSIS
            figure('name', 'Kurtosis Of Cross-Corr Peak by State'); 
            hold on;
            fprintf('Kurtosis Values:\n');
            for s = 1:3
                fprintf('\t%s: %0.04g +/- %0.04g\n', stateNames{s}, mean(kVals(s).data), semfunct(kVals(s).data))
                kAvg(s) = mean(kVals(s).data);
                kSem(s) = semfunct(kVals(s).data);
                bg = bar(s,kAvg(s));
                set(bg, 'FaceColor', rgb(stateCols{s}));
            end
            eb = errorbar(1:3, kAvg, kSem);
            set(eb, 'Color', [0 0 0], 'CapSize', 0, 'LineStyle', 'none');
            set(gca, 'XTick', 1:3, 'XTickLabel', stateNames);
            ylabel('Kurtosis (AVG +/- SEM)');
            set(gca, 'FontSize', 14, 'FontName', 'Arial');
            
            fprintf('\n\tONE-WAY REPEATED MEASURES ANOVA:\n');
            [A, ~, pEta2] = one_way_rm_anova([kVals(1).data kVals(2).data kVals(3).data]);
            fprintf('\t\tF(%d,%d) = %0.04g, p = %0.04g, pEta2 = %0.04g\n\n', A.df, A.F, A.p, pEta2);
            
            fprintf('\tPAIRED T-TESTS:\n');
            combos = [1 2; 1 3; 2 3];
            for c = 1:3
                g1 = combos(c,1);
                g2 = combos(c,2);
                [~,P,~,STATS] = ttest(kVals(g1).data, kVals(g2).data);
                difVals = kVals(g1).data - kVals(g2).data; 
                cohD = mean(difVals) / std(difVals); 
                fprintf('\t\t%s vs %s(%d): t = %0.04g, p = %0.04g, d = %0.04g\n', stateNames{g1}, stateNames{g2}, STATS.df, STATS.tstat, P, cohD);
                fprintf('\t\t\tq = %0.04f\n', STATS.tstat * sqrt(2)); 
            end
            
            %PEAK DURATIONS
            fprintf('\n\n\nPeak Durations:\n');
            figure('name', 'Durations of xCorr Peaks by State'); 
            hold on;
            for s = 1:3
                fprintf('\t%s: %0.04g +/- %0.04g\n', stateNames{s}, median(peakDurs(s).data), semfunct(peakDurs(s).data))
                kAvg(s) = mean(peakDurs(s).data);
                kSem(s) = semfunct(peakDurs(s).data);
                bg = bar(s,kAvg(s));
                set(bg, 'FaceColor', rgb(stateCols{s}));
            end
            eb = errorbar(1:3, kAvg, kSem);
            set(eb, 'Color', [0 0 0], 'CapSize', 0, 'LineStyle', 'none');
            set(gca, 'XTick', 1:3, 'XTickLabel', stateNames);
            ylabel('Peak Durations (s) (AVG +/- SEM)');
            set(gca, 'FontSize', 14, 'FontName', 'Arial');
            
            fprintf('\n\tONE-WAY BETWEEN GROUPS ANOVA:\n');
            [F, p, dfBet, dfWi] = one_way_bg_anova(peakDurs);
            fprintf('\t\tF(%d,%d) = %0.04g, p = %0.04g\n\n', dfBet, dfWi, F, p);
            
            fprintf('\tINDEPENDENT T-TESTS:\n');
            combos = [1 2; 1 3; 2 3];
            for c = 1:3
                g1 = combos(c,1);
                g2 = combos(c,2);
                [~,P,~,STATS] = ttest2(peakDurs(g1).data, peakDurs(g2).data);
                fprintf('\t\t%s vs %s(%d) = %0.04g, p = %0.04g\n', stateNames{g1}, stateNames{g2}, STATS.df, STATS.tstat, P);
            end
            
        end
            
       figure(mainFig); 
        % Plot +/-1 s
        subplot(3,4,(b-1)*4+4);
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
        if b == 1
            title({stateNames{s}; lagTtls{2}})
        end
        if s == 1
            ylabel({[num2str(binSizes(b)*1000) ' ms Bins']; 'Cell Pair ID'})
        end
        if b == 3
            xlabel('Time Lag (s)');
        end
        
    end %bin Size
   keyboard
   
    
end




end %fnctn
                
                