function corrProj_7_10_plotRateMaps(region)
% function corrProj_7_10_plotRateMaps(region)
%
% PURPOSE:
%  To plot rate maps for each MEC cell across open-field bouts.
%  Purpose is to look for border cells.
%
% INPUT:
%  region = project uber data structure
%
% OUTPUT:
%   Figures saved in the save directory specified at top of function.
%
% JBT 9/2017
% Colgin Lab

saveFigs = 1; %set to 1 to save figures (will over-write)
saveDir = 'H:\CORR_PROJECT_RERUN\RESULTS\Ratemaps';

reg = 1;
t = 2;
d = 1;

for r = 1:length(region(reg).rat)
    fprintf('Rat %d\n', r);
    for s = 1:length(region(reg).rat(r).session)
        fprintf('\tSession %d\n', s);
        spkCnt = zeros(33,33,length(region(reg).rat(r).session(s).day(d).task(t).bout(1).unit));
        timePerBin = zeros(33,33,length(region(reg).rat(r).session(s).day(d).task(t).bout(1).unit));
        for b = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout)
            fprintf('\t\tBout %d\n', b);
            coords = region(reg).rat(r).session(s).day(d).task(t).bout(b).coords;
            for u = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit)
                fprintf('\t\t\tUnit %d\n', u);
                spkTms = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).spkTms;
                [~, tmpCnt, tmpTpb] = get_ratemap(spkTms, coords, [100 100], 3, 0);
                spkCnt(:,:,u) = spkCnt(:,:,u) + tmpCnt;
                timePerBin(:,:,u) = timePerBin(:,:,u) + tmpTpb;
            end %unit
        end %bout
        
        
        rateMap = spkCnt ./ timePerBin;
        for u = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit)
            type = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).type;  
            if type == 1
                cellType = 'gridCell_'; 
                ctAbbrev = ', gc'; 
            else
                cellType = 'nonGrid_'; 
                ctAbbrev = ', nGc'; 
            end
            uId = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).ID;
            figName = [cellType 'R' num2str(r) 'S' num2str(s) 'U' num2str(u) '_T' num2str(uId(1)) 'U' num2str(uId(2))];
            tmpFig = figure('name', figName, 'Position', [528   402   584   473]);
            tmpMap = boxcarSmoothing(rateMap(:,:,u));
            plot_2d_nan_ratemap(tmpMap, 3);
            axis square
            xlabel('Position (cm)');
            ylabel('Position (cm)');
            plotTtl = ['Rat ' num2str(r) '; Ses ' num2str(s) '; Unit ' num2str(u) ' (Tet #' num2str(uId(1)) ', Unit #' num2str(uId(2)) ctAbbrev ')'];
            title(plotTtl)
            set(gca, 'FontName', 'Arial', 'FontSize', 14);
            
            if saveFigs == 1
                tmpDir = pwd;
                cd(saveDir);
                print(figName, '-dpng');
                cd(tmpDir);
            end
            
            close(tmpFig);
        end %unit
        
        
        
        
    end %session
end %rat


end %fnctn