function [coords, xScale, yScale, pixCoords] = read_in_coords(coordFileName, X_arenaSize, Y_arenaSize)
% function [coords, xScale, yScale, pixCoords] = read_in_coords(coordFileName, X_arenaSize, Y_arenaSize)
%
% PURPOSE:
%   To read in rat's coordinate data from a session.
%
% INPUT:
%   coordFileName = string containing the name of the .nvt file to be read in
%     X_arenaSize = size of track or arena in centimeters in the x dimension
%                   - For big square (open field), 100cm
%     Y_arenaSize = size of track or arena in centimeters in the y dimension
%                   - For big square, 100cm
%
% OUTPUT:
%      coords = n x 3 matrix where col 1 equals frametimes, column 2 is x coords, and column 3 is y coords
%      xScale = scalar for ratio of inputted X_arenaSize over max X distance covered
%               xScale can be multiplied by rawXCoords (or subsequently read in coords where arena size is unknown)
%               to convert to cm
%      yScale = same as xScale but for the y dimension
%   pixCoords = n x 3 matrix, same as 'coords,' but these values are in pixel space (not converted to cm)
%
% JB Trimper
% 09/2016
% Colgin Lab


%% THESE ARE PARAMETERS REQUIRED FOR USING THE FUNCTION THAT READS IN THE RATS' POSITION DATA

%position extraction variables
fieldSelection(1) = 1; % Timestamps
fieldSelection(2) = 1; % Extracted X
fieldSelection(3) = 1; % Extracted Y
fieldSelection(4) = 0; % Extracted Angel
fieldSelection(5) = 0;  % Targets
fieldSelection(6) = 0; % Points
extractHeader = 0;% Do we return header 1 = Yes, 0 = No.
extractMode = 1; % Extract all data -- 5 different extraction modes, see help file for Nlx2MatVT


% Read in the coordinate data
[t2, x, y] = Nlx2MatVT(coordFileName,fieldSelection,extractHeader,extractMode); %read in position file
t = t2*10^-6; %convert time to seconds

xx= x((y>0==x>0)==0 & ~isnan(x)); %get rid of missing values (to be interpolated later)
yy= y((y>0==x>0)==0 & ~isnan(x));
tt = t((y>0==x>0)==0 & ~isnan(x));

%Fill in the gaps that the camera missed by linear interpolation
xPos=interp1(tt,xx,t,'linear');
yPos=interp1(tt,yy,t,'linear');

% Moving window mean filter
for cc = 8:length(xPos)-7
    xPos(cc) = nanmean(xPos(cc-7:cc+7));
    yPos(cc) = nanmean(yPos(cc-7:cc+7));
end

% Get the minimum to zero
xPos = xPos - min(xPos);
yPos = yPos - min(yPos);

% ASSIGN RAW COORDS OUTPUT STRUCTURE
pixCoords(:,1) = t;
pixCoords(:,2) = xPos;
pixCoords(:,3) = yPos;

% Convert from pixel to cm
xScale = X_arenaSize/(max(xPos)-min(xPos)); %x dimension
xPos = xPos*xScale;
yScale = Y_arenaSize/(max(yPos)-min(yPos)); %y dimension
yPos = yPos*yScale;


%% ASSIGN COORDS OUTPUT MATRIX
coords(:,1) = t;
coords(:,2) = xPos;
coords(:,3) = yPos;
