function region = corrProj_9_3_attachHeadDirLabel(region)
% function region = corrProj_9_3_attachHeadDirLabel(region)
%
% PURPOSE:
%  To figure out whether each unit, grid cell or otherwise, is head-direction modulated and tag that
%  neuron as such in the data structure.
%
% INPUT:
%  region = project uber data structure
%
% OUPUT:
%  region = structure where each unit, within each bout, now has a field called 'hdMod' indicating
%           whether (1) or not (2)

% Directory for saving the head direction polar plots for each unit by session
saveDir = 'I:\STORAGE\LAB_STUFF\COLGIN_LAB\PROJECTS\Grid_Cell_Correlations_TrettelProj\MANUSCRIPT\NATURE_NEURO_SUBMISSION\REVISIONS\NEW_RESULTS\headDirPolarPlotsBySession';

regNames = {'MEC', 'CA1'};
cellTypeNames = {'GC', 'nGC'};

curDir = pwd;
dataDir = 'C:\Users\John Trimper\Desktop\LAB_STUFF\PROJECTS\Grid_Cell_Correlations_TrettelProj\CORR_PROJECT_RERUN\DATASET';
cd(dataDir);


reg = 1; %MEC only
fprintf('%s\n', regNames{reg});
cd(region(reg).name)
for r = 1:length(region(reg).rat)
    %     for r = 1
    fprintf('\tRat %d/%d\n', r, length(region(reg).rat));
    cd(region(reg).rat(r).name)
    
    for s = 1:length(region(reg).rat(r).session)
        fprintf('\t\tSession %d/%d\n', s, length(region(reg).rat(r).session));
        cd(['Session' num2str(s) '\Day1\OpenField'])
        
        unitIDs = [];
        t = 2; %Open Field Only
        d = 1; %Day 1 only
        for u = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(1).unit)
            unitIDs = [unitIDs; [region(reg).rat(r).session(s).day(d).task(t).bout(1).unit(u).ID...
                region(reg).rat(r).session(s).day(d).task(t).bout(1).unit(u).type]]; %#ok
        end
        spkHDs = cell(size(unitIDs,1), length(region(reg).rat(r).session(s).day(d).task(t).bout));
        
        clear HD;
        ttlDur = 0;
        for b = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout)
            %                     for b = 1:20
            fprintf('\t\t\t\tBout %d/%d\n', b, length(region(reg).rat(r).session(s).day(d).task(t).bout));
            cd(['Begin' num2str(b)]);
            
            %Get coords, bout duration, and head direction across the bout
            coords = read_in_coords('VT1.nvt', 100, 100);
            ttlDur = ttlDur + coords(end,1) - coords(1,1);
            HD{b} = get_head_direction('VT1.nvt'); %#ok
            
            for u = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit)
                uID = [region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).ID ...
                    region(reg).rat(r).session(s).day(d).task(t).bout(1).unit(u).type];
                uInd = find(unitIDs(:,1) == uID(1) & unitIDs(:,2) == uID(2) & unitIDs(:,3) == uID(3));
                if ~isempty(uInd)
                    spkTms = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).spkTms;
                    for st = 1:length(spkTms)
                        spkHdInd = find(HD{b}(:,1)<=spkTms(st),1,'Last');
                        spkHDs{uInd,b} = [spkHDs{uInd,b} HD{b}(spkHdInd,2)];
                    end
                end
            end
            
            cd ..
        end %bout
        
        
        % Assess head direction preference for each unit
        fprintf('\t\t\t\t\tAssessing head direction preference for each unit...\n');
        [~, watsonU2] = assess_head_dir_pref_xUnits_xBouts(spkHDs, HD);
        numHDCells = sum(watsonU2 >= 15);
        fprintf('\t\t\t\t\t\t%d head-direction cells\n', numHDCells);
        
        fprintf('\n');
        for u = 1:length(watsonU2)
            fprintf('\t\t\t\t\tUnit %d (%s) [%d-%d]\n', u, cellTypeNames{unitIDs(u,3)}, unitIDs(u,1:2));
            uID = unitIDs(u,:);
            hdModLgcl = 0;
            if watsonU2(u) > 15
                hdModLgcl = 1;
                fprintf('\t\t\t\t\t\tHD mod\n');
            else
                fprintf('\t\t\t\t\t\tNot HD mod\n');
            end
            for d = 1:length(region(reg).rat(r).session(s).day)
                %                     fprintf('\t\tDay %d\n', d);
                for t = 1:length(region(reg).rat(r).session(s).day(d).task)
                    %                         fprintf('\t\t\tTask %d\n', t);
                    for b = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout)
                        %                             fprintf('\t\t\t\tBout %d\n', b);
                        for uu = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit)
                            
                            tmpID = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(uu).ID;
                            %                                 fprintf('\t\t\t\t\tSub-Unit %d [%d-%d]\n', uu,tmpID);

                            if tmpID(1) == uID(1) & tmpID(2) == uID(2) %#ok
                                region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(uu).hdMod = hdModLgcl;
                                break
                            end %if unit IDs match
                        end %comparing IDs to each unit
                    end %bout
                end %day
            end %task
        end %unit
        fprintf('\n');
        
        tmpDir = pwd;
        cd(saveDir);
        savefig(['R' num2str(r) 'S' num2str(s)]);
        close all;
        cd(tmpDir);
        
        
        cd ../../..
    end %session
    cd ..
end %rat




gcTtl = 0;
cjTtl = 0;
nGcTtl = 0;
hdTtl = 0;
for r = 1:length(region(reg).rat)
    fprintf('\tRat %d/%d\n', r, length(region(reg).rat));
    for s = 1:length(region(reg).rat(r).session)
        fprintf('\t\tSession %d/%d\n', s, length(region(reg).rat(r).session));
        
        gcCntr = 0;
        cjCntr = 0;
        nGcCntr = 0;
        hdCntr = 0;
        
        t = 2; %Open Field
        d = 1; %Day 1 only
        
        for b = 1
            for u = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit)
                
                gcOrNo = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).type;
                hdMod = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).hdMod;
                
                if gcOrNo == 1 & hdMod == 0
                    gcCntr = gcCntr + 1;
                elseif gcOrNo == 1 & hdMod == 1
                    gcCntr = gcCntr + 1;
                    cjCntr = cjCntr + 1;
                elseif gcOrNo == 2 & hdMod == 0
                    nGcCntr = nGcCntr + 1;
                elseif gcOrNo == 2 & hdMod == 1
                    nGcCntr = nGcCntr + 1;
                    hdCntr = hdCntr + 1;
                end
            end
        end
        
        
        fprintf('\t\t\t%d Grid Cells\n\t\t\t\t%d Directionally Modulated\n', gcCntr, cjCntr);
        fprintf('\t\t\t%d Non-Grid Cells\n\t\t\t\t%d Directionally Modulated\n', nGcCntr, hdCntr);
        
        gcTtl = gcTtl + gcCntr;
        cjTtl = cjTtl + cjCntr;
        nGcTtl = nGcTtl + nGcCntr;
        hdTtl = hdTtl + hdCntr;
        
    end
end

fprintf('\nACROSS ALL RATS AND SESSIONS:\n');
fprintf('\t%d Grid Cells\n\t\t%d Directionally Modulated\n', gcTtl, cjTtl);
fprintf('\t%d Non-Grid Cells\n\t\t%d Directionally Modulated\n', nGcTtl, hdTtl);



keyboard

cd(curDir);
end