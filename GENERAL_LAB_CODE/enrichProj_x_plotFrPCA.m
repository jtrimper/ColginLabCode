function enrichProj_x_plotFrPCA(day)
% function enrichProj_x_plotFrPCA(day)
%
% PURPOSE: 
%  Function to plot population vector PCA collapsed across units in 3D space
%
% INPUT: 
%  day = project uber data struct
%
% OUTPUT: 
%  Figure
%
% JB Trimper
% 7/22/19
% Colgin Lab



condnCols = {'Gray', 'Blue'}; %Plot colors


% Task Condition Orders:
%            P1 E1 E2 P2; E1 P1 P2 E2
condnOrder = [1  2  3  4;  2  1  4  3];
condnNames = {'Plain-1', 'Enriched-1', 'Enriched-2', 'Plain-2'};


allUnitPopVctrs = [];

for d = 1:length(day)
    fprintf('Day %d\n', d);
    dayPopVctrs = nan(4,length(day(d).begin(1).unit));
    
    condInd = day(d).begin(1).type; % Get an index to be used later which indicates whether enriched or plain came first
    
    for b = 1:length(day(d).begin)
        fprintf('\tBegin %d (%s; Index = %d)\n', b, condnNames{condnOrder(condInd,b)},condnOrder(condInd,b));
        
        %Get average firing rate from rate-map for each unit to construct pop vector
        for u = 1:length(day(d).begin(b).unit)
            dayPopVctrs(condnOrder(condInd,b),u) = nanmean(day(d).begin(b).unit(u).rateMap(:)); 
        end %unit
        
    end %begin bout
    
    %Combine them all across days
    allUnitPopVctrs = [allUnitPopVctrs dayPopVctrs]; %#ok
    
end %day



%Calculate 3 principal components across units
[~,score] = pca(allUnitPopVctrs, 'NumComponents', 3);

% Plot the data on 3D axes
figure('Position', [593   339   645   420]); 
hold on; 
legHand(1) = scatter3(score([1 4],1), score([1 4],2), score([1 4],3), 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', rgb(condnCols{1})); 
legHand(2) = scatter3(score([2 3],1), score([2 3],2), score([2 3],3), 'MarkerEdgeColor', [0 0 0], 'MarkerFaceColor', rgb(condnCols{2})); 
xlabel('PC1'); 
ylabel('PC2'); 
zlabel('PC3'); 
title('Principal Components of Population Vectors'); 
fix_font; 
set(gca, 'View', [181.6 58], 'XGrid', 'On', 'YGrid', 'On', 'ZGrid', 'On');
legend(legHand, 'Plain', 'Enriched'); 

end %fnctn
