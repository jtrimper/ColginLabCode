% tmp_gridnessScore_rePlotting

load('C:\Users\John Trimper\Desktop\LAB_STUFF\PROJECTS\Grid_Cell_Correlations_TrettelProj\MANUSCRIPT\NATURE_NEURO_SUBMISSION\REVISIONS\NEW_RESULTS\modelTests\10_GC_Output_USED_FOR_PAPER\orig_shuf_and_relearned_structs_10GCs.mat')
gridnessScores = [origStruct.Gridness60' wtShufStruct.Gridness60' relearnStruct.Gridness60']; 

cols = {'DarkGrey', 'Red', 'Green'}; 
colMat = [0.66016 0.66016 0.66016; 1   0   0; 0.0 0.5 0.0]; 


figure('Position', [93 385 1679 403]);

%BAR GRAPH
subplot(1,4,1); 
hold on; 
for g = 1:3
    bg = bar(g, mean(gridnessScores(:,g),1));
    set(bg, 'FaceColor', rgb(cols{g}));
end
eb = errorbar(1:3, mean(gridnessScores,1), semfunct(gridnessScores,1)); 
set(eb, 'LineStyle', 'none', 'CapSize', 0, 'LineWidth', 1, 'Color', [0 0 0]); 
ylim([0 1.5]); 
set(gca, 'XTick', 1:3, 'XTickLabel', {'Original', 'Shuffled', 'Relearned'}); 
set(gca, 'FontName', 'Arial', 'FontSize', 12); 
ylabel('Gridness Scores'); 
set(gca, 'YTick', 0:.25:1.5); 
xlim([.25 3.75]); 
title('Bar Graph'); 
axis square; 


%VIOLIN PLOT
subplot(1,4,2); 
[h,L,MX,MED,bw] = violin(gridnessScores, 'facecolor', colMat); 
ylim([0 1.5]); 
set(gca, 'XTick', 1:3, 'XTickLabel', {'Original', 'Shuffled', 'Relearned'}); 
set(gca, 'FontName', 'Arial', 'FontSize', 12); 
set(gca, 'YTick', 0:.25:1.5)
title('Violin Plot'); 
axis square; 


%BOX PLOT
subplot(1,4,3); 
boxplot(gridnessScores);
ylim([0 1.5]); 
set(gca, 'XTick', 1:3, 'XTickLabel', {'Original', 'Shuffled', 'Relearned'}); 
set(gca, 'FontName', 'Arial', 'FontSize', 12); 
set(gca, 'YTick', 0:.25:1.5)
title('Box Plot'); 
axis square; 

%DOT PLOT
subplot(1,4,4); 
hold on; 
for g = 1:3
    sp = scatter(normrnd(g,0.1, [1 10]), gridnessScores(:,g)); 
    set(sp, 'MarkerFaceColor', rgb(cols{g}), 'MarkerEdgeColor', [0 0 0]); 
end
ylim([0 1.5]); 
set(gca, 'XTick', 1:3, 'XTickLabel', {'Original', 'Shuffled', 'Relearned'}); 
set(gca, 'FontName', 'Arial', 'FontSize', 12); 
set(gca, 'YTick', 0:.25:1.5); 
xlim([.25 3.75]); 
axis square; 
title('Dot Plot'); 
