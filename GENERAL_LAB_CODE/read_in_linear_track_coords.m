function coords = read_in_linear_track_coords(coordFileName)
% function coords = read_in_linear_track_coords(coordFileName); 
%
% PURPOSE: 
%   To read in rat's coordinate data from a linear track session. This function, versus read_in_coords, 
%   assumes that the track is 198 x 10 and angled from one corner of the video to the opposite corner. 
%
% INPUT: 
%   coordFileName = string containing the name of the .nvt file to be read in
%
% 
% OUTPUT: 
%    coords = n x 3 vector where col 1 equals frametimes, column 2 is x coords, and column 3 is y coords
%
%
% JBT 
% 09/2016
% Colgin Lab



trckLngth = 198; %cm -- known length of the track the rats are running on


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



%% READ IN THE COORDINATE DATA

[t2, x, y] = Nlx2MatVT(coordFileName,fieldSelection,extractHeader,extractMode); %read in position file

t = t2*10^-6; %convert time to seconds 

xx= x((y>0==x>0)==0 & ~isnan(x)); %get rid of missing values (to be interpolated later)
yy= y((y>0==x>0)==0 & ~isnan(x));
tt = t((y>0==x>0)==0 & ~isnan(x));

[rx, ry] = axesRotate(xx,yy); %the linear track goes from a top corner to a bottom corner of the screen, 
%                              so rotate it to be left and right rather than diagonal

scale = trckLngth/(max(rx)-min(rx)); %get scaling factor: 
%                                     size of arena / range of pixels (assumes rat went to the furthest x & y coords possible)

sx = rx*scale; %convert from pixel to cm
sy = ry*scale;

sx = sx-min(sx); %get the lowest coords val to zero so the scaling will work right
sy = sy-min(sy);

xPos=interp1(tt,sx,t,'linear');%Fill in the gaps that the camera missed by linear interpolation
yPos=interp1(tt,sy,t,'linear');


% Moving window mean filter across 14(16?) time bins
for cc = 8:length(xPos)-7
    xPos(cc) = nanmean(xPos(cc-7:cc+7));
    yPos(cc) = nanmean(yPos(cc-7:cc+7));
end
          


%% ASSIGN OUTPUT STRUCTURE
coords(:,1) = t; 
coords(:,2) = xPos; 
coords(:,3) = yPos; 


