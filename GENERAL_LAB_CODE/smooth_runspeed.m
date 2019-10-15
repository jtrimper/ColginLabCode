function smRs = smooth_runspeed(instRs, gWinDur, gWinStd)
% function smRs = smooth_runspeed(instRs)
%
% PURPOSE:
%  To apply Gaussian smoothing to the runspeed time-series.
%
% INPUT:
%   instRs = runspeed matrix as outputted by get_runspeed
%  gWinDur = Gaussian window size in seconds
%            - If absent or empty, default is 250 ms
%  gWinStd = Gaussian window standard deviation in seconds
%            - If absent or empty, default is 83 ms (250/6)
%
% OUTPUT:
%    smRs = runspeed matrix, same size as input, but with the
%           speed column (:,2) now convolved with a Gaussian kernel
%
% JB Trimper
% 09/2019
% Colgin Lab



if nargin == 1 || isempty(gWinDur)
    gWinDur = 250;
end

if nargin < 3 || isempty(gWinStd)
    gWinStd = 83.333333;
end

%Make the output matrix and copy the time-stamps
smRs = zeros(size(instRs));
smRs(:,1) = instRs(:,1);

%convert window duration to # of samples based on 30 Hz frame rate
gWinDur = gWinDur/1000;
halfGWinDur = gWinDur/2;
gWinDur = 30*halfGWinDur;

%convert window std to # of samples
gWinStd = 30*(gWinStd/1000);


%Make the kernel and convolve it with the instantaneous runspeed
gKrnl = gausskernel(gWinDur, gWinStd);
smRs(:,2) = conv(instRs(:,2),gKrnl,'same');


end



