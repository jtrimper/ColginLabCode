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
%   phiDurs = the durations of each theta phase, WITH THE FIRST COLUMN OF THE INPUT MATRIX CUT OFF!!
%           = 4 x M-1
%
% JB Trimper
% 12/2016
% Colgin Lab


%% FIND PHASE START TIMES FROM PHASE MID TIMES
tmpPhiVctr = reshape(phiTms, 1, numel(phiTms));%reshape phiTms to be a vector
reshPhiMidTms(:,1) = tmpPhiVctr(1:end-1);
reshPhiMidTms(:,2) = tmpPhiVctr(2:end);
phiStartTms = mean(reshPhiMidTms,2);

%% FIND THE DIFFERENCE IN TIME BETWEEN EACH START TIME
phiDurs = diff(phiStartTms);
phiDurs(1:2) = []; %drop the first two which are the falling and trough durations
phiDurs = reshape(phiDurs, 4, size(phiTms,2)-1); 


%% ALSO OUTPUT THE PHASE START TIMES
phiStartTms(1:3) = []; 
phiStartTms = reshape(phiStartTms,4,size(phiTms,2)-1); 

end