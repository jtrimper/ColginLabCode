function asymInds = calc_theta_asym_ind(phiDurs)
% function asymInds = calc_theta_asym_ind(phiDurs)
%
% PURPOSE:
%  To calculate the theta asymmetry index, a la Belluscio et al., 2012
%  - duration of ascending phase over duration of descending phase, logarhythmically expressed
%  - ascending and descending phases are defined as in Belluscio et al, dividing theta in to quartiles
%
% INPUT:
%   phiDurs = 4 x n matrix of center times for each theta phase
%            - output of get_theta_phase
%            - has one less column than phiTms because center of rising phase from first column
%              is needed to calculate duration of first peak phase
%
% OUTPUT:
%   asymInds = 1 x n-1 vector containing the theta asymmetry index for each theta cycle
%              - dimension two has one less value than phiDurs (which is one less than phiTms)
%                because ascending phase for the first available cycle is calculated from duration
%                of rising phase in column 1 and duration of falling phase in column 2
%
% JB Trimper
% 04/2019
% Colgin Lab



phiDurs([1 3],:) = []; %get rid of peak and trough durations. We don't need them.

%calc asym index
asymInds = log10(phiDurs(2,1:end-1)./phiDurs(1,2:end));
%         log10 (duration of rising phase / duration of falling phase)
%         - ordered 'arbitarily' so that rising phase comes before falling phase


end %fnctn