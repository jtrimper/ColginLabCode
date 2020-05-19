function region = corrProj_7_9_reportCellCountsByType(region)
% function region = corrProj_7_9_reportCellCountsByType(region)
%
% PURPOSE: 
%   To get the counts for each cell type by rat and across all rats. 
%     For head direction, following Johnson et al., 2005, Hippocampus (Redish Lab)
%     For interneuron, following result in Fyhn et al., 2004 (Moser Lab) [informed by Frank et al., 2001 (Wilson Lab)]
%     For border cell, following Solstad et al., 2008 (Moser Lab) and Boccara et al., 2010
%
% INPUT: 
%   region = project uber data struct passed through corrProj 1-6
%  
% OUTPUT: 
%   region = same as input, but for MEC (reg = 2), new field 'class' attached for each Open Field bout
%            for each session that is a cell array indicating whether unit is: 
%               UC (unclassified)
%               IN (interneuron), 
%               HD (head direction)
%               BC (border cell)
%               GC (grid cell) 
%                 *cell array could indicate cell is more than one of these
%
% JBT 9/2017
% Colgin Lab


rmBinSize = 2.5; %cm; this is used for border cell detection and 2.5 is what Solstad et al used

curDir = pwd;
dataDir = 'H:\CORR_PROJECT_RERUN\DATASET';
cd(dataDir);

WastsonU2Cut = 15; %test statistic cutoff for Watson's U2 for whether or not unit is an HD cell
%     Redish lab picked arbitrary cutoff (>=10) after inspecting the radial distributions for each neuron and seeing
%     which U2 value legit looked like the neuron had a head direction preference. I did the same and landed on 15. 
intFrCut = 10; %Hz = cutoff for whether or not the neuron is an interneuron

%% FOR MEC, DAY 1 OF EACH SESSION, TASK 2 (OPEN FIELD)
reg = 1;
d = 1;
t = 2;


cd(region(reg).name)
for r = 1:length(region(reg).rat)
    fprintf('\t%s\n', region(reg).rat(r).name);
    cd(region(reg).rat(r).name)
    for s = 1:length(region(reg).rat(r).session)
        fprintf('\t\tSession %d\n', s);
        cd(['Session' num2str(s)])
        fprintf('\t\t\tDay %d\n', d);
        cd(['Day' num2str(d)])
        
        cd(region(reg).rat(r).session(s).day(d).task(t).name);
        fprintf('\t\t\t\t%s\n', region(reg).rat(r).session(s).day(d).task(t).name)
        
        
        gcUnitIDs = [];
        hdCellIDs = [];
        brdrCellIDs = []; 
        intIDs = []; 
        
        
        smRateMaps = nan(floor(100/rmBinSize),floor(100/rmBinSize), length(region(reg).rat(r).session(s).day(d).task(t).bout(1).unit), length(region(reg).rat(r).session(s).day(d).task(t).bout));
        HD = cell(1,3);
        spkHd = cell(length(region(reg).rat(r).session(s).day(d).task(t).bout(1).unit), length(region(reg).rat(r).session(s).day(d).task(t).bout));
        unitFr = nan(length(region(reg).rat(r).session(s).day(d).task(t).bout(1).unit), length(region(reg).rat(r).session(s).day(d).task(t).bout));
        
        for b = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout)
            fprintf('\t\t\t\t\tBout %d\n', b);
            cd(['Begin' num2str(b)]);
            
            % GET HEAD DIRECTION
            HD{b} = get_head_direction('VT1.nvt'); 
            
            % BOUT DURATION (for firing rate, for figuring out if int or not)
            boutDur = HD{b}(end,1) - HD{b}(1,1);
            
            % GET RAT COORDINATES FOR RATEMAP
            coords = region(reg).rat(r).session(s).day(d).task(t).bout(b).coords; 
            
            fprintf('\t\t\t\t\t\tGetting head direction for each spike...\n'); 
            for u = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit)
                fprintf('\t\t\t\t\t\t\tUnit %d\n', u); 
                
                spkTms = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).spkTms;
                unitFr(u,b) = length(spkTms)/boutDur;
                
                % CALCULATE RATE MAP
                rateMap = get_ratemap(spkTms, coords, [100 100], rmBinSize);
                smRateMaps(:,:,u,b) = gc_ratemap_smooth(rateMap); % <- smooth with a normalized version of the window Sean said to use
                
                for st = 1:length(spkTms)
                    tmpTm = spkTms(st);
                    hdInd = find(HD{b}(:,1)<=tmpTm, 1, 'Last');
                    
                    if isempty(hdInd) %if the spk occurred right when the video started, hdInd will be empty so just use the first frame
                        hdInd = 1;
                    end
                    
                    spkHd{u,b}(st) = HD{b}(hdInd,2);
                    
                end
                
                if region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).type == 1
                    gcUnitIDs = [gcUnitIDs u];
                end
                
            end %unit
            cd ..
        end% %bout
        
        
        % CHECK ALL UNITS FOR WHETHER OR NOT THEY'RE HD CELLS
        %    Compare distribution of head direction at times of spiking to distributions of head direction
        %    across the whole session
        fprintf('\t\t\t\t\t\tEvaluating whether or not units are HD cells...\n'); 
        [~, WatsonU2] = assess_head_dir_pref_xUnits_xBouts(spkHd, HD); 
        for u = 1:length(WatsonU2)
            tmpVal = WatsonU2(u);
            for b = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout)
                if tmpVal >= WastsonU2Cut
                    region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).HDorNot = 1;
                else
                    region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).HDorNot = 0;
                end
            end
        end
        
        % CHECK WHETHER OR NOT UNIT WAS AN INTERNEURON BASED ON FIRING RATE
        unitFr = nanmean(unitFr,2); 
        for u = 1:length(unitFr)
             for b = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout)
                if unitFr(u) >= intFrCut
                    region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).INorNot = 1;
                else
                    region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).INorNot = 0;
                end
             end
        end
                
                
        keyboard
%         
% %         CHECK WHETHER OR NOT UNIT IS A BORDER CELL
%         smRateMaps = mean(smRateMaps,4); 
%         for u = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit)
%             is_border_cell2(smRateMaps(:,:,u), rmBinSize)
%         end
%         
        
        
    end %session
end %rat


cd(curDir);

end %function
