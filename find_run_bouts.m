function [edgeTimes, edgeInds, instRs] = find_run_bouts(coords, runCut, minDur)
% function [edgeTimes, edgeInds, instRs] = find_run_bouts(coords, runCut, minDur)
%
% PURPOSE: 
%   To find chunks of time when runspeed is above a certain threshold. 
%
% INPUT: 
%     coords = nx3 matrix containing time-stamps for each frame (:,1), xPos (:,2), and yPos(:,3)
%     runCut = cutoff in cm/s for when the rat is to be considered moving fast enough
%     minDur = minimum duration for each bout, in seconds
%
% OUTPUT: 
%  edgeTimes = mx2 matrix containing the beginning and end times for each run segment lasting at least minDur s
%   edgeInds = ...                                   ... indices ...
%              - indices correspond to rows in coords matrix or instRs matrix
%   instRs = nx2 runspeed for each frame of coords input matrix where... 
%              instRs(:,1) = coords(:,1)
%              instRs(:,2) = speeds in cm/s
%
% JBT 11/2016
% Colgin Lab



winSize = 1/8; %s - time period in which to average runspeed 
minDur = round(minDur/winSize); %minimum # samples which RS must be elevated for

tDif = mean(diff(coords(:,1))); 

instRs = get_runspeed(coords); 

[rsSegs, segStartTimes] = reshape_lfp(instRs, 1/tDif, winSize); 
numSamps = size(rsSegs,2); 
segAvgs = mean(rsSegs,2); 

rsBin = bwconncomp(segAvgs >= runCut, 4); 

cntr = 1; 
for c = 1:length(rsBin.PixelIdxList) 
    tmpInds = rsBin.PixelIdxList{c}; 
    if length(tmpInds) >= minDur
        edgeTimes(cntr,:) = segStartTimes([tmpInds(1) tmpInds(end)+1]); %#ok 
        edgeInds(cntr,:) = [(tmpInds(1)-1)*numSamps+1 (tmpInds(end)-1)*numSamps+1]; %#ok 
        cntr = cntr + 1; 
    end
end%chunks



end%function 