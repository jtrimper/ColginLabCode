% NlxHeadDir('inputFile')
% 
% Exctracts coordinates and head direction from a NeuraLynx video tracker
% file. The tracking must be from a 2 colour tracking (red and green). The
% red LED is assumed to be in the front of the head stage and the green LED
% at the back.
%
% The input file must contain references to the folder where data is
% stored. First line must specify the common t-list file to be used. Then a
% list of the data directories. Use --- to mark the start of a new data
% set. See example below for the input file layout.
%
% If the position file is distorted with reflection point and such, the
% file should be run through the video fixing program (NlxVideoFix) before
% it is used with this program.
%
%           INPUT FILE EXAMPLE
% N:\espenjoa\11657\Room5\2006-12-27_15-45-3\TTlist.txt
% N:\espenjoa\11657\Room5\2006-12-27_15-45-3\begin bigcyl 1
% N:\espenjoa\11657\Room5\2006-12-27_15-45-3\end bigcyl 1
% ---
% N:\espenjoa\11657\Room5\2006-12-11_13-37-20\TTList.txt
% N:\espenjoa\11657\Room5\2006-12-11_13-37-20\01. File Beginning To sleep1
% N:\espenjoa\11657\Room5\2006-12-11_13-37-20\02. sleep1 To end sleep1
% N:\espenjoa\11657\Room5\2006-12-11_13-37-20\04. begin big cyl 1 To end  big cyl 1
% 
%
% Version 1.3, 28. Mars 2007
%
% Version 1.4       Added the Watson U-square test for the cell
% 24. Jan. 2008     directionality. This value has to be compared to a
%                   table to see if it is significant.
%
% Created by Raymond Skjerpeng, CBM, NTNU, 2007
% Bug report: raymond.skjerpeng@ntnu.no
function NlxHeadDir_mod(inputFile, odir)

%__________________________________________________________________________
% Program parameters. Could be adjusted by the user
global inp;
if isempty(inp)
	inp = input('Do you want to interpolate missing position data? (Y/N): ','s');	%check that the user wishes to continue with interpolation
	while( strcmp(lower(inp),'y')~=1 && strcmp(lower(inp), 'n') ~=1)
		inp = input('Do you want to continue with interpolation? (Y/N): ','s');
	end
end
% Maximum gap of missing position samples in a row that should be
% interpolated.
if(strcmp(lower(inp),'y'))
	param.maxTrackingGap = 1.5; % [sec]
else
	param.maxTrackingGap= 0.0;
end

% Number of directional bins in the polar plot. 360 degrees are distributed
% over these bins.
param.numDirBins = 72;

% Mark if the polar plot should be smoothed. 1 = smooth, 2 = no smooth
param.smooth = 1;

binWidth = 360/param.numDirBins;

% Smoothing factor for the polar plot
param.smoothFactor = 1.2 * binWidth;

% Picture storing format. The png format can be used when running the
% program on remote desktop. 
%1 = bmp. Bit Map
%2 = png. Portable Network Graphic
param.imageFormat = 1;

global dir_delim;
if ispc
	dir_delim='\';
else
	dir_delim = '/';
end
outdir = strcat(pwd,dir_delim,odir);
fprintf('\nOutputing files to specified directory: %s\n', outdir);
if ~isdir(outdir)
	mkdir(outdir);
end
if strcmp(lower(inp),'y')
	outdir = strcat(outdir,dir_delim,'interp',dir_delim);
else
	outdir = strcat(outdir,dir_delim,'nointerp',dir_delim);
end
if ~isdir(outdir)
	mkdir(outdir);
end

%__________________________________________________________________________

% Read mode. 0 = Read ttfile. 1 = read directory.
readMode = 0;

% Open the input file for reading
fid = fopen(inputFile,'r');
if fid == -1
    disp('Couldn''t find the input file')
    return
end

% Set output file name
ind = strfind(inputFile,'.');
outputFile = strcat(outdir,'out_',inputFile(1:ind(end)),'xls');

% Open the output file for writing
fid2 = fopen(outputFile,'w');

