function region = tmp_fix_EH_bad_tet_num(region)
%
% One of Ernie's rat's (Rat-100) had a unit (TT2_12) with double digit
% unit #. It's the only one and it threw NaNs into my structure so this fixes it. 
%
% This function only needs to be run once though. The fix is already built in to the 
% function that originally read it wrong (corrProj_1_make...)
%
% JBT 8/2017
% Colgin Lab


reg = 2; 
r = 3; 
s = 1; 
d = 1; 

for t = [1 3]
    fprintf('Task %d\n', t);
    for b = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout)
        fprintf('\tBout %d\n', b);
        for u = 11:13
            uID = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).ID; 
            if isnan(uID(1))
                uID(1) = 9; 
            end
            if uID(2) == 2
                uID(2) = 12; 
            end
            region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).ID = uID; 
        end
    end
end

%% check that it's right
for t = [1 3]
    fprintf('Task %d\n', t);
    for b = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout)
        fprintf('\tBout %d: ', b);
     region(reg).rat(r).session(s).day(d).task(t).bout(b).unit.ID
    end
end