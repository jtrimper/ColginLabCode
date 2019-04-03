function [reshapedLfp, segStartTimes] = reshape_lfp(lfpDataAndTs, lfpSampRate, desWinDuration)
% function [reshapedLfp, segStartTimes] = reshape_lfp(lfpDataAndTs, lfpSampRate, desWinDuration)
%
% PURPOSE:
%  To cut an EEG time series into desWinDuration second segments. Remaining samples will be discarded.
%
% INPUT:
%   lfpDataAndTs = n x 2 matrix where (:,1) = lfp time stamps and (:,2) = vector of amplitude values
%     lfpSampRate = lfp sampling rate, in Hz
%  desWinDuration = desired window duration (segment length) in seconds
%
% OUTPUT:
%     reshapedLfp = matrix where each row is an EEG segment
%   segStartTimes = vector containing start times for each EEG segment
%                     - includes one extra value, which is end time for last window
%
% NOTE:
%   This will work on any time series in which you also have time-stamps as a separate column.
%
% JBT
% 10/2016
% Colgin Lab




numWinSamps = round(desWinDuration *lfpSampRate); %# of samples per segment

numLfpSamps = size(lfpDataAndTs,1); %# of total EEG samples

numWins = floor(numLfpSamps / numWinSamps); %# of segments

if numWins > 0
    
    lastGoodSamp = numWins * numWinSamps; % last good index before discarding remainder
    
    lfpDataAndTs(lastGoodSamp+1:end,:) = []; %discard remainder
    
    for i = 1:numWins
        startInd = (i-1)*numWinSamps + 1;
        endInd = i*numWinSamps;
        segStartTimes(i) = lfpDataAndTs(startInd,1); %#ok
        reshapedLfp(i,:) = lfpDataAndTs(startInd:endInd,2);%#ok
    end
    
    segStartTimes(i+1) = segStartTimes(i) + numWinSamps/lfpSampRate;

else

    reshapedLfp = [];
    segStartTimes = [];
end



end %function