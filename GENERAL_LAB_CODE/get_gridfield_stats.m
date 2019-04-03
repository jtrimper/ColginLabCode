function [gridSize, gridOrientation, ellipseCoords, orientationAngs, sixPkCoords, threeAngleCoords] = get_gridfield_stats(autoCorrMap)
% function [gridSize, gridOrientation, ellipseCoords, orientationAngs, sixPkCoords, threeAngleCoords] = get_gridfield_stats(autoCorrMap)
%
% PURPOSE:
%   To find the coordinates for an ellipse that crosses the six points of a grid field hexagon.
%   This info will then be used to assess whether cells came from the same module per Gardner et
%   al., 2017, which is following Tocker et al., 2015.
%
% INPUT:
%   autoCorrMap = the rate map autocorrelation (nxn)
%
% OUTPUT:
%   ellipseCoords = the coordinates for an ellipse that best fits the grid hexagon
%
% NOTES:
%  calls 'fitellipse' and then uses code copied from 'plotellipse.' Both functions downloaded from
%  Mathworks File Exchange
%
% JBT 1/2018
% Colgin Lab


% zThresh = 0.5;
medInd = median(1:size(autoCorrMap,1));

%Get rid of nans and zscore the auto-corr map
autoCorrMap(isnan(autoCorrMap)) = -1;
zMap = (autoCorrMap - nanmean(autoCorrMap(:))) ./ nanstd(autoCorrMap(:));


%Find peaks by going along each column and each row and looking for where peak indices intersect
tpAutoCorrMap = autoCorrMap';
rowPkMap = zeros(size(autoCorrMap));
colPkMap = zeros(size(autoCorrMap));
for i = 1:size(autoCorrMap,1)
    [~,rowPks] = findpeaks(autoCorrMap(i,:));
    if ~isempty(rowPks)
        rowPkMap(i,rowPks) = 1;
    end
    [~,colPks] = findpeaks(tpAutoCorrMap(i,:));
    if ~isempty(colPks)
        colPkMap(colPks,i) = 1;
    end
end

%Make a 2D matrix where just the peaks == 1
pkMap = zeros(size(autoCorrMap));
pkMap(colPkMap == 1 & rowPkMap == 1) = 1;
pkMap(medInd,medInd) = 0;

%Get the indices for those peaks
[rowInds, colInds] = find(pkMap == 1);
allPkInds = [rowInds colInds];

%Get rid of small values (based on threshold set above)
allPkVals = zMap(pkMap == 1);
smlPkInds = find(allPkVals < 0);
if ~isempty(smlPkInds)
    allPkInds(smlPkInds,:) = [];
end


%Find euclidean distance between each peak and the 'origin'
eucDists = sqrt( (allPkInds(:,1)-medInd).^2 + (allPkInds(:,2)-medInd).^2 );
[~, distSrtInds] = sort(eucDists);
pkInds = allPkInds(distSrtInds(1:8),:);


%Re-do the map of peaks now having gotten rid of the littler ones
pkMap = zeros(size(autoCorrMap));
for i = 1:size(pkInds,1)
    pkMap(pkInds(i,1), pkInds(i,2)) = 1;
end

figure('Position', [711   413   560   420]);
imagesc(autoCorrMap);
axis xy
hold on;
scatter(pkInds(1:6,2), pkInds(1:6,1), 'MarkerFaceColor', [1 0 0]);
% scatter(pkInds(2:7,2), pkInds(2:7,1), 'MarkerFaceColor', [1 0 0]);
title('Are the points correct? (y OR n, in the command window)')

userCheck = input('Are the points correct? (y OR n)', 's');

