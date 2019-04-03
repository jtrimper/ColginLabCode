function [cumProp, xScale] = calc_cum_prop_ip_range(data, ipRange)
% function [cumProp, xScale] = calc_cum_prop_ip_range(data, ipRange)
%
% PURPOSE:
%  Function to calculate cumulate proportion plot with an inputted range.
%
%  X scale ranges from min(ipRange) to max(ipRange) in 1000 steps
%  Proportion is assessed at each step along the x scale.
%
% INPUT:
%     data = vector of data
%  ipRange = 1x2 vector giving min and max for range
%
% OUTPUT:
%  cumProp = vector of cumulative probability y values
%   xScale = vector of x values to line up with cumProp
%
% JB Trimper
% 12/2018
% Colgin Lab


ttlLength = length(data);
xScale = ipRange(1):diff(ipRange)/999:ipRange(2);
cumProp = zeros(size(xScale));
for x = 1:length(xScale)
    tmpCut = xScale(x);
    tmpSum = sum(data<=tmpCut);
    cumProp(x) = tmpSum / ttlLength;
end


end %fnctn