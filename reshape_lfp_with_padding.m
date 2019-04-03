function reshapedlfp = reshape_lfp_with_padding(lfpData, desWinLength, numOvlpSamps)
% function reshapedlfp = reshape_lfp_with_padding(lfpData,  desWinLength, numOvlpSamps)
%
% PURPOSE: 
%  To cut an lfp time series into segments of desWinDuration + (numOvlpSamps/lfpSamprate) seconds on each side. 
%  The reason for the padding is so that we can have long enough sweeps for running Adriano Tort's comodulation 
%  routine, which needs sweeps that are 3*filterOrder in length. 
%
% INPUT: 
%    lfpDataAndTs = 1xn vector of amplitude values
%                   NOTE: Make sure lfpDataAndTs extends numOvlpSamps extra in each direction
%     lfpSampRate = lfp sampling rate, in Hz
%    desWinLength = desired window duration (segment length) in # samples
%    numOvlpSamps = # of samples that will overlap between each row
%
% OUTPUT: 
%     reshapedlfp = matrix where each row is an lfp segment
%   segStartTimes = vector containing start times for each lfp segment
%                     - includes one extra value, which is end time for last window
%
% NOTE: 
%   To lop off the extra samples...
%      reshapedlfp(:,1:numOvlpSamps) = []; 
%      reshapedlfp(:,numOvlpSamps+1:end) = []; 
%
%
% JBT 10/2016
% Colgin Lab

% numKeepSamps = round(desWinDuration)/lfpSampRate; 

cntr = 1; 
startInd = 1; 
endInd = (2*numOvlpSamps) + desWinLength + 1; 
while endInd < length(lfpData); 
   reshapedlfp(cntr,:) =  lfpData(startInd:endInd); %#ok 
   startEndInds(cntr,:) = [startInd endInd]; %#ok 
   startInd = endInd - numOvlpSamps + 1; 
   endInd = startInd + (2*numOvlpSamps) + desWinLength; 
   cntr = cntr + 1; 
end


end%function