%__________________________________________________________________________
%
%                       Rate Map functions
%__________________________________________________________________________



% Calculates a 2 dimensional rate map. The map is smoothed with a Gaussian
% smoothing kernel implemented with a boxcar lowpass filter, that effectively
% approximates a Gaussian filter.
%
% posx          x-coordinate for all the position samples in the recording
% posy          y-coordinate for all the position samples in the recording
% spkx          x-coordinate for all the spikes for a specific cell in the recording
% spky          y-coordinate for all the spikes for a specific cell in the recording
% xBinWidth     Bin width for the bins in map in the x-direction [cm]
% yBinWidth     Bin width for the bins in map in the Y-direction [cm] (Usually the same as the x bin width)
% xLength       Length of the arena in the x-direction [cm](for cylinder this equals the diameter)
% yLength       Length of the arena in the y-direction [cm] (for cylinder this equals the diameter)
% sampleTime    Sample duarion. For Axona it is 0.02 sec, for NeuraLynx it is 0.04 sec
%
% Version 1.0   
% 13. Dec 2007
%
% (c) Raymond Skjerpeng, Centre for the Biology of Memory, NTNU, 2007.
function [map, rawmap, xAxis, yAxis] = rateMap(posx,posy,spkx,spky,xBinWidth,yBinWidth,xStart,xLength,yStart,yLength,sampleTime)

	% Number of bins in each direction of the map
	numBinsX = ceil(xLength/xBinWidth);
	numBinsY = ceil(yLength/yBinWidth);

	% Allocate memory for the maps
	spikeMap = zeros(numBinsY,numBinsX);
	timeMap = zeros(numBinsY,numBinsX);

	xAxis = zeros(numBinsX,1);
	yAxis = zeros(numBinsY,1);

	startPosX = xStart;
	stopPosX = startPosX + xBinWidth;

	for ii = 1:numBinsX
		
		% Find spikes and position samples that falls within the current bin in
		% the x-direction
		binSpkx = find(spkx>=startPosX & spkx<stopPosX);
		binTimex = find(posx>=startPosX & posx<stopPosX);
		
		startPosY = yStart;
		stopPosY = startPosY + yBinWidth;
		
		for jj = 1:numBinsY
			% Find spikes and position samples that falls within the current
			% bin
			binSpky = find(spky(binSpkx)>=startPosY & spky(binSpkx)<stopPosY);
			binTimey = find(posy(binTimex)>=startPosY & posy(binTimex)<stopPosY);
			
			% Add the number of spikes in the current bin
			spikeMap(numBinsY-jj+1,ii) = length(binSpky);
			% Add the number of position samples in the current bin
			timeMap(numBinsY-jj+1,ii) = length(binTimey);
			
			% Increment the y-coordinate for the position
			startPosY = startPosY + yBinWidth;
			stopPosY = stopPosY + yBinWidth;
		end
		
		% Increment the x-coordinate for the position
		startPosX = startPosX + xBinWidth;
		stopPosX = stopPosX + xBinWidth;
	end

	% Transform the number of spikes to time
	timeMap = timeMap * sampleTime;

	rawmap = spikeMap; % ./ timeMap;
	%rawmap(timeMap<0.20) = NaN;
	
	% Smooth the spike and time map
	spikeMap = boxcarSmoothing(spikeMap);
	timeMap = boxcarSmoothing(timeMap);

	% Calculate the smoothed rate map
	map = spikeMap ./ timeMap;

	% Set bins that are visited less than 100 ms to NaN
	map(timeMap<0.150) = NaN;

	% Set the axis
	start = xStart + xBinWidth/2;
	for ii = 1:numBinsX
		xAxis(ii) = start + (ii-1) * xBinWidth;
	end
	start = yStart + yBinWidth/2;
	for ii = 1:numBinsY
		yAxis(ii) = start + (ii-1) * yBinWidth;
	end


% Gaussian smoothing using a boxcar method
function sMap = boxcarSmoothing(map)

	% Load the box template
	box = boxcarTemplate2D();

	% Using pos and phase naming for the bins originate from the first use of
	% this function.
	[numPhaseBins,numPosBins] = size(map);

	sMap = zeros(numPhaseBins,numPosBins);

	for ii = 1:numPhaseBins
		for jj = 1:numPosBins
			for k = 1:5
				% Phase index shift
				sii = k-3;
				% Phase index
				phaseInd = ii+sii;
				% Boundary check
				if phaseInd<1
					phaseInd = 1;
				end
				if phaseInd>numPhaseBins
					phaseInd = numPhaseBins;
				end
				
				for l = 1:5
					% Position index shift
					sjj = l-3;
					% Position index
					posInd = jj+sjj;
					% Boundary check
					if posInd<1
						posInd = 1;
					end
					if posInd>numPosBins
						posInd = numPosBins;
					end
					% Add to the smoothed rate for this bin
					sMap(ii,jj) = sMap(ii,jj) + map(phaseInd,posInd) * box(k,l);
				end
			end
		end
	end


% Gaussian boxcar template
function box = boxcarTemplate2D()
	global sig;
	if ~isempty(sig)
		
		fprintf('\nUsing gaussian filter\n');
		[xx,yy] = meshgrid(-2:2, -2:2);
		box=  exp(-(xx.^2+yy.^2)./(2*sig.^2));
	else
		box = [0.0025 0.0125 0.0200 0.0125 0.0025;...
		   0.0125 0.0625 0.1000 0.0625 0.0125;...
		   0.0200 0.1000 0.1600 0.1000 0.0200;...
		   0.0125 0.0625 0.1000 0.0625 0.0125;...
		   0.0025 0.0125 0.0200 0.0125 0.0025;];
	end