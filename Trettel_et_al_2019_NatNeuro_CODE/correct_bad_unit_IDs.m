function region = correct_bad_unit_IDs(region)
% function region = correct_bad_unit_IDs(region)
%
% I noticed that several of the unit IDs in the main data structure were NaNs and this function
% is to correct that. It should do nothing at all if there are no NaNs (just in case you 
% accidentally re-run it or something. 
%
% JBT 12/2017
% Colgin Lab





%Print the list of units by session to see if there are NaNs
cellTypeNames = {'GC', 'nGc'};
for reg = 1
    fprintf('Region %d\n', reg);
    for r = 1:length(region(reg).rat)
        fprintf('\t%s\n', region(reg).rat(r).name)
        for s = 1:length(region(reg).rat(r).session)
            fprintf('\t\tSession %d\n', s)
            for d = 1
                for t = 3
                    for b = 1
                        for u = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit)
                            uID = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).ID;
                            uType = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).type;
                            fprintf('\t\t\tUnit %d (%s): T%d U%d\n', u, cellTypeNames{uType}, uID(1), uID(2));
                        end
                    end %bout
                end %task
            end %day
        end %session
    end %rat
end %region
fprintf('\n\n\n'); 





%These are the rat/sessions with problem unit IDs
      %   1     2     3     4     5     6     7     8     9     10    11    12    13 
rsIDs = [1 6;  1 7;  2 1;  2 2;  2 4;  3 2;  3 3;  3 4;  6 1;  6 2;  6 3;  6 4;  6 5];

%These are the correct unit IDs
tetLists{1} = [12 1; 12 2; 12 3; 12 4]; %1 (1-6)
tetLists{2} = [11 1; 12 1; 12 2; 12 3]; %2 (1-7)
tetLists{3} = [11 1; 11 2; 11 3]; %3 (2-1)
tetLists{4} = [12 3]; %4 (2-2)
tetLists{5} = [12 2; 12 4]; %5 (2-4)
tetLists{6} = [12 3]; %6 (3-2)
tetLists{7} = [12 6]; %7 (3-3)
tetLists{8} = [11 1]; %8 (3-4)
tetLists{9} = [10 2; 10 5; 11 1; 11 2]; %9 (6-1)
tetLists{10} = [10 3; 11 1; 11 3; 12 1; 12 2; 12 3; 12 4; 12 5; 12 6]; %10 (6-2)
tetLists{11} = [10 1; 10 2; 10 3; 12 2]; %11 (6-3)
tetLists{12} = [11 2; 12 2; 12 6; 12 7; 12 8]; %12 (6-4)
tetLists{13} = [10 1; 10 2; 11 1; 11 2; 12 1; 12 2]; %13 (6-5)





% Find the NaN unit IDs and correct them
taskNames = {'LinearTrack', 'OpenField', 'Overnight'};
cd('C:\Users\John Trimper\Desktop\LAB_STUFF\PROJECTS\Grid_Cell_Correlations_TrettelProj\CORR_PROJECT_RERUN\DATASET');
for reg = 1
    fprintf('Region %d\n', reg);
    cd('MEC');
    for r = 1:length(region(reg).rat)
        fprintf('\t%s\n', region(reg).rat(r).name)
        cd(region(reg).rat(r).name);
        for s = 1:length(region(reg).rat(r).session)
            fprintf('\t\tSession %d\n', s)
            cd(['Session' num2str(s)]);
            for d = 1
                cd(['Day' num2str(d)]);
                for t = 1:length(region(reg).rat(r).session(s).day(d).task)
                    cd(taskNames{t});
                    for b = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout)
                        if t < 3
                            cd(['Begin' num2str(b)]);
                        else
                            cd(['Sleep' num2str(b)]);
                        end
                        for u = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit)
                            uID = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).ID;
                            spkTms = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).spkTms;
                            if isnan(uID(2))
                                rsInd = find(rsIDs(:,1) == r & rsIDs(:,2) == s);
                                goodUIDList = tetLists{rsInd}; %#ok
                                for gu = 1:size(goodUIDList,1)
                                    guID = goodUIDList(gu,:);
                                    ttFn = ['TT' num2str(guID(1)) '_' num2str(guID(2)) '_NonGC.t'];
                                    try
                                        guSpkTms = Readtfile(ttFn);
                                        guSpkTms = guSpkTms ./ 10 ^ 4;
                                        readCheck = 1;
                                    catch
                                        readCheck = 0;
                                    end
                                    
                                    if readCheck == 1
                                        if guSpkTms(1) == spkTms(1)
                                            region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).ID = guID; 
                                        end
                                    end
                                end
                            end
                        end %unit
                        cd ..
                    end %bout
                    cd ..
                end %task
                cd ..
            end %day
            cd ..
        end %session
        cd ..
    end %rat
    cd ..
end %region



%Print the list again so you can see if it's right now
cellTypeNames = {'GC', 'nGc'};
for reg = 1
    fprintf('Region %d\n', reg);
    for r = 1:length(region(reg).rat)
        fprintf('\t%s\n', region(reg).rat(r).name)
        for s = 1:length(region(reg).rat(r).session)
            fprintf('\t\tSession %d\n', s)
            for d = 1
                for t = 3
                    for b = 1
                        for u = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit)
                            uID = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).ID;
                            uType = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).type;
                            fprintf('\t\t\tUnit %d (%s): T%d U%d\n', u, cellTypeNames{uType}, uID(1), uID(2));
                        end
                    end %bout
                end %task
            end %day
        end %session
    end %rat
end %region

    
    
    