function [cumProp, xScale] = calc_cum_prop_var_range(data)
% function [cumProp, xScale] = calc_cum_prop_var_range(data)
%
% PURPOSE:
%  Function to calculate cumulate proportion plot with a range that is variable
%  and based on the inputted data
%
% NOTES:
%  - X scale ranges from min(data) to max(data) in 1000 steps
%  - Proportion is assessed at each step along the x scale.
%
% INPUT:
%  data = vector of data
%
% OUTPUT:
%  cumProp = vector of cumulative probability y values
%   xScale = vector of x values to line up with cumProp
%
% JB Trimper
% 9/2016
% Colgin Lab


ttlLength = length(data);
xScale = min(data):range(data)/999:max(data);
cumProp = zeros(size(xScale));
for x = 1:length(xScale)
    tmpCut = xScale(x);
    tmpSum = sum(data<=tmpCut);
    cumProp(x) = tmpSum / ttlLength;
end


end %fnctn