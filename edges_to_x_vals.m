function xVals = edges_to_x_vals(edges)
% function xVals = edges_to_x_vals(edges)
%
% PURPOSE: 
%  'histcounts' outputs edges which are the edges for each bar in the histogram. 
%   When I want to make a bargraph, though, I need the center value for the bin, not the edges. 
%   This just does the quick math that's needed cuz I'm sick of typing that line every time. 
%
% JB Trimper
% 1/2018
% Colgin Lab


xVals = edges(2:end) - (mean(diff(edges))/2); 

end