if strcmp(userCheck, 'n')
    clf;
    imagesc(autoCorrMap);
    axis xy
    hold on;
    for i = 1:8
        tt = text(pkInds(i,2), pkInds(i,1), num2str(i));
        set(tt, 'FontWeight', 'Bold', 'FontSize', 14, 'Color', [1 0 0]);
    end
    title('Which SIX points are correct? (enter vector in the command window)')
    
    crctPts = input('Which SIX points are correct? (enter 1x6 vector, enter empty vector if correct points not presented)');
    if isempty(crctPts)
        pkInds = allPkInds(distSrtInds(1:20),:);
        
        clf;
        imagesc(autoCorrMap);
        axis xy
        hold on;
        for i = 1:length(pkInds)
            tt = text(pkInds(i,2), pkInds(i,1), num2str(i));
            set(tt, 'FontWeight', 'Bold', 'FontSize', 14, 'Color', [1 0 0]);
        end
        title('Take 2: Which SIX points are correct? (enter vector in the command window)')
        crctPts = input('Take 2: Which SIX points are correct? (enter 1x6 vector, enter empty vector if correct points not presented)');
        if isempty(crctPts)
            error('Correct points not displayed. Something is wrong.\n');
        else
            pkInds = pkInds(crctPts,:);
        end
    else
        pkInds = pkInds(crctPts,:);
    end
    
elseif strcmp(userCheck, 'y')
%     pkInds = pkInds(2:7,:);
    pkInds = pkInds(1:6,:);
end

%Store peak coords as output
sixPkCoords = pkInds;

%Center peak indices around zero for finding orientation and scale
relPkInds = pkInds - medInd; 

%Find angle closest to reference line (0 degrees)
[angs, angSrtInds] = sort(cart2pol(relPkInds(:,2), relPkInds(:,1))); 
relPkInds = relPkInds(angSrtInds,:); 
pkInds = pkInds(angSrtInds,:); 
[~,axInds(1)] = min(abs(angs)); 

%Find next most positive and next most negative
axInds(2) = axInds(1) + 1; 
if axInds(2) == 7
    axInds(2) = 1; 
end
axInds(3) = axInds(1) - 1; 
if axInds(3) == 0
    axInds(3) = 6; 
end

%Make lines to those points for plotting
lineCoords = zeros(2,2,3); 
for lns = 1:3
    lineCoords(:,:,lns) = [medInd pkInds(axInds(lns),2) ; medInd pkInds(axInds(lns),1)];
end
threeAngleCoords = lineCoords; 

%Grid Orientation = the average of those 3 angles, following Stensola et al., 2012
gridOrientation = rad2deg(circ_mean(angs(axInds))); 
orientationAngs = rad2deg(angs(axInds)); 

%Grid size = the euclidean distance of those 3 points from the origin
gridSize = mean(hypot(relPkInds(axInds,2), relPkInds(axInds,1))); 


%Fit an ellipse
[z,a,b,alpha] = fitellipse(fliplr(pkInds));

%Rotation matrix
Q = [cos(alpha), -sin(alpha); sin(alpha) cos(alpha)];

% Ellipse points
npts = 100;
t = linspace(0, 2*pi, 100);
ellipseCoords = Q * [a * cos(t); b * sin(t)] + repmat(z, 1, npts);


%Final check image
clf;
imagesc(autoCorrMap);
axis xy
hold on;
scatter(pkInds(:,2), pkInds(:,1), 'MarkerFaceColor', [1 0 0]);
for lns = 1:3
    ln = line(lineCoords(1,:,lns), lineCoords(2,:,lns)); 
    set(ln, 'LineWidth', 2, 'Color', [0 0 0]); 
    tt = text(lineCoords(1,2,lns), lineCoords(2,2,lns)-3, num2str(lns)); 
    set(tt, 'FontSize', 13, 'FontWeight', 'Bold', 'Color', [1 0 0]); 
end
plot(ellipseCoords(1,:), ellipseCoords(2,:), 'Color', [.5 .5 .5], 'LineWidth', 1.5, 'LineStyle', '--')
xlabel('Bin Number'); 
ylabel('Bin Number'); 
tix = [fliplr(medInd:-10:0) medInd+10:10:size(autoCorrMap,1)]; 
tixLbls = tix - medInd; 
set(gca, 'XTick', tix, 'XTickLabel', tixLbls); 
set(gca, 'YTick', tix, 'YTickLabel', tixLbls);  
title({'Final check (any button to continue or [ctrl+c] to cancel)';...
    ['Grid Orientation = ' num2str(round(gridOrientation,3)) '; Grid Size = ' num2str(round(gridSize,3))]});

pause; 
close all

end %fnctn