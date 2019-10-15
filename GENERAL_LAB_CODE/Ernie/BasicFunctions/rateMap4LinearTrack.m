% posx          x-coordinate for all the position samples in the recording
% spkx          x-coordinate for all the spikes for a specific cell in the recording
% xBinWidth     Bin width for the bins in map in the x-direction [cm]
% xLength       Length of the arena in the x-direction [cm](for cylinder this equals the diameter)
% sampleTime    Sample duarion. For Axona it is 0.02 sec, for NeuraLynx it is 0.04 sec
%
% Version 1.0   
% 13. Dec 2007
%
% (c) Raymond Skjerpeng, Centre for the Biology of Memory, NTNU, 2007.
function [map, rawmap, xAxis,timeMap] = rateMap4LinearTrack(posx,spkx,xBinWidth,xStart,xLength,sampleTime)

	% Number of bins in each direction of the map
	numBinsX = ceil(xLength/xBinWidth);

	% Allocate memory for the maps
	spikeMap = zeros(1,numBinsX);
	timeMap = zeros(1,numBinsX);

	xAxis = zeros(numBinsX,1);

	startPosX = xStart;
	stopPosX = startPosX + xBinWidth;

	for ii = 1:numBinsX
		
		% Find spikes and position samples that falls within the current bin in
		% the x-direction
		binSpkx = find(spkx>=startPosX & spkx<stopPosX);
		binTimex = find(posx>=startPosX & posx<stopPosX);
			
        % Add the number of spikes in the current bin
        spikeMap(1,ii) = length(binSpkx);
        % Add the number of position samples in the current bin
        timeMap(1,ii) = length(binTimex);
		
		% Increment the x-coordinate for the position
		startPosX = startPosX + xBinWidth;
		stopPosX = stopPosX + xBinWidth;
	end

	% Transform the number of spikes to time
	timeMap = timeMap * sampleTime;

	rawmap = spikeMap; % ./ timeMap;
	%rawmap(timeMap<0.20) = NaN;
	
	% Smooth the spike and time map
	kernel = gausskernel(2,1);
    spikeMap = (conv(spikeMap,kernel,'same'))';
	timeMap = (conv(timeMap,kernel,'same'))';

	% Calculate the smoothed rate map
	map = spikeMap ./ timeMap;
    
	% Set bins that are visited less than 100 ms to NaN
	map(timeMap<0.150) = NaN;

	% Set the axis
	start = xStart + xBinWidth/2;
	for ii = 1:numBinsX
		xAxis(ii) = start + (ii-1) * xBinWidth;
    end


