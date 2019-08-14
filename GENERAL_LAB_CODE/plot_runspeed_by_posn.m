function plot_runspeed_by_posn(coords, instRs, xBnds, yBnds, minScaleRs, maxScaleRs)
% function plot_runspeed_by_posn(coords, instRs, xBnds, yBnds, minScaleRs, maxScaleRs)
%
% PURPOSE:
%   To plot runspeed by position. Runspeed is color coded over the trajectory of the rat.
%
% INPUT:
%     coords = output of 'read_in_coords.' An n x 3 matrix where (:,1) = time-stamps, (:,2) = x position,
%              and (:,3) = y postition
%     instRs = the instantaneous runspeed for each frame. An n x 2 matrix where (:,1) = time-stamps and
%              (:,2) = runspeed in cm/s. 'n' must be equal between coords and instRs.
%      xBnds = 1 x 2 vector specifying upper and lower bounds of x axis
%      yBnds = 1 x 2 vector specifying upper and lower bounds of y axis
%  minScaleRs = bottom of the runspeed scale to use (bottom color on the colorbar)
%  maxScaleRs = top of the runspeed scale to use (bottom color on the colorbar
%
% OUTPUT:
%   One graph.
%
% JB Trimper
% 07/2019
% Colgin Lab




numSpdBins = 20;
colMap = jet(numSpdBins);
spdBinEdges = linspace(minScaleRs, maxScaleRs, numSpdBins+1);

figure('Position', [ 527   365   655   537]);
axis square;
hold on;
for sb = 1:numSpdBins
    lowBinEdge = spdBinEdges(sb);
    highBinEdge = spdBinEdges(sb+1);
    frameInds = find(instRs(:,2)>=lowBinEdge & instRs(:,2)<highBinEdge);
    if ~isempty(frameInds)
        plot(coords(frameInds,2), coords(frameInds,3), '.', 'Color', colMap(sb,:))
    end
end
xlabel('X Position (cm)');
xlim(xBnds);
ylabel('Y Position (cm)');
ylim(yBnds);
fix_font; 

cb = colorbar;
ylabel(cb, 'Speed (cm/s)');
set(cb, 'FontSize', 12, 'FontName', 'Arial');

end