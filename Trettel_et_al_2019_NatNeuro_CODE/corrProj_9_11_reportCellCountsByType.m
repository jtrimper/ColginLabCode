function corrProj_9_11_reportCellCountsByType(region)
% function corrProj_9_11_reportCellCountsByType(region)
%
% PURPOSE:
%   To report the number of grid cells, conjunctive cells, head direction cells, and
%   unclassified cells by rat and total across rats
%
% INPUT:
%   region = corr project uber data structure
%
% JB Trimper
% 5/2018
% Colgin Lab


reg = 1;
t = 2;
d = 1;
b = 1; 

ctCntr = [0 0 0 0];
for r = 1:length(region(reg).rat)
    fprintf('Rat %d\n', r);
    inRatCntr = [0 0 0 0];
    for s = 1:length(region(reg).rat(r).session)
        for u = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(1).unit)
            if region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).type == 1
                gcOrNo = 1;
            else
                gcOrNo = 0;
            end
            if region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).hdMod == 1
                hdOrNo = 1;
            else
                hdOrNo = 0;
            end
            
            
            if gcOrNo == 1 && hdOrNo == 0
                inRatCntr(1) = inRatCntr(1) + 1; %grid cell
            elseif  gcOrNo == 1 && hdOrNo == 1
                inRatCntr(2) = inRatCntr(2) + 1; %conjunctive
            elseif  gcOrNo == 0 && hdOrNo == 1
                inRatCntr(3) = inRatCntr(3) + 1; %head dir
            else
                inRatCntr(4) = inRatCntr(4) + 1; %unclassified
            end
            
        end
    end
    fprintf('\tGrid Cells: %d\n\tConjunctive Cells: %d\n\tHead Dir Cells: %d\n\tUnclassified: %d\n\n', inRatCntr);
    ctCntr = ctCntr + inRatCntr;
end
fprintf('\nTOTAL:\n');
fprintf('\tGrid Cells: %d\n\tConjunctive Cells: %d\n\tHead Dir Cells: %d\n\tUnclassified: %d\n\n', ctCntr);



end
