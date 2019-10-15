function smoothRatemap = smooth_circtrack_ratemap(rateMap, rmBinSz, gWinSz, gWinStd)
% function smoothRatemap = smooth_circtrack_ratemap(rateMap, gWinDur, gWinStd)
%
% PURPOSE:
%  To smooth the circle track ratemap vector.
%
% INPUT:
%    rateMap = 1xn ratemap vector
%              - Output of 'get_ratemap_circtrack'
%    rmBinSz = size of ratemap bin employed, in degrees
%     gWinSz = size of gaussian smoothing window, in degrees
%              - If not provided, default is 30 degrees
%     gWinStd = standard deviation of gaussian smoothing window
%              - If not provided, default is gWinSz/2
%
% OUTPUT:
%   smoothRatemap = 1xn vector of gaussian smoothed ratemap
%
% JB Trimper
% 10/2019
% Colgin Lab



if nargin == 2 || isempty(gWinSz)
    gWinSz = 30; %degrees
    %            ... which is equivalent to Bieri et al. (2014)'s 25 cm smoothing
    %                based on 100 cm diameter of track (and circumference of ~314)
end

if nargin < 4 || isempty(gWinStd)
    gWinStd = gWinSz/2; %degrees
end

%concatenate the ratemap to be 3x the length of the original so smoothing
% will extend around the circle rather than stop at the ends
origLen = length(rateMap);
rateMap = [rateMap rateMap rateMap];

%convert window size to # of bins based on rmBinSz
gWinSz = gWinSz/rmBinSz/2;


%convert window std to # of samples
gWinStd = gWinStd/rmBinSz;


%Make the kernel and convolve it with the instantaneous runspeed
gKrnl = gausskernel(gWinSz, gWinStd);
smoothRatemap = conv(rateMap,gKrnl,'same');
smoothRatemap = smoothRatemap(origLen+1:origLen+origLen);

end



