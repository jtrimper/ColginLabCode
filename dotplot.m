function h = dotplot(xVals, yData, jitter, faceColors, edgeColors)
% function h = dotplot(xVals, yData, jitter, faceColors, edgeColors)
%
% PURPOSE:
%  To make dot plots, rather than bar graphs, which is what the industry is expecting nowadays.
%
% INPUT:
%        xVals = x value(s) for each group (1 x n)
%        yData = data for each group (n) in a cell array (cell array allows for different sized groups)
%       jitter = amount to jitter each data point around the x value (xVal +/- jitter)
%                jittering is drawn from a normal distribution
%   faceColors = n x 3 matrix with RGB triplet for each group indicating marker face colors
%   edgeColors = n x 3 matrix with RGB triplet for each group indicating marker edge colors
%
% OUTPUT:
%     h = handle for each group's data points
%
% EXAMPLE:
%        xVals = [1 2];
%     yData{1} = [4 5 4 8 7 6];
%     yData{2} = [3 8 7 2 2 3 8 1 9 7 3];
%       jitter = .2;
%   faceColors = [1 0 0; 0 0 1];
%   edgeColors = [0 0 0; 0 0 0];
%            h = dotplot(xVals, yData, jitter, faceColors, edgeColors);
%
%
% JB Trimper
% 2/2019
% Colgin Lab



h = zeros(1,length(xVals));
yMax = zeros(1,2);
for g = 1:length(xVals) %For each group
    numPts = length(yData{g});
    xData = rescale(randn(numPts,1), xVals(g)-jitter, xVals(g)+jitter);
    h(g) = scatter(xData, yData{g}, 'o');
    hold on;
    yLims = get(gca, 'YLim');
    yMax(g) = yLims(2);
    if exist('faceColors', 'var')==1  &&  ~isempty(faceColors)
        set(h(g), 'MarkerFaceColor', faceColors(g,:));
    end
    if exist('edgeColors', 'var')==1  &&  ~isempty(edgeColors)
        set(h(g), 'MarkerEdgeColor', edgeColors(g,:));
    end
end
ylim([0 max(yMax)+0.15*max(yMax)]);
xlim([xVals(1)-.5 xVals(end)+.5]);
set(gca, 'XTick', xVals);





end %fnctn