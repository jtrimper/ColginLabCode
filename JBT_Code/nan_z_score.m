function zData = nan_z_score(data)
% function zData = nan_z_score(data)
% 
% PURPOSE: 
%  Z-scores the inputted time-series, ignoring nans
%
% INPUT: 
%  data = vector to be z-scored
%
% OUTPUT: 
% zData = z-scored vector
%        NaNs in original are replicated in same location for output vector
%
% JB Trimper
% 11/2016
% Colgin Lab



AVG = nanmean(data); 
STD = nanstd(data); 

zData = (data - AVG) / STD; 