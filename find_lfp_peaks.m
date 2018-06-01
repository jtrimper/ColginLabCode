function pkInds = find_lfp_peaks(lfpData)
% function pkInds = find_lfp_peaks(lfpData)
%
% PURPOSE: 
%  Function returns the indices for each peak in the inputted time series
%
% INPUT: 
%   lfpData = time series; 
%             should be filtered in reasonably narrow range for this to do anything useful
%
% OUTPUT: 
%      pkInds = indices for where each peak occurred
%
% NOTES: 
%   Modified from Joe Manns's function 'find_troughs2'
%
% JB Trimper
% 10/2016
% Colgin Lab


pkInds = find(diff(sign(diff([0; lfpData; 0])))<0); 
pkInds(diff(pkInds)==1) = []; 

end

