function custColMap = define_cust_color_map2(color1, color2, color3, numRows)
% function custColMap = define_cust_color_map2(color1, color2, color3, numRows)
%
% PURPOSE:
%  To define a custom colormap that goes from color 1 to color 2 with (optionally)
%  numRows different colors within it.
%  **Same as define_cust_color_map, but this one allows for three colors**
%
% INPUT:
%   color1 = string from rgb chart indicating which color to start with in the colormap
%   color2 = string from rgb chart indicating which color to end with in the colormap
%   color3 = string from rgb chart indicating which color to end with in the colormap
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
% JB Trimper
% 11/2016
% Colgin Lab


plotPudding = 0; %set to 1 to plot figure showing the color scheme
%                   cuz the proof is in the pudding


if nargin == 2
    numRows = 64;
end

if numRows == 3
    custColMap = [rgb(color1); rgb(color2); rgb(color3)];
    return
end


colTrip1 = rgb(color1);
colTrip2 = rgb(color2);
colTrip3 = rgb(color3);


firstHalfRows = round(numRows/2);
colMap1 = zeros(firstHalfRows, 3);
for c = 1:3
    if colTrip1(c) ~= colTrip2(c)
        colMap1(:,c) = colTrip1(c): (colTrip2(c) - colTrip1(c)) / (firstHalfRows-1) :colTrip2(c);
    else
        colMap1(:,c) = repmat(colTrip1(c), firstHalfRows, 1);
    end
end

nextHalfRows = numRows - firstHalfRows;
colMap2 = zeros(nextHalfRows, 3);
for c = 1:3
    if colTrip2(c) ~= colTrip3(c)
        colMap2(:,c) = colTrip2(c): (colTrip3(c) - colTrip2(c)) / (nextHalfRows-1) :colTrip3(c);
    else
        colMap2(:,c) = repmat(colTrip2(c), nextHalfRows, 1);
    end
end

custColMap = [colMap1; colMap2];


if plotPudding == 1
    figure;
    for i = 1:numRows
        ln = line([1 10], repmat(i,1,2));
        set(ln, 'Color', custColMap(i,:), 'LineWidth', 5)
    end
end

end%function
