function [radPos, coords] = read_in_circtrack_coords(coordFileName)
% function [radPos, coords] = read_in_circtrack_coords(coordFileName)
%
% PURPOSE:
%  To get the radial position of the rat on the circle track as well as
%  the rat's x and y positions in cm
%
% INPUT:
%   coordFileName = string; name of behavior file (i.e., 'VT1.nvt')
%
% OUTPUT:
%   radPos = radial position of the rat on the circle track, in degrees
%            nx2 where (:,1) = time-stamps for each frame and (:,2)
%            is the radial position of the rat
%  coords = nx3 matrix where (:,1) = time-stamps for each frame, (:,2)
%           = x position of the rat, and (:,3) = y position of the rat
%
% JB Trimper
%   From Ernie Hwaun's code
% 10/19
% Colgin Lab



[post,posx,posy] = LoadCircPos(coordFileName);
radPos = circpos(posx,posy); %radial position
radPos = [post' radPos'];

coords = zeros(length(post), 3);
coords(:,1) = post;
coords(:,2) = posx;
coords(:,3) = posy;

end