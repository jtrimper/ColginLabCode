function asymInd = calc_theta_asym_ind(startStopTimes, thetaQuartTimes)
% function asymInd = calc_theta_asym_ind(startStopTimes, thetaQuartTimes)
%
% PURPOSE: 
% To find average theta asymmetry re: Belluscio et al., 2012
% log10 ratio of falling+trough/peak+rise
%
% INPUT: 
%   startStopTimes = the LFP boundary indices for each window in which you would like to evaluate 
%                    the asymmetry index
%  thetaQuartTimes = the times corresponding to the center of each theta phase 
%                    [output of get_theta_phase_times]
%
% JB Trimper
% 5/16
% Manns Lab


asymInd = nan(size(startStopTimes,1),1); 
for t = 1:size(startStopTimes,1);
    startTime = startStopTimes(t,1);
    endTime = startStopTimes(t,2);
    
    firstCycleInd = find(thetaQuartTimes(1,:)>=startTime, 1, 'First');
    lastCycleInd = find(thetaQuartTimes(4,:)<=endTime, 1, 'Last');
    
    if lastCycleInd - firstCycleInd > 1 %if at least two cycles
        
        firstCycleInd = firstCycleInd - 1;
        lastCycleInd = lastCycleInd + 1;
        
        thetaData = thetaQuartTimes(:,firstCycleInd:lastCycleInd);
        
        tmp = thetaData(4:numel(thetaData)-3);
        
        for i = 2:length(tmp);
            tmpTms(i-1,1) = tmp(i-1);
            tmpTms(i-1,2) = tmp(i);
        end
        
        tmpStartEndTms = mean(tmpTms,2)';
        
        for i = 2:length(tmpStartEndTms);
            phiStartEndTms(i-1,1) = tmpStartEndTms(i-1);
            phiStartEndTms(i-1,2) = tmpStartEndTms(i);
        end
        
        phiDurs = phiStartEndTms(:,2) - phiStartEndTms(:,1);
        phiDurs = reshape(phiDurs,4,numel(phiDurs)/4);
        
        phiDurs(abs(phiDurs)>(1/3/4)) = nan; %if any quartile lasts longer than 1/4 of a 3Hz oscillation, it's a nan cuz something's weird
        
        avgDurs = nanmean(phiDurs,2);
        
        fallAndTrough = avgDurs(2) + avgDurs(3);
        peakAndRise = avgDurs(1) + avgDurs(4);
        
        %log transformed ratio of falling(plus trough) to rising (plus peak)
        asymInd(t) = log10(fallAndTrough / peakAndRise);
    end
end

asymInd = nanmean(asymInd); 
