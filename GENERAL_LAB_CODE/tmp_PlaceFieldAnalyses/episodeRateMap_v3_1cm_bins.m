% [information, sparsity, selectivity, avgSpeed] = episodeRateMap(cellStack, startTime, stopTime, Fs, videoFile)
%
% Calculates ratemaps for the cell spike timestamps in the cell stack, but
% uses only data in the episodes set by the startTime and stopTime arrays.
%
% This program assumes pre-processing of the data before entering this
% function. (Made for Laura Colgin)
%
% NOTE! Program needs the video data import files from NeuraLynx in addition
% to work. Files are called Nlx2MatVT.mexw32 and Nlx2MatVT.mexw64. You have
% to set a correct scaling factor to go from pixels to centimeters for
% position data. Scaling factor is called positionScaleFactor and is
% located in the start of the program code.
%
% INPUT ARGUMENTS
%
% cellStack     Matlab-cell-array with the cell names and cell spike 
%               timestamps. 1 row and 2 columns for each cell. 1st column =
%               cell name and 2nd column - array with cell spike
%               timestamps. Timestamps are assumed to be the EEG indexes
%               that correspond to the spike timestamps.
%
% startTime     Array with all the start times for the episodes. Again time
%               is measured in EEG-indexes.
%
% stopTime      Array with all the stop times for the episodes. Must be of
%               same length as startTime. Time in EEG-indexes.
%
% Fs            Sampling rate of the EEG signal used for timing.
%
% videoFile     Name of the NeuraLynx video file where the position data
%               will be loaded from. The directory the file is located in
%               will also be used for storing the images files.
%
%
% RETURN VALUES
%
% information   Array with Shannon's information values calculated from the
%               rate map for each cell in the cellStack. One value for each
%               cell.
%
% avgSpeed      Average speed of the rat withing the episodes. One value
%               for the session.
%
% Version 1.0
% Raymond Skjerpeng, KI/CBM, NTNU, 2009.
function [information, sparsity, selectivity, nFields_matrix, avgRate, peakRate, fieldSize, zCoherence, peakRate_map, bursting, maps, avgSpeed] = episodeRateMap_v3_1cm_bins(cellStack, startTime, stopTime, Fs, videoFile, id)


% Scale factor for the position data going from pixels to centimeters
%positionScaleFactor = 0.5;

%positionScaleFactor = 0.25;  %0.25 in equalPlot_max LLC
%positionScaleFactor = 0.375; %used this scaling factor for double morph
positionScaleFactor = 0.3; %used this scaling factor for rat11286
%positionScaleFactor = 0.37; %used this scaling factor for rat11286
%positionScaleFactor = 0.32;
%positionScaleFactor = 0.33;
%positionScaleFactor = 0.27; 
%box experimenets LLC


% Bin width in centimeters for the rate map
binWidth = 1; % [cm]

% Image format for the rate map images
% format = 1 -> bmp (24 bit)
% format = 2 -> png
% format = 3 -> eps
% format = 4 -> jpg
% format = 5 -> ai (Adobe Illustrator)
% format = 6 -> tiff (24 bit)
% format = 7 -> fig (Matlab figure)
imageFormat = 2;

%I added these parameters below to be able to run placefield function - LLC
% Minimum number of bins in a placefield. Fields with fewer bins than this
% treshold will not be considered as a placefield. Remember to adjust this
% value when you change the bin width
p.minNumBins = 16;
% Bins with rate at p.fieldTreshold * peak rate and higher will be considered as part
% of a place field
p.fieldTreshold = 0.2;
% Lowest field rate in Hz.
p.lowestFieldRate = 1.0;


