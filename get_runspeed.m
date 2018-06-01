function instRunSpd = get_runspeed(coords)
% function instRunSpd = get_runspeed(coords)
%
% PURPOSE:
%   To calculate the run speed in cm/s from the cartesian coordinates.
%
% INPUT:
%     coords = n x 3 matrix where column 1 equals time stamps for each frame,
%              column 2 equals x coords (cm), and column 3 equals y coords (cm)
%
% OUTPUT:
%   instRunSpd = n x 2 matrix where column 1 is frametimes and column 2 is instantaneous run speed for each frame
%
%
% JB Trimper
% 10/16
% Colgin Lab


tBetFrames = mean(diff(coords(:,1))); %find the average time between frames
frameRate = 1/tBetFrames;


% find distance rat travelled between each frame
xDiff = diff(coords(:,2)); %difference in x coords between each frame and the frame 'frameOffset' beyond it
yDiff = diff(coords(:,3)); %..............y.................................................

%use pythagorean theorem to find euclidean distance between rats cartesian coords at each frame
tmpRunSpds = hypot(xDiff, yDiff); %speed in cm/frame
tmpRunSpds = tmpRunSpds .* frameRate; %convert to cm/s

instRunSpd(:,2) = [tmpRunSpds(1); tmpRunSpds]; %since run speed is the difference between frames, there is one less value here than there are for coords.
%                               To make things easy on ourselves, we'll assume the rat is moving the same speed from frame 0-1 as he is from 1-2.

instRunSpd(:,1) = coords(:,1);