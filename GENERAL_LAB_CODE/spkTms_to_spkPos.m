function spkPos = spkTms_to_spkPos(spkTms, posMat)
% function spkPos = spkTms_to_spkPos(spkTms, posMat)
%
% PURPOSE:
%  Function to get the position of rat when each spike occurred from the
%  vector of spike-times and the matrix of position data (radial position
%  or x/y position). See NOTE below.
%
% INPUT:
%    spkTms = nx1 vector of spike-times in seconds.
%             - Output of 'Readtfile' converted to seconds
%    posMat = either 'coords' (mx3; x and y position for each frame-time) or
%             'radPos' (nx2; radial position for each frame-time)
%             - See documentation in 'read_in_circtrack_coords' for clarification
%
%    NOTE: If size(posMat) == nx2, function assumes you're inputting radial position data
%                                  and will therefore output the radial position
%          If size(posMat) == nx3, function assumes you're inputting x & y position data
%                                  and will therefore output the x & y position
%
%
% OUTPUT:
%   spkPos = nx1 vector of radial positions or nx2 matrix of x and y positions where
%            n is the number of spike times inputted.
%
% JB Trimper
% 10/2019
% Colgin Lab



% Is the input radial position or x/y coordinates?
ipSz = size(posMat);
if ipSz(2) == 2 %radial position
    spkPos = zeros(length(spkTms),1);
else %x/y
    spkPos = zeros(length(spkTms),2);
end



for st = 1:length(spkTms)
    frameInd = find(posMat(:,1)<=spkTms(st), 1, 'Last');
    spkPos(st,:) = posMat(frameInd,2:end);
end


end %fnctn
