function [phiDurs, phiStartTms] = phiTms_to_phiDurs(phiTms)
% function phiDurs = phiTms_to_phiDurs(phiTms)
%
% PURPOSE:
%   Find the duration of each theta phase (P,F,T,R) given the phase center times,
%   which are the output of get_theta_phase_times
%
% INPUT:
%   phiTms = 4xM matrix containing the time stamp for the middle of each phase
%
% OUTPUT:
%        phiDurs = the durations of each theta phase, WITH THE FIRST AND LAST COLUMN CUT OFF
%                           - removed cuz you can't find the duration of the first peak without the
%                             rise center time before it, and you can't find the duration of the last
%                             rise without the peak center time after the rise
%                = 4 x M-2
%                = (1,:) = peak durations; (2,:) = falling; (3,:) = trough; (4,:) = rising
%    phiStartTms = start times for each phase 
%                = 4 x M-1
%                   *M-1 instead of M-2 because you can still calculate start tm, just not duration, for last rise
%
% JB Trimper
% 12/2016
% Colgin Lab


%% FIND PHASE START TIMES FROM PHASE MID TIMES
tmpPhiVctr = reshape(phiTms, 1, numel(phiTms));%reshape phiTms to be a vector
reshPhiMidTms(:,1) = tmpPhiVctr(1:end-1);
reshPhiMidTms(:,2) = tmpPhiVctr(2:end);
phiStartTms = mean(reshPhiMidTms,2); %first start time here corresponds to start of falling phase in column 1


%% FIND THE DIFFERENCE IN TIME BETWEEN EACH START TIME
phiDurs = diff(phiStartTms);
phiDurs(1:3) = []; %drop the first three which are falling, trough, and rising durations
phiDurs(end-2:end) = []; %drop the last three which are peak, falling, and trough durations
phiDurs = reshape(phiDurs, 4, size(phiTms,2)-2);

%% ALSO OUTPUT THE PHASE START TIMES
phiStartTms(1:3) = []; %cut off the first 3 (duration of falling, trough, and rising)
phiStartTms = reshape(phiStartTms,4,size(phiTms,2)-1);


end