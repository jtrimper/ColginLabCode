function custColMap = define_cust_color_map(color1, color2, numRows)
% function custColMap = define_cust_color_map(color1, color2, numRows)
%
% PURPOSE:
%  To define a custom colormap that goes from color 1 to color 2 with (optionally)
%  numRows different colors within it.
%
% INPUT:
%   color1 = string from rgb chart indicating which color to start with in the colormap
%   color2 = string from rgb chart indicating which color to end with in the colormap
%   numRows = optional input indicating how many rows to include in the colormap matrix
%             if numRows is not provided, default is 64
%
% OUTPUT: 
%  cusColMap = numRows x 3 matrix with rgb triplet in each row
% 
% NOTES:
%  - Option at top of function to plot example figure showing coors.
%  - Calls function 'rgb' downloaded from Malab central.
%
% JBT 10/2016
% Colgin Lab

plotPudding = 0; %set to 1 to plot figure showing the color scheme 
%                   cuz the proof is in the pudding


if nargin == 2
    numRows = 64;
end


colTrip1 = rgb(color1);
colTrip2 = rgb(color2);

custColMap = zeros(numRows, 3);
for c = 1:3
    if colTrip1(c) ~= colTrip2(c)
        custColMap(:,c) = colTrip1(c): (colTrip2(c) - colTrip1(c)) / (numRows-1) :colTrip2(c);
    else
        custColMap(:,c) = repmat(colTrip1(c), numRows, 1); 
    end
end


if plotPudding == 1
    figure;
    for i = 1:numRows
        ln = line([1 10], repmat(i,1,2));
        set(ln, 'Color', custColMap(i,:), 'LineWidth', 5)
    end
end

end%function
