function region = corrProj_9_3b_attachHeadDirDistrib(region)
% function region = corrProj_9_3b_attachHeadDirDistrib(region)
%
% PURPOSE:
%  To attach a matrix for each unit, for each open field bout, that shows the distribution of spikes
%  and time by head direction. It is a 60x3 matrix where 60 is the number of bins, column 1 is the 
%  radial angle corresponding to each bin, column 2 is the time spent facing each direction, and column
%  3 is the number of spikes fired in each direction. Head direction modulation (corrProj_9_3_...) is 
%  based on these values summed across bouts (i.e., total # of spikes per direction / total amount of 
%  time per direction  = firing rate per direction). 
%
% INPUT:
%
%
% OUTPUT: 
%   region = project uber data structure with the matrix described above attached to the structure. 
%
% JBT 12/2017
% Colgin Lab



binWidth = 6; %degrees
binEdges = 0:binWidth:360;

regNames = {'MEC', 'CA1'};

curDir = pwd;
dataDir = 'C:\Users\John Trimper\Desktop\LAB_STUFF\PROJECTS\Grid_Cell_Correlations_TrettelProj\CORR_PROJECT_RERUN\DATASET';
cd(dataDir);


reg = 1; %MEC only
fprintf('%s\n', regNames{reg});
cd(region(reg).name)
for r = 1:length(region(reg).rat)
    
    fprintf('\tRat %d/%d\n', r, length(region(reg).rat));
    cd(region(reg).rat(r).name)
    
    for s = 1:length(region(reg).rat(r).session)
        fprintf('\t\tSession %d/%d\n', s, length(region(reg).rat(r).session));
        cd(['Session' num2str(s) '\Day1\OpenField'])
        
        t = 2; %Open Field Only
        d = 1; %Day 1 only
        
        ttlDur = 0;
        for b = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout)
            %                     for b = 1:20
            fprintf('\t\t\t\tBout %d/%d\n', b, length(region(reg).rat(r).session(s).day(d).task(t).bout));
            cd(['Begin' num2str(b)]);
            
            %Get coords, bout duration, and head direction across the bout
            coords = read_in_coords('VT1.nvt', 100, 100);
            ttlDur = ttlDur + coords(end,1) - coords(1,1);
            HD = get_head_direction('VT1.nvt');
            
            %Get time spent facing each direction across the bout
            tpf = mean(diff(HD(:,1)));
            [~,R] = rose(deg2rad(HD(:,2)),length(binEdges)-1);
            fpb = R(3:4:end);  %# frames in each bin; distribution of head direction across bout
            timeInBin = fpb .* tpf; %amount of time spent facing each direction
            
            
            for u = 1:length(region(reg).rat(r).session(s).day(d).task(t).bout(b).unit)
                
                spkTms = region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).spkTms;
                if ~isempty(spkTms)
                    spkHDs = zeros(1,length(spkTms));
                    for st = 1:length(spkTms)
                        spkHdInd = find(HD(:,1)<=spkTms(st),1,'Last');
                        if ~isempty(spkHdInd) && spkHdInd <= size(HD,1)
                            spkHDs(st) =  HD(spkHdInd,2);
                        end
                    end
                    
                    [T,R] = rose(deg2rad(spkHDs),length(binEdges)-1);
                    spksPerBin = R(3:4:end); %spike count per angular bin
                    binAngs = T(3:4:end); %angle for each bin
                    
                    region(reg).rat(r).session(s).day(d).task(t).bout(b).unit(u).spkHDDist = [binAngs' timeInBin' spksPerBin'];
                    
                end
                
            end
            
            
            cd ..
        end %bout
        
        cd ../../..
    end %session
    cd ..
end %rat




cd(curDir);
end