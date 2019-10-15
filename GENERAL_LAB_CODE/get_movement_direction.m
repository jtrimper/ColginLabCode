function moveAngs = get_movement_direction(coords)
% function moveAngs = get_movement_direction(coords)
%
% PURPOSE:
%  Function to get rat's direction of heading between each frame.
%
% INPUT:
%    coords = rat's positional data; output of 'read_in_coords'
%
% OUTPUT:
%  moveAngs = vector of length size(coords,1)-1 containing the
%             angle of movement (-pi to pi) between each frame
%                  0 = east
%               pi/2 = north
%             pi/-pi = west
%              -pi/2 = south
%               
% JB Trimper
% 09/2019
% Colgin Lab



%% GET THE DISTANCE TRAVELLED BETWEEN FRAMES IN THE X & Y DIMENSION
startCoords = coords(1:end-1,2:3);
endCoords = coords(2:end,2:3);
distBetFrames = startCoords - endCoords;

%% CONVERT THOSE DISTANCES TRAVELLED (AND THEIR POLARITY) TO ANGLES
%   i.e., go from cartesian to polar coordinates
moveAngs = cart2pol(distBetFrames(:,1), distBetFrames(:,2));


end