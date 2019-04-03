function evInds = find_lfp_events_in_filtered_ts(lfpData, eegSf, pkThresh, edgeThresh, minDur)
% function evInds = find_lfp_events_in_filtered_ts(lfpData, eegSf, pkThresh, edgeThresh, minDur)
%
% PURPOSE: 
%  To get the edge indices for oscillatory events that meet the criteria specified. 
%
% INPUT: 
%      lfpData = eeg time series (filtered in range of interest)
%        eegSf = eeg sampling frequency (in Hz)
%     pkThresh = event peak detection threshold in standard deviations (suggestion: 2)
%   edgeThresh = event edge detection threshold in standard deviations (suggestion: 1)
%       minDur = minimum duration for an event in seconds; suggestion = 3 x average cycle length
%                 For Slow Gamma (25 - 50 Hz)
%                          Average frequency = 40 Hz
%                     Average cycle duration = 25 ms
%                       Three cycle duration = 75 ms 
%                           suggested minDur = 0.075
%
%                 For Fast Gamma (65 - 100 Hz)
%                          Average frequency = 80 Hz
%                     Average cycle duration = 12.5 ms
%                       Three cycle duration = 37.5 ms 
%                           suggested minDur = 0.0375
%
%
% OUTPUT: 
%      evInds = n x 2 matrix containing the indices for the edges of each event detected
%               evInds(:,1) = start indices
%               evInds(:,2) = peak indices (*max value of the amp envelope, not the filtered LFP*)
%               evInds(:,3) = end indices
% 
%
% JB Trimper
% 11/2016
% Colgin Lab


%% GET THE EEG AMPLITUDE ENVELOPE
%   And find times when the amplitude envelope is above peak threshold
ampEnv = abs(hilbert(lfpData)); 
ampEnv = (ampEnv - nanmean(ampEnv)) ./ nanstd(ampEnv); %z-score, ignoring nans (which come in before/after 1st/last peak)
highAmpInds = find(ampEnv>pkThresh);
neighbors = find(diff(highAmpInds)==1); %get rid of values right next to each other so this doesn't take all day
highAmpInds(neighbors + 1) = [];


%% GET THE EDGES AROUND EACH TIME WHERE THE ENVELOPE EXCEEDS THE PEAK THRESHOLD
highAmpEdges = [];
edgeCntr = 1; 
for i = 1:length(highAmpInds)
    tmpStart = find(ampEnv(1:highAmpInds(i))<=edgeThresh, 1, 'Last');
    tmpEnd = find(ampEnv(highAmpInds(i):end)<=edgeThresh, 1, 'First');
    if ~isempty(tmpStart) && ~isempty(tmpEnd)
        edgeInd(1) = tmpStart;
        edgeInd(2) = tmpEnd + highAmpInds(i) - 1;
        minLength = round(minDur * eegSf);
        if diff(edgeInd) >= minLength
            highAmpEdges(edgeCntr,:) = edgeInd; %#ok
            edgeCntr = edgeCntr + 1;
        end
    end
end


%% ASSIGN OUTPUT
if ~isempty(highAmpEdges)
     highAmpEdges = unique(highAmpEdges, 'rows'); %get rid of 'events' with the same edges
     ctrInds = zeros(size(highAmpEdges,1), 1); 
     for e = 1:size(highAmpEdges,1)
         [~,maxInd] = max(ampEnv(highAmpEdges(e,1):highAmpEdges(e,2))); 
         ctrInds(e) = maxInd + highAmpEdges(e,1) - 1; %re-calibrate to entire LFP rather than just in this window
     end
     evInds = [highAmpEdges(:,1) ctrInds highAmpEdges(:,2)]; 
else
    evInds = [];
end

end%function