strInd = strfind(videoFile,'\');
targetDirectory = videoFile(1:strInd(end));



% Number of cells
numCells = size(cellStack,1);

% Number of episodes
numEpisodes = length(startTime);



% Load video data and interpolate missing samples
[x,y,t] = readVideoData(videoFile, positionScaleFactor);

% Start time of the recording
trialStart = t(1);

% Transform the start and stop indexes to time
startTime = startTime / Fs + trialStart;
stopTime = stopTime / Fs + trialStart;

% Centre the coordinates in the cartesian coordinate system
centre = centreBox(x,y);
x = x - centre(1);
y = y - centre(2);

% Make plot of path, so that the user can verify that the scaling factor is
% correct
figure(1)
plot(x,y)
title('Path')


% Calculate the speed of the rat
v = speed2D(x,y,t);

% Number of position samples
N = length(x);

% Allocate memory for the new position data arrays
posx = zeros(20*N,1);
posy = zeros(20*N,1);
post = zeros(20*N,1);
speed = zeros(20*N,1);

% Counts number of samples added
sampCounter = 0;

% Collect the position data that falls withing the episodes
for ii = 1:numEpisodes
    ind = find(t >= startTime(ii) & t <= stopTime(ii));
    N = length(ind);
    posx(sampCounter+1:sampCounter+N) = x(ind);
    posy(sampCounter+1:sampCounter+N) = y(ind);
    post(sampCounter+1:sampCounter+N) = t(ind);
    speed(sampCounter+1:sampCounter+N) = v(ind);
    sampCounter = sampCounter + N;
end

posx = posx(1:sampCounter);
posy = posy(1:sampCounter);
post = post(1:sampCounter);
speed = speed(1:sampCounter);

% Make the position samples unique
[post, ind] = unique(post);
posx = posx(ind);
posy = posy(ind);
speed = speed(ind);

% Make timestamps unique
for ii = 1:numCells
    cellStack{ii,2} = unique(cellStack{ii,2});
end

% Calculate the extreme position values and side length for the box
maxX = nanmax(posx);
maxY = nanmax(posy);
xStart = nanmin(posx);
yStart = nanmin(posy);
xLength = maxX - xStart + 10;
yLength = maxY - yStart + 10;

information = zeros(numCells,1);
sparsity = zeros(numCells,1);
selectivity = zeros(numCells,1);
nFields_matrix = zeros(numCells,1);
avgRate = zeros(numCells,1);
peakRate = zeros(numCells,1); 
fieldSize = zeros(numCells,1); 
peakRate_map = zeros(numCells,1); 
bursting = zeros(numCells,1); 
maps = cell(numCells,3);
zCoherence = zeros(numCells,1);
episode_spike_time = zeros(20*N,1);

for ii = 1:numCells
    % Transform cell timestamps from eeg sample indexes to time
    cellStack{ii,2} = cellStack{ii,2} / Fs + trialStart;
    
    % Spike positions
    [spkx, spky] = spikePos(cellStack{ii,2},posx,posy,post);
    
    %added this to scale to same rate for slow and fast gamma when
    %determining field size
    %peak_all = peakRate_all(ii);
    peak_all = 1;
    
    % Calculate the rate map
    [map, xAxis, yAxis, posPDF] = rateMap(posx,posy,spkx,spky,binWidth,binWidth,xStart,xLength,yStart,yLength,0.04);
    maps{ii,1} = map;
    maps{ii,2} = xAxis;
    maps{ii,3} = yAxis;
    [nFields,fieldProp] = placefield(map,p,xAxis,yAxis,peak_all);
    %eval(['nFields' num2str(ii) ' = nFields']);
    nFields_matrix(ii) = nFields;
    avgRate(ii) = fieldProp.avgRate;
    peakRate(ii) = fieldProp.peakRate;
    fieldSize(ii) = fieldProp.size;
     % Calculate the z-coherence
    zCoherence(ii) = fieldcohere(map);
    
    % Peak rate of rate map
    peakRate_map(ii) = nanmax(nanmax(map));
    
    
    % Collect the spike data that falls withing the episodes
    for jj = 1:numEpisodes
        temp = cellStack{ii,2};
        ind = find(temp >= startTime(jj) & temp <= stopTime(jj));
        N = length(ind);
        episode_spike_time(sampCounter+1:sampCounter+N) = temp(ind);
        sampCounter = sampCounter + N;
    end
    
   % Calculate the percentage of bursting
    %[bursts,singleSpikes] = burstfinder(cellStack{ii,2},0.01); % 10 ms criterion
    [bursts,singleSpikes] = burstfinder(episode_spike_time,0.01); % 10 ms criterion
    bursting(ii) = length(bursts)/(length(bursts)+length(singleSpikes));
   
    % Calculate the information value
    %information(ii) = mapstat(map,posPDF);
    [information(ii),sparsity(ii),selectivity(ii)] = mapstat(map,posPDF);
    %[information,sparseness,selectivity] = mapstat(map,pospdf);
    
    % Make plot of rate map
    figure(2)
    drawfield(map,xAxis,yAxis,'jet',nanmax(nanmax(map)),binWidth);
    axis image
    
    % Store image to file
    fileName = strcat(targetDirectory,cellStack{ii,1},'-rateMap',id);
    imageStore(figure(2),imageFormat,fileName,300);
    
end

% Calculate the average speed during the episodes
avgSpeed = nanmean(speed);

disp('ok')


%__________________________________________________________________________
%
%                       Statistic function
%__________________________________________________________________________

% Shannon information, sparseness, and selectivity  
function [information,sparsity,selectivity] = mapstat(map,posPDF)
n = size(map,1);
meanrate = nansum(nansum( map .* posPDF ));
meansquarerate = nansum(nansum( (map.^2) .* posPDF ));
if meansquarerate == 0
   sparsity = NaN;
else
sparsity = meanrate^2 / meansquarerate;
end
maxrate = max(max(map));
if meanrate == 0;
   selectivity = NaN;
else
   selectivity = maxrate/meanrate;
end
[i1, i2] = find( (map>0) & (posPDF>0) );  % the limit of x*log(x) as x->0 is 0 
if ~isempty(i1)
    akksum = 0;
    for i = 1:length(i1);
        ii1 = i1(i);
        ii2 = i2(i);
        akksum = akksum + posPDF(ii1,ii2) * (map(ii1,ii2)/meanrate) * log2( map(ii1,ii2) / meanrate ); 
    end
    information = akksum;
else
    information = NaN;
end


function z = fieldcohere(map)
[n,m] = size(map);
tmp = zeros(n*m,2);
k=0;
for y = 1:n
    for x = 1:m
        k = k + 1;
        xstart = max([1,x-1]);
        ystart = max([1,y-1]);
        xend = min([m x+1]);
        yend = min([n y+1]);
        nn = sum(sum(isfinite(map(ystart:yend,xstart:xend)))) - isfinite(map(y,x));
        if (nn > 0)
            tmp(k,1) = map(y,x);
            tmp(k,2) = nansum([ nansum(nansum(map(ystart:yend,xstart:xend))) , -map(y,x) ]) / nn;
        else
            tmp(k,:) = [NaN,NaN];    
        end
    end
end
index = find( isfinite(tmp(:,1)) & isfinite(tmp(:,2)) );
if length(index) > 3
    cc = corrcoef(tmp(index,:));
    z = atanh(cc(2,1));
else
    z = NaN;
end

function [bursts,singlespikes] = burstfinder(ts,maxisi)
bursts = [];
singlespikes = [];
isi = diff(ts);
n = length(ts);

if n == 0
    bursts = NaN;
    singlespikes = NaN;
    return
end

if isi(1) <= maxisi
   bursts = 1;
else
   singlespikes = 1;
end
for t = 2:n-1;
   if (isi(t-1)>maxisi) && (isi(t)<=maxisi)
      bursts = [bursts; t];
   elseif (isi(t-1)>maxisi) && (isi(t)>maxisi)
      singlespikes = [singlespikes; t];      
   end
end   
if (isi(n-1)>maxisi) 
    singlespikes = [singlespikes; n];      
end  





%__________________________________________________________________________
%
%                           Field functions
%__________________________________________________________________________

% Finds the position to the spikes
function [spkx,spky] = spikePos(ts,posx,posy,post)
N = length(ts);
spkx = zeros(N,1);
spky = zeros(N,1);

count = 0;
for ii = 1:N
    tdiff = (post-ts(ii)).^2;
    [m,ind] = min(tdiff);

    % Check if spike is in legal time sone
    if ~isnan(posx(ind(1)))
        count = count + 1;
        spkx(count) = posx(ind(1));
        spky(count) = posy(ind(1));

    end
end
spkx = spkx(1:count);
spky = spky(1:count);



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
function [map, xAxis, yAxis, posPDF] = rateMap(posx,posy,spkx,spky,xBinWidth,yBinWidth,xStart,xLength,yStart,yLength,sampleTime)

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

% Smooth the spike and time map
spikeMap = boxcarSmoothing(spikeMap);
timeMap = boxcarSmoothing(timeMap);
% 
% Calculate the smoothed rate map
map = spikeMap ./ timeMap;
% 
% Set bins that are visited less than 100 ms to NaN
map(timeMap<0.050) = NaN;

% Set the axis
start = xStart + xBinWidth/2;
for ii = 1:numBinsX
    xAxis(ii) = start + (ii-1) * xBinWidth;
end
start = yStart + yBinWidth/2;
for ii = 1:numBinsY
    yAxis(ii) = start + (ii-1) * yBinWidth;
end

posPDF = timeMap / nansum(nansum(timeMap));


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

% Gaussian boxcar template
box = [0.0025 0.0125 0.0200 0.0125 0.0025;...
       0.0125 0.0625 0.1000 0.0625 0.0125;...
       0.0200 0.1000 0.1600 0.1000 0.0200;...
       0.0125 0.0625 0.1000 0.0625 0.0125;...
       0.0025 0.0125 0.0200 0.0125 0.0025;];



% Find the centre of the box
function centre = centreBox(posx,posy)
% Find border values for path and box
maxX = max(posx);
minX = min(posx);
maxY = max(posy);
minY = min(posy);

% Set the corners of the reference box
NE = [maxX, maxY];
NW = [minX, maxY];
SW = [minX, minY];
SE = [maxX, minY];

% Get the centre coordinates of the box
centre = findCentre(NE,NW,SW,SE);

% Calculates the centre of the box from the corner coordinates
function centre = findCentre(NE,NW,SW,SE)

% The centre will be at the point of interception by the corner diagonals
a = (NE(2)-SW(2))/(NE(1)-SW(1)); % Slope for the NE-SW diagonal
b = (SE(2)-NW(2))/(SE(1)-NW(1)); % Slope for the SE-NW diagonal
c = SW(2);
d = NW(2);
x = (d-c+a*SW(1)-b*NW(1))/(a-b); % X-coord of centre
y = a*(x-SW(1))+c; % Y-coord of centre
centre = [x,y];



% Calculate the Speed of the rat in each position sample
%
% Version 1.0
% 3. Mar. 2008
% (c) Raymond Skjerpeng, CBM, NTNU, 2008.
function v = speed2D(x,y,t)

N = length(x);
v = zeros(N,1);

for ii = 2:N-1
    v(ii) = sqrt((x(ii+1)-x(ii-1))^2+(y(ii+1)-y(ii-1))^2)/(t(ii+1)-t(ii-1));
end
v(1) = v(2);
v(end) = v(end-1);


function [x,y,t] = readVideoData(file,scale)


% Set the field selection for reading the video files. 1 = Add parameter, 
% 0 = skip parameter
fieldSelection(1) = 1; % Timestamps
fieldSelection(2) = 1; % Extracted X
fieldSelection(3) = 1; % Extracted Y
fieldSelection(4) = 0; % Extracted Angel
fieldSelection(5) = 0; % Targets
fieldSelection(6) = 0; % Points
% Do we return header 1 = Yes, 0 = No.
extractHeader = 0;
% 5 different extraction modes, see help file for Nlx2MatVT
extractMode = 1; % Extract all data

% Use the NeuraLynx mex-compiled file to read the video data into the
% Matlab work memory.
[t, x, y] = Nlx2MatVT(file,fieldSelection,extractHeader,extractMode);

% Convert timestamps to seconds
t = t/1000000;

% Interpolate missing segments of the path, but max gap of 4 seconds
[x,y] = interporPos(x,y,4,25);

% Set the (0,0)-coordinates to NaN because these are missing position
% samples
ind = find(x==0 & y==0);
x(ind) = NaN;
y(ind) = NaN;

% Transform the coordinates from pixels to centimeters
x = x * scale;
y = y * scale;

% Smooth the path with a moving mean window filter (removing tracker
% jitter)
for cc=8:length(x)-7
    x(cc) = nanmean(x(cc-7:cc+7));
    y(cc) = nanmean(y(cc-7:cc+7));
end





% Estimates lacking position samples using linear interpolation. When more
% than timeTreshold seconds of data is missing in a row the data is left as
% missing.
%
% Raymond Skjerpeng 2006.
function [x,y] = interporPos(x,y,timeTreshold,sampRate)

% Turn of warnings
warning off;

% Number of samples that corresponds to the time treshold.
sampTreshold = floor(timeTreshold * sampRate);

% number of samples
numSamp = length(x);
% Find the indexes to the missing samples
temp1 = 1./x;
temp2 = 1./y;
indt1 = isinf(temp1);
indt2 = isinf(temp2);
ind = indt1 .* indt2;
ind2 = find(ind==1);
% Number of missing samples
N = length(ind2);

if N == 0
    % No samples missing, and we return
    return
end

change = 0;

% Remove NaN in the start of the path
if ind2(1) == 1
    change = 1;
    count = 0;
    while 1
        count = count + 1;
        if ind(count)==0
            break
        end
    end
    x(1:count) = x(count);
    y(1:count) = y(count);
%     ind(1:count) = 0;
%     ind2(1:count) = [];
end

% Remove NaN in the end of the path
if ind2(end) == numSamp
    change = 1;
    count = length(x);
    while 1
       count = count - 1;
       if ind(count)==0
           break
       end
    end
    x(count:numSamp) = x(count);
    y(count:numSamp) = y(count);
end

if change
    % Recalculate the missing samples
    temp1 = 1./x;
    temp2 = 1./y;
    indt1 = isinf(temp1);
    indt2 = isinf(temp2);
    % Missing samples are where both x and y are equal to zero
    ind = indt1 .* indt2;
    ind2 = find(ind==1);
    % Number of samples missing
    N = length(ind2);
end

for ii = 1:N
    % Start of missing segment (may consist of only one sample)
    start = ind2(ii);
    % Find the number of samples missing in a row
    count = 0;
    while 1
        count = count + 1;
        if ind(start+count)==0
            break
        end
    end
    % Index to the next good sample
    stop = start+count;
    if start == stop
        % Only one sample missing. Setting it to the last known good
        % sample
        x(start) = x(start-1);
        y(start) = y(start-1);
    else
        if count < sampTreshold
            % Last good position before lack of tracking
            x1 = x(start-1);
            y1 = y(start-1);
            % Next good position after lack of tracking
            x2 = x(stop);
            y2 = y(stop);
            % Calculate the interpolated positions
            X = interp1([1,2],[x1,x2],1:1/count:2);
            Y = interp1([1,2],[y1,y2],1:1/count:2);
            % Switch the lacking positions with the estimated positions
            x(start:stop) = X;
            y(start:stop) = Y;

            % Increment the counter (avoid estimating allready estimated
            % samples)
            ii = ii+count;
        else
            % To many samples missing in a row and they are left as missing
            ii = ii+count;
        end
    end
end


function drawfield(map,axis,axis2,cmap,maxrate,binWidth)
maxrate = ceil(maxrate);
if maxrate < 1
    maxrate = 1;
end    
[n,m] = size(map);
plotmap = ones(n,m,3);
for ii = 1:n
   for jj = 1:m
      if isnan(map(ii,jj))
        plotmap(n-ii+1,jj,1) = 1; % give the unvisited bins a gray colour
        plotmap(n-ii+1,jj,2) = 1;
        plotmap(n-ii+1,jj,3) = 1;
      else
        rgb = pixelcolour(map(ii,jj),maxrate,cmap);
        plotmap(n-ii+1,jj,1) = rgb(1);
        plotmap(n-ii+1,jj,2) = rgb(2);
        plotmap(n-ii+1,jj,3) = rgb(3);
      end   
   end
end   
image(axis,axis2,plotmap);
set(gca,'YDir','Normal');
s = sprintf('%s%u%s%2.1f','Peak ',maxrate,' Hz. BinWidth ',binWidth);
title(s);


% placefield identifies the placefields in the firing map. It returns the
% number of placefields and the location of the peak within each
% placefield.
%
% map           Rate map
% pTreshold     Field treshold
% pBins         Minimum number of bins in a field
% mapAxis       The map axis
function [nFields,fieldProp] = placefield(map,p,colAxis,rowAxis,peak_all)

binWidth = rowAxis(2) - rowAxis(1);


% Counter for the number of fields
nFields = 0;
% Field properties will be stored in this struct array
fieldProp = [];


% Allocate memory to the arrays
[N,M] = size(map);
% Array that contain the bins of the map this algorithm has visited
visited = zeros(N,M);
nanInd = isnan(map);
visited(nanInd) = 1;
visited2 = visited;



% Go as long as there are unvisited parts of the map left
while ~prod(prod(visited))
    
    % Find the current maximum
    [peak,r] = max(map);
    [peak,pCol] = max(peak);
    pCol = pCol(1);
    pRow = r(pCol);
    
    % Array that will contain the bin positions to the current placefield
    binsX = pRow;
    binsY = pCol;
    
    % Check if peak rate is high enough
    if peak < p.lowestFieldRate
        break;
    end
    
    %visited2(map<p.fieldTreshold*peak_all) = 1; %changed by LLC to be the peak for slow and fast gamma together
    %visited2(map<p.fieldTreshold*peak) = 1;
    visited2(map<peak_all) = 1;
    % Find the bins that construct the peak field
    [binsX,binsY,visited2] = recursiveBins(map,visited2,binsX,binsY,pRow,pCol,N,M);
    
    

    if length(binsX) >= p.minNumBins % Minimum size of a placefield
        nFields = nFields + 1;
        % Find centre of mass (com)
        comX = 0;
        comY = 0;
        % Total rate
        R = 0;
        for ii = 1:length(binsX)
            R = R + map(binsX(ii),binsY(ii));
            comX = comX + map(binsX(ii),binsY(ii)) * rowAxis(binsX(ii));
            comY = comY + map(binsX(ii),binsY(ii)) * colAxis(binsY(ii));
        end
        % Average rate in field
        avgRate = nanmean(nanmean(map(binsX,binsY)));
        % Peak rate in field
        peakRate = nanmax(nanmax(map(binsX,binsY)));
        % Size of field
        fieldSize = length(binsX) * binWidth^2;
        % Put the field properties in the struct array
        fieldProp = [fieldProp; struct('x',comY/R,'y',comX/R,'avgRate',avgRate,'peakRate',peakRate,'size',fieldSize)];
    end
    visited(binsX,binsY) = 1;
    map(visited == 1) = 0;
end


function [binsX,binsY,visited] = recursiveBins(map,visited,binsX,binsY,ii,jj,N,M)
% If outside boundaries of map -> return.
if ii<1 || ii>N || jj<1 || jj>M
    return;
end
% If all bins are visited -> return.
if prod(prod(visited))
    return;
end
if visited(ii,jj) % This bin has been visited before
    return;
else
    binsX = [binsX;ii];
    binsY = [binsY;jj];
    visited(ii,jj) = 1;
    % Call this function again in each of the 4 neighbour bins
    [binsX,binsY,visited] = recursiveBins(map,visited,binsX,binsY,ii,jj-1,N,M);
    [binsX,binsY,visited] = recursiveBins(map,visited,binsX,binsY,ii-1,jj,N,M);
    [binsX,binsY,visited] = recursiveBins(map,visited,binsX,binsY,ii,jj+1,N,M);
    [binsX,binsY,visited] = recursiveBins(map,visited,binsX,binsY,ii+1,jj,N,M);
end









function rgb = pixelcolour(map,maxrate,cmap)
cmap1 = ...
    [    0         0    0.5625; ...
         0         0    0.6875; ...
         0         0    0.8125; ...
         0         0    0.9375; ...
         0    0.0625    1.0000; ...
         0    0.1875    1.0000; ...
         0    0.3125    1.0000; ...
         0    0.4375    1.0000; ...
         0    0.5625    1.0000; ...
         0    0.6875    1.0000; ...
         0    0.8125    1.0000; ...
         0    0.9375    1.0000; ...
    0.0625    1.0000    1.0000; ...
    0.1875    1.0000    0.8750; ...
    0.3125    1.0000    0.7500; ...
    0.4375    1.0000    0.6250; ...
    0.5625    1.0000    0.5000; ...
    0.6875    1.0000    0.3750; ...
    0.8125    1.0000    0.2500; ...
    0.9375    1.0000    0.1250; ...
    1.0000    1.0000         0; ...
    1.0000    0.8750         0; ...
    1.0000    0.7500         0; ...
    1.0000    0.6250         0; ...
    1.0000    0.5000         0; ...
    1.0000    0.3750         0; ...
    1.0000    0.2500         0; ...
    1.0000    0.1250         0; ...
    1.0000         0         0; ...
    0.8750         0         0; ...
    0.7500         0         0; ...
    0.6250         0         0 ];

cmap2 = ...
   [0.0417         0         0; ...
    0.1250         0         0; ...
    0.2083         0         0; ...
    0.2917         0         0; ...
    0.3750         0         0; ...
    0.4583         0         0; ...
    0.5417         0         0; ...
    0.6250         0         0; ...
    0.7083         0         0; ...
    0.7917         0         0; ...
    0.8750         0         0; ...
    0.9583         0         0; ...
    1.0000    0.0417         0; ...
    1.0000    0.1250         0; ...
    1.0000    0.2083         0; ...
    1.0000    0.2917         0; ...
    1.0000    0.3750         0; ...
    1.0000    0.4583         0; ...
    1.0000    0.5417         0; ...
    1.0000    0.6250         0; ...
    1.0000    0.7083         0; ...
    1.0000    0.7917         0; ...
    1.0000    0.8750         0; ...
    1.0000    0.9583         0; ...
    1.0000    1.0000    0.0625; ...
    1.0000    1.0000    0.1875; ...
    1.0000    1.0000    0.3125; ...
    1.0000    1.0000    0.4375; ...
    1.0000    1.0000    0.5625; ...
    1.0000    1.0000    0.6875; ...
    1.0000    1.0000    0.8125; ...
    1.0000    1.0000    0.9375];
if strcmp(cmap,'jet')
   steps = (31*(map/maxrate))+1;
   steps = round(steps);
   if steps>32; steps = 32; end
   if steps<1; steps = 1; end
   rgb = cmap1(steps,:);
else
   steps = (31*(map/maxrate))+1;
   steps = round(steps);
   if steps>32; steps = 32; end
   if steps<1; steps = 1; end
   rgb = cmap2(steps,:);
end




% Function for storing figures to file
% figHanle  Figure handle (Ex: figure(1))
% format = 1 -> bmp (24 bit)
% format = 2 -> png
% format = 3 -> eps
% format = 4 -> jpg
% format = 5 -> ai (Adobe Illustrator)
% format = 6 -> tiff (24 bit)
% format = 7 -> fig (Matlab figure)
% figFile   Name (full path) for the file
% dpi       DPI setting for the image file
function imageStore(figHandle,format,figFile,dpi)

% Make the background of the figure white
set(figHandle,'color',[1 1 1]);
dpi = sprintf('%s%u','-r',dpi);

switch format
    case 1
        % Store the image as bmp (24 bit)
        figFile = strcat(figFile,'.bmp');
        print(figHandle, dpi, '-dbmp',figFile);
    case 2
        % Store image as png
        figFile = strcat(figFile,'.png');
        print(figHandle, dpi,'-dpng',figFile);
    case 3
        % Store image as eps (Vector format)
        figFile = strcat(figFile,'.eps');
        print(figHandle, dpi,'-depsc',figFile);
    case 4
        % Store image as jpg
        figFile = strcat(figFile,'.jpg');
        print(figHandle,dpi, '-djpeg',figFile);
    case 5
        % Store image as ai (Adobe Illustrator)
        figFile = strcat(figFile,'.ai');
        print(figHandle,dpi, '-dill',figFile);
    case 6
        % Store image as tiff (24 bit)
        figFile = strcat(figFile,'.tif');
        print(figHandle,dpi, '-dtiff',figFile);
    case 7
        % Store figure as Matlab figure
        figFile = strcat(figFile,'.fig');
        saveas(figHandle,figFile,'fig')
end