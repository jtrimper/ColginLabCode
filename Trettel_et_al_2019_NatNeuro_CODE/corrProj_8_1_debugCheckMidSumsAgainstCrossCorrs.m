function corrProj_8_1_debugCheckMidSumsAgainstCrossCorrs(cellRegion)
% function corrProj_8_1_debugCheckMidSumsAgainstCrossCorrs(cellRegion)


stateNames = {'RUN', 'REM', 'NREM'}; 
regNames = {'MEC', 'CA1'}; 


figure('Position', [224    71   931   604])

for reg = 1:2
    midSum = []; 
    rmCc = []; 
    for cp = 1:length(cellRegion(reg).cellPair)
        midSum(cp) = cellRegion(reg).cellPair(cp).state(1).midSum(1);%#ok
        rmCc(cp) = cellRegion(reg).cellPair(cp).state(1).rmCorrCoeffs;%#ok
        for s = 1:3
            for b = 1:4 %bin
                tmpStXCorr = cellRegion(reg).cellPair(cp).state(s).stXCorr{b};
                
%                 subplot(4,1,b)
%                 plot(tmpStXCorr);
%                 xlim([0 length(tmpStXCorr)]); 
%                 if b == 1
%                     title([regNames{reg} '; ' stateNames{s} '; CP ' num2str(cp) '; MidSum = ' num2str(round(midSum(cp),5)) '; RmCc = ' num2str(round(rmCc(cp),3))])
%                 end
%                 
            end
%             pause
%             clf
        end
    end
    subplot(1,2,reg)
    scatter(rmCc, midSum)
end