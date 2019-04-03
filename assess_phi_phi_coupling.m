function [binCounts, binCtrDegs] = assess_phi_phi_coupling(thetaPhaseSwps, gammaPhaseSwps, plotOpt)
% function [binCounts, binCtrDegs] = assess_phi_phi_coupling(thetaPhaseSwps, gammaPhaseSwps, plotOpt)
%
% PURPOSE: 
%  To get the theta/gamma phi-phi coupling matrix indicating, for each theta phase,
%  what the distribution of gamma phases looked like. 
% 
% INPUT: 
%  thetaPhaseSwps = trials x samples; matrix ranging from -pi to pi indicating theta phase for each sample/sweep
%                   **Use 'get_asym_theta_phi_vector' to get a vector of asym theta phases [rather than angle(hilbert(x))]
%  gammaPhaseSwps = trials x samples; matrix ranging from -pi to pi indicating gamma phase for each sample/sweep
%      plotOpt = binary indicating whether or not to plot the results; if left out, default is 0
%                 
% OUTPUT: 
%    binCounts = 72 x 72 matrix containing the counts of gamma phase bins for each theta phase bin
%                NOTE: 72 because 5 degree bins [360/5 = 72]
%   binCtrDegs = the center of each phase bin [2.5 : 5 : 360]
%
%
% JBT 
% 11/2016
% Colgin Lab



%% OPTIONS
plotTimes = 2; %indicate whether to plot the results once or twice (as in for one theta cycle or two)
   
%% SET UP PHASE BINS
binWidth = 5; %degrees
nBins = 360/binWidth;
binEdgeDegs = 0:binWidth:360;
binCtrDegs = binEdgeDegs(2:end) - (binWidth/2); %for plotting
binEdges = deg2rad(binEdgeDegs);
binEdges(binEdges>pi) = binEdges(binEdges>pi) - (2*pi); %make vector go from -pi to pi rather than 0 to 2pi

%% BIN THE THETA and GAMMA PHASES
thetaPhiBinMat = zeros(size(thetaPhaseSwps));
gammaPhiBinMat = zeros(size(gammaPhaseSwps));
for b = 1:nBins
    tmpEdges = binEdges(b:b+1);
    if b == 37
        tmpEdges(1) = -tmpEdges(1);%because the edges for 37 will be [3.14 -3.05]
    end
    thetaPhiBinMat(thetaPhaseSwps>=tmpEdges(1) & thetaPhaseSwps<tmpEdges(2)) = b;
    gammaPhiBinMat(gammaPhaseSwps>=tmpEdges(1) & gammaPhaseSwps<tmpEdges(2)) = b;
end



for b = 1:nBins
    
    %% GET THE GAMMA BINS FOR WHEN THETA PHASE IS IN BIN B
    tmpGammaBins = gammaPhiBinMat(thetaPhiBinMat==b);
    
    %% GET DISTRIBUTION OF GAMMA PHASES WHEN THETA IS IN PHASE BIN B
    binCounts(:,b) = histcounts(tmpGammaBins, 'BinLimits', [1 73], 'BinWidth', 1, 'Normalization', 'Probability');%#ok
    
end



%% OPTIONALLY PLOT THE RESULTS
if nargin == 2
    plotOpt = 0; 
end
if plotOpt == 1
    custMap = define_cust_color_map2('DarkGreen', 'Yellow', 'DarkRed', 64);
    %plot it twice
    if plotTimes == 2
        axVctr = [binCtrDegs binCtrDegs(end) + (binWidth/2) + binCtrDegs];
        binCntMat = [binCounts binCounts; binCounts binCounts];
        contourf(axVctr, axVctr, binCntMat, 20, 'Lines', 'none');
        colormap(custMap);
        set(gca, 'XTick', 0:90:720, 'XTickLabel', {'P', 'F', 'T', 'R'})
        xlim([-.0001 720.001]);
        set(gca, 'YTick', 0:90:720, 'YTickLabel', {'P', 'F', 'T', 'R'})
        ylim([-.0001 720.001]);
    else
        contourf(binCtrDegs, binCtrDegs, binCounts, 50, 'Lines', 'none');
        colormap(custMap);
        set(gca, 'XTick', 0:90:360, 'XTickLabel', {'P', 'F', 'T', 'R', 'P'})
        xlim([-.0001 360.001]);
        set(gca, 'YTick', 0:90:360, 'YTickLabel', {'P', 'F', 'T', 'R', 'P'})
        ylim([-.0001 360.001]);
    end
    set(gca, 'FontSize', 14);
    hold on;
    grid on;
    
    ylabel('Gamma Phase');
    xlabel('Theta Phase');
end

end%function