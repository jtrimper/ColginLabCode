function [avgs, inds] = mw_avg(timeSeries, winLength, winStep, interpOrNo)
% function [avgs, inds] = mw_avg(timeSeries, winLength, winStep, interpOrNo)
%
% PURPOSE:
%   To do a moving window average on the inputted time series, ignoring nans.
%
% INPUT:
%   timeSeries = vector of data to be mw avg'ed
%    winLength = window length, in # samples
%      winStep = window step size, in # samples
%   interpOrNo = binary indicating whether(1) or not(0) to interpolate between the averages
%                  default is 1
%
% OUTPUT:
%     avgs = vector of averages for each window
%     inds = vector of indices, corresponding to inputted time-series, for the center of each window
%
% JB Trimper
% 11/2016
% Colgin Lab


%% FIGURE OUT WHETHER OR NOT TO INTERPOLATE MISSING POINTS
if nargin == 3
    interpOrNo = 1;
end

%% GET THE NUMBER OF WINDOWS AND THEIR START INDICES
numSamps = length(timeSeries);
[nWin, winStarts] = find_num_windows(numSamps, winLength, winStep);


%% GET THE AVERAGE INDEX AND VALUE FOR EACH WINDOW
inds = zeros(1,nWin);
avgs = zeros(1,nWin);

for i = 1:nWin
    tmpInds = winStarts(i):winStarts(i)+winLength-1;
    inds(i) = mean(tmpInds);
    avgs(i) = nanmean(timeSeries(tmpInds));
end


%% INTERPOLATE THE MISSING POINTS IF DESIRED, AND REMOVE NANS
if interpOrNo == 1
    avgs = interp1(inds, avgs, 1:numSamps);
    badInds = find(isnan(avgs));
    avgs(badInds) = [];
    inds = 1:numSamps;
    inds(badInds) = [];
end


end%function