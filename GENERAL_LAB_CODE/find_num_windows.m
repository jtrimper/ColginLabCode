function [nWin, winStarts, winEnds] = find_num_windows(dataSize, winSize, winStep)
% function [nWin, winStarts] = find_num_windows(dataSize, winSize, winStep)
%
% PURPOSE:
%    Function to get the window start indices for home-made sliding window analyses
%
% INPUT: 
%    dataSize = size of data to be windowed
%     winSize = size of window in # of samples
%     winStep = size of window step in # of samples
%
% OUTPUT: 
%      nWin = number of windows to be analyzed within the data
% winStarts = indices for the start of each window
%
%
% JB Trimper
% 10/15
% Manns Lab

winStarts = 1 : winStep : dataSize - winSize + 1;
winEnds = winStarts + winSize - 1; 
nWin = length(winStarts); 

