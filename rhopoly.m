function polyCoords = rhopoly(rho)
%function polyCoords = rhopoly(rho)
%
% SUMMARY:
%   Returns coordinates for a polygon from vector/matrix rho. Polygon will be 'centered' around zero, 
%   like a circular histogram. 
%
% INPUT:
%   rho = n x m matrix of rho values, with n being the number of points (or bins) and where m is the 
%         number of different sets of rho values to generate polygon coordinates for. 
%
% OUTPUT: 
%   polyCoords = n x 2 x m matrix where the column vector is the x (:,1,:) and y (:,2,:) coordinate 
%                vectors for each polygon. 
%
% NOTES:
%   To go from circular histogram output of 'rose' (i.e., outputRho) to having input formatted for
%   this function, you need to take every fourth member of outputRho because outputRho is organized
%   for plotting polygons from zero to each nth rho, and therefore length of outputRho is 4 x #bins.
%   In other words, use this line to convert...
%       inputRho = rho(2:4:end);
%
%
% EXAMPLE: 
%    randVctr = rand(20,1); %generate vector of 20 random integers between 1 & 20
%    [theta,rho] = rose(randVctr); 
%    inputRho = rho(2:4:end)'; 
%    polyCoords = rhopoly(inputRho)
%    figure
%    fill(polyCoords(:,1), polyCoords(:,2), 'red');

%
% JBT 8/15
% Manns Lab

nBins = size(rho,1); %number of bins/angles/points
numP = size(rho,2);%number of polygons desired
angs = 0:(2/nBins)*pi :2*pi; %vector of corresponding angles, with same number of points

for i = 1:numP
    for j = 1:nBins;
            polyCoords(j,1,i) = rho(j,i) * sin(0.5*pi - angs(j)) / sin(0.5*pi); %use law of sines to figure out the x coordinate
            polyCoords(j,2,i) = rho(j,i) * sin(angs(j)) / sin(0.5*pi); %...and the y coordinate
    end%for each bin/angle/point
end%for each rho column/desired polygon


end%function