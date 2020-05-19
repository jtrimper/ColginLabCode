function plot_model_gridfield_stats(origStruct, newStruct)

xLbls = {'Original', 'Shuffled'}; 


figure('Position', [1         535        1366         431]); 

%% SUBPLOT 1: PLOT AVERAGE BEFORE AND AFTER SHUFFLE GRIDNESS SCORES

subplot(2,3,1); 
hold on; 

AVG(1) = mean(origStruct.Gridness60); 
bg = bar(1,AVG(1)); 
set(bg, 'FaceColor', 'Red'); 

AVG(2) = mean(newStruct.Gridness60); 
bg = bar(2,AVG(2)); 
set(bg, 'FaceColor', 'Blue'); 


ERR(1) = semfunct(origStruct.Gridness60); 
ERR(2) = semfunct(newStruct.Gridness60); 

eb = errorbar(1:2,AVG,ERR); 
set(eb, 'LineStyle', 'none', 'Color', [0 0 0], 'CapSize', 0, 'LineWidth', 2); 

title({'Averages +/- SEM'; ''}); 
set(gca, 'XTick', 1:2, 'XTickLabel', xLbls, 'FontName', 'Arial');
ylabel('Gridness Score'); 

tt = text(2,.8, ['n = ' num2str(length(origStruct.Gridness60))]); 
set(tt, 'FontName', 'Arial', 'HorizontalAlignment', 'Center'); 

%% SUBPLOT 2: PLOT CDFs
subplot(2,3,2); 
hold on; 

data = origStruct.Gridness60; 
[yy,xx] = cdfcalc(data);
k = length(xx);
n = reshape(repmat(1:k, 2, 1), 2*k, 1);
xCDF    = [-Inf; xx(n); Inf];
yCDF    = [0; 0; yy(1+n)];
cdfLn(1) = plot(xCDF, yCDF, 'Color', rgb('Red')); 

data = newStruct.Gridness60; 
[yy,xx] = cdfcalc(data);
k = length(xx);
n = reshape(repmat(1:k, 2, 1), 2*k, 1);
xCDF    = [-Inf; xx(n); Inf];
yCDF    = [0; 0; yy(1+n)];
cdfLn(2) = plot(xCDF, yCDF, 'Color', rgb('Blue')); 

leg = legend(cdfLn, xLbls); 
set(leg, 'Location', 'SouthEast', 'Box', 'Off');

xlabel('Gridness Score'); 
ylabel('Cumulative Probability'); 
title({'Cumulative Distributions'; 'Gridness Scores'}); 

set(gca, 'FontName', 'Arial');


%% SUBPLOT 3: PLOT DIFFERENCE OF GRIDNESS SCORES AFTER/BEFORE SHUFFLE

subplot(2,3,3); 
hold on; 

AVG = mean(newStruct.Gridness60 - origStruct.Gridness60);
ERR = mean(newStruct.Gridness60 - origStruct.Gridness60);

bg = bar(1,AVG); 
set(bg, 'FaceColor', [.5 .5 .5]); 
eb = errorbar(1,AVG, ERR); 
set(eb, 'LineStyle', 'none', 'Color', [0 0 0], 'CapSize', 0, 'LineWidth', 2); 

set(gca, 'XTick', 1, 'XTickLabel', 'Shuffled - Original', 'FontName', 'Arial');
ylabel('Gridness Score Difference'); 
title({'Average Pairwise Differences'; ''}); 
ylim([-1.4 1]); 



fprintf('STATS FOR GRIDNESS SCORES:\n'); 

[~,P,STATS] = ansaribradley(origStruct.Gridness60, newStruct.Gridness60);
fprintf('\n\tANSARI-BRADLEY RESULTS:\n'); 
fprintf('\t\tPost- vs Pre-Shuffle: W* = %0.04g, p = %0.04g\n', STATS.Wstar, P); 

%   [P,~,STATS] = signrank(origStruct.Gridness60, newStruct.Gridness60);
% fprintf('\n\tWILCOXON SIGN-RANK RESULTS:\n'); 
% fprintf('\t\tPost- vs Pre-Shuffle: z = %0.04g, p = %0.04g\n', STATS.zval, P); 

[~,P,~,STATS] = ttest(origStruct.Gridness60, newStruct.Gridness60);
fprintf('\n\tPAIRED T-TEST RESULTS:\n'); 
fprintf('\t\tPost- vs Pre-Shuffle: t(%d) = %0.04g, p = %0.04g\n', STATS.df, STATS.tstat, P); 





%% CALCULATE SPATIAL CORRELATIONS FOR ORIGINAL AND NEW DATA-SETS
origData = origStruct.outputMap;
shufData = newStruct.outputMap;
spatCorr(1,:) = ones(1,size(origData,3)); 
for u = 1:size(origData,3)
    origMap = origData(:,:,u);
    origMapVctr = origMap(:);
    shufMap = shufData(:,:,u);
    shufMapVctr = shufMap(:);
    
    corrMat = corrcoef(origMapVctr, shufMapVctr);
    spatCorr(2,u) = corrMat(2,1);    
end




%% SUBPLOT 4: PLOT AVERAGE BEFORE AND AFTER SHUFFLE SPATIAL CORRELATION COEFFICIENTS

