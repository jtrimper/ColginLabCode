function pf = phase_precession_2d(spkTms, coords, pf, lfpStruct)
% function pf = phase_precession_2d(spkTms, coords, pf, lfpStruct)
%
% PURPOSE:
%   Function assesses phase precession, providing spike phases by position and phase-precession stats
%
% INPUT:
%     spkTms = vector of spike times for the unit
%     coords = matrix of rat's coordinates by time (output of 'read_in_coords')
%         pf = structure for each place-field (output of 'get_2d_pfs' then passed through 'get_2d_pf_passes')
%  lfpStruct = lfp structure with broad and narrow theta filtered LFPs attached as described in documention
%              for 'get_theta_phase_times'
%
% OUTPUT:
%    pf = inputted structure with addition subfields:
%          1) pf.passSpkTms (spk times for each pass)
%          2) pf.passSpkPhis (spk theta phases for each pass)
%          3) pf.passSpkPos (spk positions, relative to pf peak, for each pass)
%          4) pf.passPPStats (phiPrecess stats; matrix of slope, intercept, R^2, and pVal for each pass)
%
% JB Trimper
% 09/2019
% Colgin Lab




for p = 1:length(pf)
    pf(p).passSpkTms = cell(size(pf(p).passes,1),1); %cell containing spkTms for each pass
    pf(p).passSpkPhis = cell(size(pf(p).passes,1),1); %cell containing theta spk phase for each pass
    pf(p).passSpkPos = cell(size(pf(p).passes,1),1); %cell containing spkTms for each pass
    pf(p).passPPStats = nan(size(pf(p).passes,1),4); %matrix of slope, intercept, R^2, and pVal for each pass
end



phiTms = get_theta_phase_times(lfpStruct);
phiVctr = get_asym_theta_phi_vector(lfpStruct);


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
                        
                    end
                    
                    [beta,R2,pVal] = CircularRegression(spkPos,spkPhis);
                    
                    pf(p).passSpkTms{pp} = passSpks;
                    pf(p).passSpkPhis{pp} = spkPhis;
                    pf(p).passSpkPos{pp} = spkPos;
                    pf(p).passPPStats(pp,:) = [beta R2 pVal]; %slope intercept R^2 sigVal
                    
                    
                end %if at least 4 theta cycles covered
            end %if at least 5 spikes during pass
        end %each pass
    end %if passes
end %each placefield