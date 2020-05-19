function region = corrProj_10_1_debugRemoveDuplicateUnits(region)
% function region = corrProj_10_1_debugRemoveDuplicateUnits(region)
%
% PURPOSE:
%  Sean had some cells he labelled as non-grid cells and gave different *.t files to even though
%  they're definitely the same cells as the grid cells by the same name. I identified these by
%  looking at rate-maps, spike-time histograms, and head-direction polar plots. You can also
%  reference the code 'tmp_debugHD.m'. For all of these, I'm removing the nGC since they are clearly
%  grid cells.
%
% NOTE:
%   It's important to do this before you look at relationships between unclassified non-grid cells
%   and grid cells or between unclassified non-grid cells. It doesn't impact any of the analyses
%   that just look at head direction or conjunctive cells (meaning I don't have to re-do anything done so far).
%
%  DUPLICATES:
%   RAT 2, SESSION 1, UNIT 2 (GC) AND UNIT 10 (nGC)
%   RAT 6, SESSION 1, UNIT 2 (GC) AND UNIT 21 (nGC)
%   RAT 6, SESSION 1, UNIT 4 (GC) AND UNIT 22 (nGC)
%   RAT 6, SESSION 1, UNIT 5 (GC) AND UNIT 23 (nGC)
%
% INPUT:
%  region = any of the 'region' data structures.
%
% OUTPUT:
%  same as input, with those non-grid cells removed
%
% JB Trimper
% 5/2018
% Colgin Lab


badUnits =  [2     1    10     8     4;
    6     1    21     8     2;
    6     1    22     8     4;
    6     1    23     8     5];



reg = 1;

for u = 1:size(badUnits,1)
    r = badUnits(u,1);
    s = badUnits(u,2);
    uID = badUnits(u,4:5);
    
    
    %% REMOVE THE BAD UNITS
    for d = 1:length(region(reg).rat(r).session(s).day)
        for t = 1:length(region(reg).rat(r).session(s).day(d).task)
            for b = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout)
                badUInd = [];
                for uu = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit)
                    tmpID = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(uu).ID;
                    tmpType = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(uu).type;
                    if tmpID(1) == uID(1)   &   tmpID(2) == uID(2)   &   tmpType == 2 %#ok
                        badUInd = uu;
                    end
                end
                if ~isempty(badUInd)
                    region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(badUInd) = [];
                end
            end
        end
    end
    
    
    
    %% REMOVE CELL PAIRS CONTAINING THE BAD UNITS
    
    badCPs = [];
    for cp = 1:length(region(reg).rat(r).session(s).state(1).cellPair)
        u1ID = region(reg).rat(r).session(s).state(1).cellPair(cp).unitIDs(1,:);
        u2ID = region(reg).rat(r).session(s).state(1).cellPair(cp).unitIDs(2,:);
        
        if (u1ID(1) == uID(1)  &   u1ID(2) == uID(2)   &   u1ID(3) == 2 ) || ...
                (u2ID(1) == uID(1)  &   u2ID(2) == uID(2)   &   u2ID(3) == 2 ) %#ok
            badCPs = [badCPs cp]; %#ok
        end
    end
    for ss = 1:3
        region(reg).rat(r).session(s).state(ss).cellPair(badCPs) = [];
    end
    
end