

sCntr = 0;
figure('Position', [1681 1  1680  973]);
for r = 1:length(rat)
    for s = 1:length(rat(r).session)
        
        if ~isempty(rat(r).session(s).unitInfo)
            
            sCntr = sCntr + 1;
            subplot(4,8,sCntr);
            hold on;
            
            gridSizes = rat(r).session(s).unitInfo(:,3);
            gridSizes = gridSizes .* 3; %convert to cm from bins
            [gridSizes, srtInds] = sort(gridSizes);
            unitInfo = rat(r).session(s).unitInfo(srtInds,:);
            
            plot(1:length(gridSizes), gridSizes, '*k');
            errorbar(1:length(gridSizes), gridSizes, 0.3*gridSizes,  zeros(1,length(gridSizes)), '*');
            
            gridRats = gridSizes ./ gridSizes';
            comboInds = nchoosek(1:size(gridSizes),2);
            badPairInds = [];
            for c = 1:size(comboInds,1)
                u1 = comboInds(c,1);
                u2 = comboInds(c,2);
                tmpGridRatio = min([gridRats(u1,u2) gridRats(u2,u1)]);
                if tmpGridRatio < 0.7
                    badPairInds = [badPairInds; u1 u2]; %#ok
                end
            end
            
            if ~isempty(badPairInds)
                badPairInds = badPairInds(:);
                [counts,edges] = histcounts(badPairInds, 'BinWidth', 1, 'BinLimits', [min(badPairInds) max(badPairInds)+1]);
                difModUnits = [];
                for u = 1:length(badPairInds)
                    if sum(badPairInds == u) > 1
                        difModUnits = [difModUnits u]; %#ok
                    end
                end
                
                if ~isempty(difModUnits)
                    for u = difModUnits
                        plot(u, gridSizes(u), '*');
                        errorbar(u, gridSizes(u), 0.3*gridSizes(u),0, '*r');
                    end
                end
                
            end
            
            xlim([0 length(gridSizes)+1]);
            ylim([10 100]);
            grid on
            title(['Rat ' num2str(r) '; Ses ' num2str(s)]);
            set(gca, 'XTick', 1:length(gridSizes));
            if mod(sCntr,8) == 1
                ylabel('Grid Size (cm)');
            end
            if sCntr > 20
                xlabel('Unit #');
            end
            
        end
        
        if r == 6 && s == 3
            keyboard
        end
        
        
    end
end