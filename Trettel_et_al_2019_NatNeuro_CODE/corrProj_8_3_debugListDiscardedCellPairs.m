% function corrProj_8_3_debugListDiscardedCellPairs
%
% You have to just copy and paste this in close to the end off corrProj_6... before the bad pairs are removed. 
%
% JBT 9/2017
% Colgin Lab

regNames = {'MEC', 'CA1'}; 

fprintf('Discarded %s Cell Pairs:\n', regNames{reg});
for bp = 1:length(badPairs)
    bpNum = badPairs(bp); 
    fprintf('\tBad Pair #%d\n', bp);
    cause = [0 0 0];
    cellIDs = cellRegion(reg).cellPair(bpNum).info;
    fprintf('\t\tRat %d, Ses %d\n', cellIDs(1:2)); 
    unit1 = cellIDs(4:5);
    fprintf('\t\tCell 1: T%d, U%d\n', unit1);
    unit2 = cellIDs(6:7);
    fprintf('\t\tCell 2: T%d, U%d\n', unit2);
    if ~isempty(find(pkCcBadPairs == badPairs(bp), 1))
        cause(1) = 1; 
    end
    if ~isempty(find(sameTetBadPairs == badPairs(bp), 1))
        cause(2) = 1; 
    end
    if ~isempty(find(spatPerBadPairs == badPairs(bp), 1))
        cause(3) = 1; 
    end

    fprintf('\t\t\tReason:\n'); 
    if cause(1) == 1
        fprintf('\t\t\t\tMax cross-corr value too low.\n');
    end
    if cause(2) == 1
        fprintf('\t\t\t\tSame tet, ctr bin val too high.\n');
    end
    if cause(3) == 1
        fprintf('\t\t\t\tSpatial period ratio < 0.7.\n');
    end
    
end




end %fnctn