% Write header to the output file
fprintf(fid2,'%s\t','Cell ');
fprintf(fid2,'%s\t','Mean Angle ');
fprintf(fid2,'%s\t','Vector Length ');
fprintf(fid2,'%s\t','% Good Samples');
fprintf(fid2,'%s\t','Total spikes');
fprintf(fid2,'%s\t','Spikes kept');
fprintf(fid2,'%s\t','% Spikes kept');
fprintf(fid2,'%s\t','Watson U^2');
for ii = 1:param.numDirBins-1
    fprintf(fid2,'%s%u\t','Bin ',ii);
end
fprintf(fid2,'%s%u\n','Bin ',param.numDirBins);
nDirs=0;
% Read info from input file and read the refrenced data
while ~feof(fid)
    str = fgetl(fid);
	nDirs=nDirs+1;
    if strcmp(str,'---')
        % New ttfile and set of folders will follow
        readMode = 0;
		%nDirs=0;
        % Strinf for the ttlist
        str = fgetl(fid);
    end
	strchk=lower(str(end-5:end-1));
	if(strcmp(strchk,'sleep'))
		readMode=0;
		str=fgetl(fid);
	end
    if ~readMode
		while ~readMode
			if feof(fid)
				return;
			end
			% Get the path for the ttlist
			strchk=lower(str(end-5:end-1));
			if(strcmp(strchk,'sleep'))
				readMode=0;
				str=fgetl(fid);
			else
				tListFile = str;
				readMode = 1;
			end
		end
        % Go to the next iteration
        continue
    else
        % Get the path for the data folder
        dirPath = str;
    end
	
    % Make sure the directory path ends with a '\'
    if ~strcmp(dirPath(end),'\')
        dirPath = strcat(dirPath,'\');
    end
    % Path for the video file
    posFile = strcat(dirPath,'VT1.Nvt');
    
    % Path for the directory for storing the polar plots
    polarDir = strcat(outdir,'polarPlots\');
    if ~isdir(polarDir)
		mkdir(polarDir);
	end
    % Check if subdir for storing images are present. If not, it is
    % created.
%{
    dirInfo = dir(dirPath);
    found = 0;
    for kk=1:size(dirInfo,1)
        if dirInfo(kk).isdir
            if strcmp(dirInfo(kk).name,'polarPlots')
                found = 1;
            end
        end
    end
    if found==0
        mkdir(dirPath,'polarPlots');
    end
%}    
    
    % Read the position data
    disp('Read position data')
    posData = readVideoData(posFile);
    
    % Decode the target data
    disp('Decode the target data')
    drawnow
    pause(0)
    [dTargets,tracking] = decodeTargets(posData.targets);
    
    % Exctract position data from the target data
    [frontX,frontY,backX,backY] = extractPosition(dTargets,tracking);
    
    % Interpolate missing position samples
    disp(sprintf('%s%2.2f%s','Interpolate missing position samples. Maximum gap is ',param.maxTrackingGap,' seconds'))
    drawnow
    pause(0)
    [frontX,frontY] = interporPos(frontX,frontY,param.maxTrackingGap,25);
    [backX,backY] = interporPos(backX,backY,param.maxTrackingGap,25);
    
    % Smooth the exctracted position samples using a moving mean filter
    % Set missing samples to NaN. Necessary when using the mean filter.
    indf = find(frontX==0);
    frontX(indf) = NaN;
    frontY(indf) = NaN;
    indb = find(backX==0);
    backX(indb) = NaN;
    backY(indb) = NaN;
    
    [frontX,frontY] = posMeanFilter(frontX,frontY);
    [backX,backY] = posMeanFilter(backX,backY);

    % Set the missing samples back to zero
    frontX(indf) = 0;
    frontY(indf) = 0;
    backX(indb) = 0;
    backY(indb) = 0;
    
    disp('Calculate the head stage direction')
    drawnow
    pause(0)
    % Calculate the head stage direction in degrees
    direction = headDirection(frontX,frontY,backX,backY);
    
    % Read the timestamps for the cells listed in the t-file list
    [timeStamps,tNames] = readSpikeData(tListFile,dirPath);
    
    % Number of cells
    numCells = length(timeStamps);
    
    for ii = 1:numCells
        fprintf('%s%s\n','Cell ',tNames{ii}(1:end-2))
        
        totalNumSpk = length(timeStamps{ii});
        
        % Calculate the position/direction index for the cell spikes
        spk2posInd = spikePos(timeStamps{ii},posData.t);
        
        % Calculate the head direction for each spike
        spkDir = direction(spk2posInd);
        
        % Calculate the mean firing direction
        [meanAngle,vectorLength] = meanDirection(spkDir);
        
        % Total number of position samples in the file
        totalNumPosSamples = length(direction);
        
        wU2 = watsonU2(spkDir,direction);
        
        % Calculate the rate of each directional bin
        [polarRate,numPosSamples,numSpikes] = polarPlot(spkDir,direction,posData.t,param.numDirBins,param.smooth,param.smoothFactor);
        
         % Percentage of good samples
        amountPosSamples = 100*numPosSamples/totalNumPosSamples;
        
        binWidth = 360/param.numDirBins;
        % Array with angle values
        polarAngle = binWidth/2:binWidth:360-binWidth/2;
        % Convert to radians
        polarAngle = polarAngle *2*pi/360;
        
        % Make the polar plot
        figure(1);
        polar(polarAngle,polarRate);
        grid off
        titleStr = sprintf('%s%s','Polar Plot for cell ',tNames{ii}(1:end-2));
        title(titleStr)
        

        % Set the figure file name
        figFile = sprintf('%s%s%s',polarDir,tNames{ii}(1:end-2),'_',num2str(nDirs),'_polarPlot');
        
        % Store the figure to file
        imageStore(figure(1),param.imageFormat,figFile);
        
        % write results to the output file
        fprintf(fid2,'%s\t',strcat(dirPath,tNames{ii}));
        fprintf(fid2,'%3.1f\t',meanAngle);
        fprintf(fid2,'%3.1f\t',vectorLength);
        fprintf(fid2,'%3.1f\t',amountPosSamples);
        fprintf(fid2,'%6.0f\t',totalNumSpk);
        fprintf(fid2,'%6.0f\t',numSpikes);
        fprintf(fid2,'%3.1f\t',100*numSpikes/totalNumSpk);
        fprintf(fid2,'%2.3f\t',wU2);
        for jj = 1:param.numDirBins-1
            fprintf(fid2,'%3.2f\t',polarRate(jj));
        end
        fprintf(fid2,'%3.2f\n',polarRate(param.numDirBins));
    end
end

% Close the files
fclose(fid);
fclose(fid2);

beep
disp('Finished')


%__________________________________________________________________________




%__________________________________________________________________________
%
%                       Head Direction functions
%__________________________________________________________________________



% Calculates the Watson U-squared test for nonparametric two-sample
% testing
function U2 = watsonU2(spkDir,direct)

% Number of spike samples
nSpikes = length(spkDir);
% Number of positon samples
nPos = length(direct);
% Total number of samples
N = nSpikes + nPos;

% Sort the angle arrays in ascending order
spkDir = sort(spkDir);
direct = sort(direct);

IN1 = zeros(N,1);
JN2 = zeros(N,1);
sCount = 1;
dCount = 1;
lastS = 0;
lastD = 0;

for ii = 1:N
    if sCount <= nSpikes
        if spkDir(sCount) <= direct(dCount)
            ind = find(spkDir == spkDir(sCount));
            nInd = length(ind);
            if nInd == 1
                lastS = sCount;
                IN1(ii) = lastS;
                JN2(ii) = lastD;
                sCount = sCount + 1;
            else
                sCount = sCount + nInd;
                lastS = sCount - 1;
                IN1(ii:ii+nInd-1) = lastS;
                JN2(ii:ii+nInd-1) = lastD;
                ii = ii + nInd - 1;
            end
        else
            ind = find(direct == direct(dCount));
            nInd = length(ind);
            if nInd == 1
                lastD = dCount;
                IN1(ii) = lastS;
                JN2(ii) = lastD;
                dCount = dCount + 1;
            else
                dCount = dCount + nInd;
                lastD = dCount - 1;
                IN1(ii:ii+nInd-1) = lastS;
                JN2(ii:ii+nInd-1) = lastD;
                ii = ii + nInd - 1;
            end
        end
    else
        if dCount > nPos
            break
        else
            ind = find(direct == direct(dCount));
            nInd = length(ind);
            if nInd == 1
                IN1(ii) = 1;
                JN2(ii) = dCount;
                dCount = dCount + 1;
            else
                dCount = dCount + nInd;
                lastD = dCount - 1;
                IN1(ii:ii+nInd-1) = 1;
                JN2(ii:ii+nInd-1) = lastD;
                ii = ii + nInd - 1;
            end
        end
    end
end

IN1 = IN1/nSpikes;
JN2 = JN2/nPos;

if IN1(1) == 0
    dk = JN2 - IN1;
else
    dk = IN1 - JN2;
end

sumDk = sum(dk);
dk2 = dk.^2;
sumDk2 = sum(dk2);

U2 = (nSpikes*nPos/(N^2)) * (sumDk2 - ((sumDk^2)/N) );



% Calculates the polar plot values
function [polarBins,numPosSamples,numSpikes] = polarPlot(spkDir,posDir,posTime,numBins,smooth,smoothFactor)

% Width of each directional bin
binWidth = round(360/numBins);
% Allocate memory for the array
polarBins = zeros(1,numBins);

% remove spikes that don't have a valid value
spkDir(isnan(spkDir)) = [];
% remove postion samples that doesn't have a valid value
ind = isnan(posDir);
ind = find(ind);
posDir(ind) = [];

% Number of position samples left after removal of NaN
numPosSamples = length(posDir);
% Number of spikes after removal of NaN
numSpikes = length(spkDir);

if smooth
    posTime(ind) = [];
    % Calculate the smoothed polar plot
    invSmooth = 1/smoothFactor;
    pAxis = binWidth/2:binWidth:360-binWidth/2;
    ii = 0;
    for x = pAxis
        ii = ii + 1;
        polarBins(ii) = polarRateEstimate(x,invSmooth,spkDir,posDir,posTime);
    end
else
    start = -binWidth;
    stop = 0;
    % Calculate the polar plot without smoothing
    for ii = 1:numBins
        start = start + binWidth;
        stop = stop + binWidth;
        numSamp = length(find(posDir>=start & posDir<stop));
        numSpk = length(find(spkDir>=start & spkDir<stop));
        if isempty(numSamp)
            polarBins(ii) = NaN;
        else
            polarBins(ii) = numSpk/numSamp;
        end
    end
end

function rate = polarRateEstimate(angle,smooth,spkDir,posDir,posTime)

% Angualar distance between current angle bin and the spike angles
spkDist = abs(spkDir-angle);
% Angles are circular and maximum distance is 180 degrees
ind = find(spkDist>180);
spkDist(ind) = 360 - spkDist(ind);
% Angualar distance between current angle bin and the position angles
posDist = abs(posDir-angle);
ind = find(posDist>180);
posDist(ind) = 360 - posDist(ind);

% Smoothed spike sum for this angle
smoothSpikeSum = sum(gaussianKernel(spkDist*smooth));
% Smoothed position sum for this angle
smoothPosSum = trapz(posTime,gaussianKernel(posDist*smooth));

% Smoothed rate for this angle
rate = smoothSpikeSum / smoothPosSum;

% Gaussian kernel for the rate function.
function r = gaussianKernel(x)
r = exp(-0.5*(x.*x));


% Calculates the circular mean of the spike angles
function [meanAngle,R] = meanDirection(spkDir)

if isempty(spkDir)
    meanAngle = NaN;
    R = NaN;
    return
end

% Remove NaN entries if any
ind = isnan(spkDir);
spkDir(ind==1) = [];

if isempty(spkDir)
    meanAngle = NaN;
    R = NaN;
    return
end

% Number of spikes
N = length(spkDir);

X = sum(cosd(spkDir))/N;
Y = sum(sind(spkDir))/N;
% Length of angle vector
R = sqrt(X^2+Y^2);

% Mean angle
if Y>0 && X>0
    meanAngle = atand(Y/X);    
elseif X<0
    meanAngle = atand(Y/X)+180;
elseif Y<0 && X>0
    meanAngle = atand(Y/X)+360;
end







% Calculates the direction of the head stage from the two set of
% coordinates. If one or both coordinate sets are missing for one samle the
% direction is set to NaN for that sample. Direction is also set to NaN for
% samples where the two coordinate set are identical. Returns the
% direction in degrees
function direct = headDirection(frontX,frontY,backX,backY)

% Number of position samples in data set
N = length(frontX);
direct = zeros(N,1);

for ii = 1:N
    
    if frontX(ii)==0 || backX(ii)==0
        % One or both coordinates are missing. No angle.
        direct(ii) = NaN;
        continue
    end
    
    % Calculate the difference between the coordinates
    xd = frontX(ii) - backX(ii);
    yd = frontY(ii) - backY(ii);
    
    if xd==0
        if yd==0
            % The two coordinates are at the same place and it is not
            % possible to calculate the angle
            direct(ii) = NaN;
            continue
        elseif yd>0
            direct(ii) = 90;
            continue
        else
            direct(ii) = 270;
            continue
        end
    end
    if yd==0
        if xd>0
            % Angle is zero
            continue
        else
            direct(ii) = 180;
            continue
        end
    end
    
    if frontX(ii)>backX(ii) && frontY(ii)>backY(ii)
        % Angle between 0 and 90 degrees
        direct(ii) = atan(yd/xd) * 360/(2*pi);
        
    elseif frontX(ii)<backX(ii) && frontY(ii)>backY(ii)
        % Angle between 90 and 180 degrees
        direct(ii) = 180 - atan(yd/abs(xd)) * 360/(2*pi);
        
    elseif frontX(ii)<backX(ii) && frontY(ii)<backY(ii)
        % Angle between 180 and 270 degrees
        direct(ii) = 180 + atan(abs(yd)/abs(xd)) * 360/(2*pi);
        
    else
        % Angle between 270 and 360 degrees
        direct(ii) = 360 - atan(abs(yd)/xd) * 360/(2*pi);
    end
end


%__________________________________________________________________________
%
%                       Position functions
%__________________________________________________________________________

% Moving window mean smoothing filter
function [posx,posy] = posMeanFilter(posx,posy)

% Smooth samples with a mean filter over 15 samples
for cc = 8:length(posx)-7
    posx(cc) = nanmean(posx(cc-7:cc+7));   
    posy(cc) = nanmean(posy(cc-7:cc+7));
end



% Estimates lacking position samples using linear interpolation. When more
% than timeTreshold sek of data is missing in a row the data is left as
% missing.
%
% Raymond Skjerpeng 2006.
function [x,y] = interporPos(x,y,timeTreshold,sampRate)

% Turn of warning
warning('off','MATLAB:divideByZero');

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


% Exctracts the individual coordinates for the centre of mass of each 
% tracking diode. The red LEDs are assumed to be at the front and the green
% diodes are assumed to be at the back.
function [frontX,frontY,backX,backY] = extractPosition(targets,tracking)

ind = find(tracking(2:end));
if length(ind) <= 1
    % Need at least two colours to get head direction
    disp('ERROR: To few LED colours have been tracked. Not possible to find head direction')
    frontX = NaN;
    frontY = NaN;
    backX = NaN;
    backY = NaN;
    return
else
    if ~tracking(2) && ~tracking(5)
        disp('ERROR: Red LED has not been tracked')
        frontX = NaN;
        frontY = NaN;
        backX = NaN;
        backY = NaN;
        return
    end
    if ~tracking(3) && ~tracking(6)
        disp('ERROR: Green LED has not been tracked')
        frontX = NaN;
        frontY = NaN;
        backX = NaN;
        backY = NaN;
        return
    end
end

% Number of samples in the data
numSamp = size(targets,1);

% Allocate memory for the arrays
frontX = zeros(1,numSamp);
frontY = zeros(1,numSamp);
backX = zeros(1,numSamp);
backY = zeros(1,numSamp);

% Exctract the front coordinates (red LED)
if tracking(2) && ~tracking(5)
    % Pure red but not raw red
    for ii = 1:numSamp
        ind = find(targets(ii,:,7));
        if length(ind)>0
            frontX(ii) = mean(targets(ii,ind,1));
            frontY(ii) = mean(targets(ii,ind,2));
        end
    end
end
if ~tracking(2) && tracking(5)
    % Not pure red but raw red
    for ii = 1:numSamp
        ind = find(targets(ii,:,4));
        if length(ind)>0
            frontX(ii) = mean(targets(ii,ind,1));
            frontY(ii) = mean(targets(ii,ind,2));
        end
    end
end
if tracking(2) && tracking(5)
    % Both pure red and raw red
    for ii = 1:numSamp
        ind = find(targets(ii,:,7) | targets(ii,:,4));
        if length(ind)>0
            frontX(ii) = mean(targets(ii,ind,1));
            frontY(ii) = mean(targets(ii,ind,2));
        end
    end
end

% Exctract the back coordinates (green LED)
if tracking(3) && ~tracking(6)
    % Pure green but not raw green
    for ii = 1:numSamp
        ind = find(targets(ii,:,8));
        if length(ind)>0
            backX(ii) = mean(targets(ii,ind,1));
            backY(ii) = mean(targets(ii,ind,2));
        end
    end
end
if ~tracking(3) && tracking(6)
    % Not pure green but raw green
    for ii = 1:numSamp
        ind = find(targets(ii,:,5));
        if length(ind)>0
            backX(ii) = mean(targets(ii,ind,1));
            backY(ii) = mean(targets(ii,ind,2));
        end
    end
end
if tracking(3) && tracking(6)
    % Both pure green and raw green
    for ii = 1:numSamp
        ind = find(targets(ii,:,8) | targets(ii,:,5));
        if length(ind)>0
            backX(ii) = mean(targets(ii,ind,1));
            backY(ii) = mean(targets(ii,ind,2));
        end
    end
end


% Finds the position to the spikes
function spkInd = spikePos(ts,post)
N = length(ts);

spkInd = zeros(N,1);


for ii = 1:N
    tdiff = (post-ts(ii)).^2;
    [m,ind] = min(tdiff);
    spkInd(ii) = ind(1);
end



%__________________________________________________________________________
%
%                       Target functions
%__________________________________________________________________________


% Decodes the target data.
function [dTargets,trackingColour] = decodeTargets(targets)

% Number of samples
numSamp = size(targets,2);

% Allocate memory to the array. 9 fields per sample: X-coord, Y-coord and
% 7 colour flag.
% Colour flag: 3=luminance, 4=rawRed, 5=rawGreen, 6=rawBlue, 7=pureRed,
% 8=pureGreen, 9=pureBlue.
dTargets = int16(zeros(numSamp,50,9));

for ii = 1:numSamp
    for jj = 1:50
        bitField = bitget(targets(jj,ii),1:32);
        if bitField(13)% Raw blue
            % Set the x-coord to the target
            ind = find(bitField(1:12));
            dTargets(ii,jj,1) = sum(2.^(ind-1));
            % Set the y-coord to the target
            ind = find(bitField(17:28));
            dTargets(ii,jj,2) = sum(2.^(ind-1));
            dTargets(ii,jj,6) = 1;
        end
        if bitField(14) % Raw green
            ind = find(bitField(1:12));
            dTargets(ii,jj,1) = sum(2.^(ind-1));
            ind = find(bitField(17:28));
            dTargets(ii,jj,2) = sum(2.^(ind-1));
            dTargets(ii,jj,5) = 1;
        end
        if bitField(15) % Raw red
            ind = find(bitField(1:12));
            dTargets(ii,jj,1) = sum(2.^(ind-1));
            ind = find(bitField(17:28));
            dTargets(ii,jj,2) = sum(2.^(ind-1));
            dTargets(ii,jj,4) = 1;
        end
        if bitField(16) % Luminance
            ind = find(bitField(1:12));
            dTargets(ii,jj,1) = sum(2.^(ind-1));
            ind = find(bitField(17:28));
            dTargets(ii,jj,2) = sum(2.^(ind-1));
            dTargets(ii,jj,3) = 1;
        end
        if bitField(29) % Pure blue
            ind = find(bitField(1:12));
            dTargets(ii,jj,1) = sum(2.^(ind-1));
            ind = find(bitField(17:28));
            dTargets(ii,jj,2) = sum(2.^(ind-1));
            dTargets(ii,jj,9) = 1;
        end
        if bitField(30) % Puregreen
            ind = find(bitField(1:12));
            dTargets(ii,jj,1) = sum(2.^(ind-1));
            ind = find(bitField(17:28));
            dTargets(ii,jj,2) = sum(2.^(ind-1));
            dTargets(ii,jj,8) = 1;
        end
        if bitField(31) % Pure red
            ind = find(bitField(1:12));
            dTargets(ii,jj,1) = sum(2.^(ind-1));
            ind = find(bitField(17:28));
            dTargets(ii,jj,2) = sum(2.^(ind-1));
            dTargets(ii,jj,7) = 1;
        end
    end
end

% Find out what colours were used in the tracking
trackingColour = zeros(1,7);
if ~isempty(find(dTargets(:,:,3),1)) % Luminance
    trackingColour(1) = 1;
end
if ~isempty(find(dTargets(:,:,7),1)) % Pure Red
    trackingColour(2) = 1;
end
if ~isempty(find(dTargets(:,:,8),1)) % Pure Green
    trackingColour(3) = 1;
end
if ~isempty(find(dTargets(:,:,9),1)) % Pure Blue
    trackingColour(4) = 1;
end
if ~isempty(find(dTargets(:,:,4),1)) % Raw Red
    trackingColour(5) = 1;
end
if ~isempty(find(dTargets(:,:,5),1)) % Raw Green
    trackingColour(6) = 1;
end
if ~isempty(find(dTargets(:,:,6),1)) % Raw Blue
    trackingColour(7) = 1;
end


%__________________________________________________________________________
%
%                       Image storing function
%__________________________________________________________________________

% Function for storing figures to file
% format = 1 -> bmp
% format = 2 -> png
function imageStore(figHandle,format,figFile)

% Make the background of the figure white
set(figHandle,'color',[1 1 1]);

if format == 1
    % Store the image as bmp
    figFile = strcat(figFile,'.bmp');
    f = getframe(figHandle);
    pic = frame2im(f);
    imwrite(pic,figFile,'bmp');
end
if format == 2
    % Store image as png
    figFile = strcat(figFile,'.png');
    print(figHandle, '-dpng',figFile)
end


%__________________________________________________________________________
%
%                       Input function
%__________________________________________________________________________


function [timeStamps,F] = readSpikeData(ttlist,dirPath)

% read the file names from the t-file list
F = ReadFileList(ttlist);

% Number of cells/files in the list
numCells = length(F);

% Array to keep cell timestimes in
timeStamps = cell(1,numCells);

% Read the spike data, but must look out for files in the list that
% don't exist for this session
dirFiles = dir(dirPath);        % Files in directory
NaFile = cell(1,length(F));     % Store non existing file names here
NaFileCounter = 0;              % Counts number of non existing files
for cc=1:length(F)
    I = strmatch(char(F(cc)),char(dirFiles.name),'exact'); % Try to find file in dir
    if isempty(I) % File is non existing
        NaFileCounter = NaFileCounter + 1;
        NaFile(1,NaFileCounter) = F(cc);
    end
end
NaFile = NaFile(1,1:NaFileCounter);
    
% Load data from the cut files generated by Mclust
S = LoadSpikes(F,dirPath,NaFile);


for ii = 1:numCells
    temp = S{ii};
    % Check if this is a valid timestamps object, if not it is an empty
    % cell
    if ~isa(temp,'ts')
        % Silent cell
        ts = [];
    else
        % Timestamps for cell in seconds
        ts = Data(temp)/10000;  %getfield(S,{ii},t)/10000;
    end
    % Fill the timestamps for this cell in the timestamps array
    timeStamps{ii} = ts;
end




function F = ReadFileList(fn)

% F = ReadFileList(fn)
%
% INPUTS: 
%   fn -- an ascii file of filenames, 1 filename per line
% 
% OUTPUTS:
%   F -- a cell array of filenames suitable for use in programs
%        such as LoadSpikes
%
% Now can handle files with headers

% ADR 1998
% version L4.1
% status: PROMOTED

% v4.1 added ReadHeader

[fp,errmsg] = fopen(fn, 'rt');
if (fp == -1)
   error(['Could not open "', fn, '". ', errmsg]);
end

ReadHeader(fp);
ifp = 1;
while (~feof(fp))
   F{ifp} = fgetl(fp);
   ifp = ifp+1;
end
fclose(fp);

F = F';

function H = ReadHeader(fp)
% H = ReadHeader(fp)
%  Reads NSMA header, leaves file-read-location at end of header
%  INPUT: 

%      fid -- file-pointer (i.e. not filename)
%  OUTPUT: 
%      H -- cell array.  Each entry is one line from the NSMA header
% Now works for files with no header.
% ADR 1997
% version L4.1
% status: PROMOTED
% v4.1 17 nov 98 now works for files sans header
%---------------

% Get keys
beginheader = '%%BEGINHEADER';
endheader = '%%ENDHEADER';

iH = 1; H = {};
curfpos = ftell(fp);

% look for beginheader
headerLine = fgetl(fp);
if strcmp(headerLine, beginheader)
   H{1} = headerLine;
   while ~feof(fp) && ~strcmp(headerLine, endheader)     
      headerLine = fgetl(fp);
      iH = iH+1;
      H{iH} = headerLine;
   end
else % no header
   fseek(fp, curfpos, 'bof');
end



function S = LoadSpikes(tfilelist, path, NaFile)
% tfilelist:    List of t-files. Each file contains a cluster of spikes
%               from a cell.
% path:         Path to the directory were the t-files are stored
% NaFile:       List of file names in tfilelist that don't exist
%               in the current directory
%
% inp: tfilelist is a cellarray of strings, each of which is a
% tfile to open.  Note: this is incompatible with version unix3.1.
% out: Returns a cell array such that each cell contains a ts 
% object (timestamps which correspond to times at which the cell fired)
%
% Edited by: Raymond Skjerpeng


%-------------------
% Check input type
%-------------------

if ~isa(tfilelist, 'cell')
   error('LoadSpikes: tfilelist should be a cell array.');
end


% Number of file names in tfilelist
nFiles = length(tfilelist);
% Actual number of files to be loaded
anFiles = nFiles - length(NaFile);


%--------------------
% Read files
%--------------------


% for each tfile
% first read the header, then read a tfile 
% note: uses the bigendian modifier to ensure correct read format.


S = cell(nFiles, 1);
for iF = 1:nFiles
    %DisplayProgress(iF, nFiles, 'Title', 'LoadSpikes');
    tfn = tfilelist{iF};
    % Check if file exist
    if length(strmatch(char(tfn),NaFile,'exact'))>0
        S{iF} = -1; % Set this as default for each file that doesn't exist
    else
        tfn = strcat(strcat(path,'\'),tfn); % Path to file + file name
        if ~isempty(tfn)
            tfp = fopen(tfn, 'rb','b');
            if (tfp == -1)
                warning([ 'Could not open tfile ' tfn]);
            end

            ReadHeader(tfp);    
            S{iF} = fread(tfp,inf,'uint32');	%read as 32 bit ints
            S{iF} = ts(S{iF});
            fclose(tfp);
        end 	% if tfn valid
    end
end		% for all files




% Reads the video data from the video file (nvt) using the NeuraLynx dll
% for reading video data.
function posData = readVideoData(posFile)


% Want  timestamps and targets
fieldSelect = [1,0,0,0,1,0];
% Get header
getHeader = 0;
% Exctract every record
extractMode = 1;

% Get the data
%[posData.t,posData.targets] = Nlx2MatVT_v4(posFile,fieldSelect,getHeader,extractMode);
[posData.t,posData.targets] = Nlx2MatVT(posFile,fieldSelect,getHeader,extractMode);

% Convert timestamps to seconds
posData.t = posData.t/1000000;


% EOF
