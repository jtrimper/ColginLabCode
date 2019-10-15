function thetaPhiVctr = get_asym_theta_phi_vector(lfpStruct)
%function thetaPhiVctr = get_asym_theta_phi_vector(lfpStruct)
%
% PURPOSE:
%   Get a time-series vector indicating the phase at each time point.
%   Uses asym theta phase, rather than just angle(hilbert(time_series));
%
% INPUT:
%       lfpStruct = lfp structure outputted by read_in_lfp with additional fields...
%                 narrowThetaLfp: time series for narrowly filtered theta Lfp (e.g., 6-12 Hz)
%                  broadThetaLfp: time series for wide filtered theta Lfp (e.g., 2-20 Hz)
%
% OUTPUT:
%      thetaPhiVctr = vector time-series of theta phases (pi & -pi = trough, 0 = peak)
%
% NOTE:
%    You need the ouput from this if you want to assess theta/gamma phase-phase coupling.
%
% JBT 11/2016
% Colgin Lab


phaseTimes = get_theta_phase_times(lfpStruct); %get theta quartile times using Belluscio method
queryPts = lfpStruct.ts; %set up to interpolate between quartile times
knownPts = reshape(phaseTimes, 1, numel(phaseTimes));
knownVals = repmat([1 0 -1 0], 1, size(phaseTimes,2)); %interpolate the time series between -1 & 1 for convenience

fullThetaPhiTimesVctr = interp1(knownPts, knownVals, queryPts); %do interpolation

firstGoodInd = find(~isnan(fullThetaPhiTimesVctr),1, 'First'); %it's gonna skip before the first theta quartile
%                                                               can be accurate calculated
%                                                               so identify those points
lastGoodInd = find(~isnan(fullThetaPhiTimesVctr),1, 'Last');
goodInds = firstGoodInd:lastGoodInd;

thetaPhiVctr = angle(hilbert(fullThetaPhiTimesVctr(goodInds))); %do the hilbert transform on your interpolated time series
narrowThetaLfp = angle(hilbert(lfpStruct.narrowThetaLfp)); %use the phase of the narrow filtered LFP for the NaNs
thetaPhiVctr = [narrowThetaLfp(1:firstGoodInd-1); thetaPhiVctr; narrowThetaLfp(lastGoodInd+1:length(fullThetaPhiTimesVctr))];

end %function