subplot(2,3,4); 
hold on; 

AVG = mean(spatCorr,2); 
bg = bar(1,AVG(1)); 
set(bg, 'FaceColor', 'Red'); 

bg = bar(2,AVG(2)); 
set(bg, 'FaceColor', 'Blue'); 

ERR = semfunct(spatCorr,2); 

eb = errorbar(1:2,AVG,ERR); 
set(eb, 'LineStyle', 'none', 'Color', [0 0 0], 'CapSize', 0, 'LineWidth', 2); 

set(gca, 'XTick', 1:2, 'XTickLabel', xLbls, 'FontName', 'Arial'); 
ylabel('Spatial Correlation Coefficient'); 



%% SUBPLOT 5: PLOT CDFs
subplot(2,3,5); 
hold on; 

data = spatCorr(1,:); 
[yy,xx] = cdfcalc(data);
k = length(xx);
n = reshape(repmat(1:k, 2, 1), 2*k, 1);
xCDF    = [-Inf; xx(n); Inf];
yCDF    = [0; 0; yy(1+n)];
cdfLn(1) = plot(xCDF, yCDF, 'Color', rgb('Red')); 

data = spatCorr(2,:); 
[yy,xx] = cdfcalc(data);
k = length(xx);
n = reshape(repmat(1:k, 2, 1), 2*k, 1);
xCDF    = [-Inf; xx(n); Inf];
yCDF    = [0; 0; yy(1+n)];
cdfLn(2) = plot(xCDF, yCDF, 'Color', rgb('Blue')); 

leg = legend(cdfLn, xLbls); 
set(leg, 'Location', 'SouthEast', 'Box', 'Off');

xlabel('Spatial Correlation Coefficient'); 
ylabel('Cumulative Probability'); 

title('Spatial Correlation Coefficients'); 

set(gca, 'FontName', 'Arial');





%% SUBPLOT 6: PLOT DIFFERENCE OF GRIDNESS SCORES AFTER/BEFORE SHUFFLE

subplot(2,3,6); 
hold on; 

AVG = mean(abs(spatCorr(:,2)) - abs(spatCorr(:,1)));
ERR = mean(abs(spatCorr(:,2)) - abs(spatCorr(:,1)));

bg = bar(1,AVG); 
set(bg, 'FaceColor', [.5 .5 .5]); 
eb = errorbar(1,AVG, ERR); 
set(eb, 'LineStyle', 'none', 'Color', [0 0 0], 'CapSize', 0, 'LineWidth', 2); 

set(gca, 'XTick', 1, 'XTickLabel', 'Shuffled - Original', 'FontName', 'Arial');
ylabel('Spat Corr Coeff Difference'); 
ylim([-.25 .2]); 





fprintf('\n\nSTATS FOR CORRELATION COEFFICIENTS:\n'); 

[~,P,STATS] = ansaribradley(spatCorr(:,1), spatCorr(:,2));
fprintf('\n\tANSARI-BRADLEY RESULTS:\n'); 
fprintf('\t\tPost- vs Pre-Shuffle: W* = %0.04g, p = %0.04g\n', STATS.Wstar, P); 

%   [P,~,STATS] = signrank(abs(spatCorr(:,1)), abs(spatCorr(:,2)));
% fprintf('\n\tWILCOXON SIGN-RANK RESULTS::\n'); 
% fprintf('\t\tPost- vs Pre-Shuffle: z = %0.04g, p = %0.04g\n', STATS.zval, P); 

[~,P,~,STATS] = ttest(abs(spatCorr(:,1)), abs(spatCorr(:,2)));
fprintf('\n\tPAIRED T-TEST RESULTS:\n'); 
fprintf('\t\tPost- vs Pre-Shuffle: t(%d) = %0.04g, p = %0.04g\n', STATS.df, STATS.tstat, P); 




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                    %
%           THESE WERE USED IN THE PAPER             %
%                                                    %
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

fprintf('\tONE-WAY RM ANOVA ON GRIDNESS SCORES:\n'); 
[A,~,pEta2] = one_way_rm_anova([origStruct.Gridness60' wtShufStruct.Gridness60' relearnStruct.Gridness60']); 
fprintf('\t\tF(%d,%d) = %0.03g, p = %0.03g, partial Eta2 = %0.04g\n', A.df, A.F, A.p, pEta2); 

difVals = deg2rad(abs(circ_dist(origStruct.gridOrientation, relearnStruct.gridOrientation)));  
[H, mu, ul] = circ_mtest(difVals,0);
ci = ul - mu; 
cohD = circ_mean(difVals') / circ_std(difVals');
fprintf('\n\n\n\t\tCIRC_MTEST FOR ORIENTATION DIFFERENCES vs. 0*: mu +/- CI = %0.04g +/- %0.04g, H = %d, d = %0.04g\n\n', mu, ci, H, cohD);


difVals = abs(origStruct.spatPhiMag - relearnStruct.spatPhiMag); 
[~,P,~,STATS] = ttest(difVals);
cohD = mean(difVals) / std(difVals); 
fprintf('\t\tT-TEST FOR PHASE OFFSET (1d MAGNITUDE): t(%d) = %0.04g, p = %0.04g, d = %0.04g\n', STATS.df, STATS.tstat, P, cohD);





