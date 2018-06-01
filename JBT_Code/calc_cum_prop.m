function [cumProp, xScale] = calc_cum_prop(data)
% function calc_cum_prop(data) 
%
% Function to calculate cumulate proportion plot as was done by Olafsdottir et al., 2016
% 
% X scale ranges from 0.01 to 1 in intervals of 0.01
% Proportion is assessed at each step along the x scale. 
%
% IP: 
%  data = vector of data
%
% OP: 
%  cumProp = vector of cumulative probability y values
%   xScale = vector of x values to line up with cumProp
%
% JBT 9/2016


ttlLength = length(data); 
xScale = 0.01: 0.01 :1;
cumProp = zeros(size(xScale)); 
for x = 1:length(xScale)
    tmpCut = xScale(x); 
    tmpSum = sum(data<=tmpCut); 
    cumProp(x) = tmpSum / ttlLength; 
end