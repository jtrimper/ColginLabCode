% function tmp_phasePrecessionAnalysis(group)


%% CODE TO FIGURE OUT PHASE PRECESSION ANALYSES

load('C:\Users\John\Desktop\LAB_STUFF\PROJECTS\FMR1\DATA_STRUCTS\fmr1_dataStruct_badTetsRmved_allDays.mat') %#ok

cd('C:\Users\John\Desktop\LAB_STUFF\PROJECTS\FMR1\RAW_DATA\WT\Rat196\2018-10-27\begin1');


g = 2;
r = 4;
d = 11;
b = 1;
reg = 1;

rmBinSize = 5;

cd(group(g).rat(r).day(d).begin(b).dir)

coords = group(g).rat(r).day(d).begin(b).coords;
unitData = group(g).rat(r).day(d).begin(b).region(reg).unit;
for u = 1:length(unitData)
    fprintf('Unit %d/%d\n', u, length(unitData));
    
    ID = unitData(u).ID;
    
    tetNum = num2str(ID(1));
    tetRoot = ['CSC' tetNum];
    lfpStruct = read_in_lfp([tetRoot '.ncs']);
    
    tmp = load([tetRoot '_BroadThetaFiltLfp.mat']);
    lfpStruct.broadThetaLfp = tmp.filtLfp;
    
    tmp = load([tetRoot '_ThetaFiltLfp.mat']);
    lfpStruct.narrowThetaLfp = tmp.filtLfp;
    
    phiTms = get_theta_phase_times(lfpStruct);
    phiVctr = get_asym_theta_phi_vector(lfpStruct);
    
    smRm = unitData(u).smRateMap;
    spkTms = unitData(u).spkTms;
    pf = get_2d_pfs(smRm, rmBinSize);
    
    pf = get_2d_pf_passes(coords, pf, smRm, rmBinSize);
    for p = 1:length(pf)
        if ~isempty(pf(p).passes)
            
            
            for pp = 1:size(pf(p).passes,1)
                
                startInd = pf(p).passes(pp,1);
                startTm = coords(startInd,1); %start time for the pass
                
                endInd = pf(p).passes(pp,2);
                endTm = coords(endInd,1); %end time for the pass
                
                %find in-pass time for when rat is closest to pf peak
                passCoords = coords(pf(p).passes(pp,1):pf(p).passes(pp,2),2:3);
                passDist = sqrt((passCoords(:,1) - pf(p).pkCoords(1)).^2 + (passCoords(:,2) - pf(p).pkCoords(2)).^2);
                [~, minInd] = min(passDist);
                transTime = coords(pf(p).passes(pp,1)+minInd-1,1);
                
                passSpks = spkTms(spkTms>=startTm & spkTms<=endTm);
                
                
                if length(passSpks)>=5 %If at least 5 spikes were present
                    
                    firstCycle = find(phiTms(1,:)<=passSpks(1), 1, 'Last');
                    lastCycle = find(phiTms(1,:)>=passSpks(end), 1, 'First');
                    
                    if range(firstCycle:lastCycle)+1 >= 4 %and those spikes covered a range of at least 4 theta cycles
                        
                        firstCycle = firstCycle - 2;
                        startSwpInd = find(lfpStruct.ts<=phiTms(4,firstCycle), 1, 'Last');
                        
                        lastCycle = lastCycle + 1;
                        endSwpInd = find(lfpStruct.ts>=phiTms(4,lastCycle), 1, 'First');
                        
                        figure('Position', [5 558 1912 420]);
                        plot(lfpStruct.ts(startSwpInd:endSwpInd), lfpStruct.data(startSwpInd:endSwpInd), 'k');
                        hold on;
                        xlim([lfpStruct.ts(startSwpInd) lfpStruct.ts(endSwpInd)]);
                        zero_line;
                        
                        spkPhis = zeros(1,length(passSpks));
                        spkPos = zeros(1,length(passSpks));
                        for st = 1:length(passSpks)
                            spkLfpInd = find(lfpStruct.ts<=passSpks(st), 1, 'Last');
                            spkPhis(st) = phiVctr(spkLfpInd);
                            
                            posInd = find(coords(:,1)<=passSpks(st), 1, 'Last');
                            tmpSpkPos = coords(posInd,2:3);
                            
                            %Get spike distance relative to peak of firing field
                            spkPos(st) = sqrt((tmpSpkPos(1) - pf(p).pkCoords(1)).^2 + (tmpSpkPos(2) - pf(p).pkCoords(2)).^2);
                            
                            %If spike was before rat passed by the peak, make it negative
                            if passSpks(st)<transTime
                                spkPos(st) = -spkPos(st);
                            end
                            
                            plot(lfpStruct.ts(spkLfpInd), lfpStruct.data(spkLfpInd), '.', 'MarkerSize', 30);
                        end
                        
                        [beta,R2,pVal] = CircularRegression(spkPos,spkPhis);
                        
                        title(['Unit ' num2str(u) ': beta1 = ' num2str(beta(1)) '; r = ' num2str(sqrt(R2)) '; p = ' num2str(pVal)]);
                        
                        figure;
                        plot(spkPos, spkPhis, '*');
                        ylim([-pi pi]);
                        xlim([-15 15]);
                        
                    end %if at least 4 theta cycles covered
                end %if at least 5 spikes during pass
            end %each pass
        end %if passes
    end %each placefield
end %each unit
















