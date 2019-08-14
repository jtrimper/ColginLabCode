% equalPlot_max('inFile.txt',scale_max)
%
% equalPlot generates ratemaps, plots them and store them to images.
% Multiple session will be read and the maximum rate for a cell will be
% used for plotting in all sessions.
%
% v2 incldes exclusion criteria for when the mouse isn't running fast enough,
% to eliminate reward location place cells

% The input file must be on the following format.
%
% C:\Data\TTList.txt
% C:\Data\Begin 1
% C:\Data\Begin 2
% C:\Data\Begin 3
% C:\Data\Begin 4
% and so on ...
%
% The first line specifie the directory to the first session and also the
% name on the t-file list that will be used for all the sessions listed. 
% The t-file list must contain the Mclust t-files, one name for each file. 
% If the list contain cells that only occure in some of the sessions, these
% cells will be plotted as having zero firing rate when missing. Placefield
% images will be stored to both bmp and eps imagefiles to a subdirectory in
% the data folder called placeFieldImages.

function [rateMaps,timeMaps,peakRate,mapAxis,sessions,F,pathCoord,timeStamps] ...
    = equalPlot_RM_step1_rotate_cz(inFile,session_period,rorate_para,scale,sLength,bins,h)
% Step1:Just caculate the ratemaps

% sLength = 100; % Side length in cm
% bins = 20; % Number of bins
% scalex = 0.3;% Conversion from pixels to cm, frame is 640 by 480
% scaley = 0.34;
if length(scale)==1
    scalex=scale;
    scaley=scale;
else
    scalex=scale(1);
    scaley=scale(2);
end
%scale = 0.5;% Conversion from pixels to cm, frame is 640 by 480
% h = 4; % Smoothing factor when calculating the ratemap
img_text = 'on';

fid = fopen(inFile,'r');
if fid == -1
    msgbox('Could not open the input file! Make sure the filname and path are correct.','ERROR');
end

% Get sessions and t-file list from input file
ii = 0;
currentdir=pwd;
while ~feof(fid)
    str = fgetl(fid);
    if ii == 0
        ttList = strcat(currentdir,'\',str);
    else
        if ~strcmp(str(end),'\')
            str = strcat(str,'\');
        end
        sessions(ii) = {strcat(currentdir,'\',str)};
    end
    ii = ii+1;
end
numsession = ii-1;  
fclose(fid);

% read the file names from the t-file list
F = ReadFileList(ttList);
% Number of cells/files in the list
numCells = length(F);


% Set the field selection for reading the video files. 1 = Add parameter, 0 = skip
% parameter
fieldSelection(1) = 1; % Timestamps
fieldSelection(2) = 1; % Extracted X
fieldSelection(3) = 1; % Extracted Y
fieldSelection(4) = 0; % Extracted Angel
fieldSelection(5) = 0; % Targets
fieldSelection(6) = 0; % Points
% Do we return header 1 = Yes, 0 = No.
extractHeader = 0;
% 5 different extraction modes, see help file for Nlx2MatVt
extractMode = 1; % Extract all data

% Read the input data
binWidth = sLength/bins;
timeMaps = cell(numsession,1);  % == counter is the number of sessions ==
pathCoord = cell(numsession,3); 
rateMaps = cell(numsession,numCells); % == numCells is the number of clusters ==
timeStamps = cell(numsession,numCells);
mapAxis = (-sLength/2+binWidth/2):binWidth:(sLength/2-binWidth/2);
peakRate = zeros(numsession,numCells);

if numCells==1 && max(F{1}==-1)
    % no cells in ttlistelse
    rateMaps={};
    timeMaps={};
    peakRate=[];
    timeStamps={};
    return
end

% center the box to the average center or all sessions
t_all=[];
x_all=[];
y_all=[];
T=cell(numsession,1);
X=cell(numsession,1);
Y=cell(numsession,1);
count=zeros(numsession,1);
for ii = 1:numsession
    % Get position data
    file = strcat(sessions{ii},'vt1.nvt');
    vfs=29.97;  % ======= the sample frequency of video ========
    coords=read_in_coords_box(file);
    t=coords(:,1)';
    x=coords(:,2)';
    y=coords(:,3)';
% 	[t,x,y] = loadPos_rescaled_cz(file,scalex,scaley,vfs);
    if t(end)-t(1) > session_period
        t0=t(1)+session_period;
        delta=abs(t-t0);
        t0_ind=find(delta==min(delta));
        t=t(1:t0_ind);
        x=x(1:t0_ind);
        y=y(1:t0_ind);
    end
    % == t is the timestamp of vedio, x and y is locations ==
%     y = -y;  % == NOTE! The y value in the vedio is reversed ==
    
    count(ii)=length(t);
    t_all=[t_all,t];
    x_all=[x_all,x];
    y_all=[y_all,y];    
end
[x_all,y_all] = centreBox(x_all,y_all);    % == make each image in the center of the plot ==

% rotate the pathway
if rorate_para==0
    % don't rotate
elseif rorate_para==1
    x1_all=x_all;y1_all=-y_all;x2_all=y1_all;y2_all=x1_all;
    x_all=x2_all;y_all=y2_all;
elseif rorate_para==2
    x1_all=-x_all;y1_all=y_all;
    x_all=x1_all;y_all=y1_all;
elseif rorate_para==3
    x1_all=-x_all;y1_all=-y_all;x2_all=y1_all;y2_all=x1_all;
    x_all=x2_all;y_all=y2_all;
elseif rorate_para==4
    x1_all=-x_all;y1_all=-y_all;
    x_all=x1_all;y_all=y1_all;
end

count0=0;
for ii = 1:numsession
    T{ii}=t_all(count0+1:count0+count(ii));
    X{ii}=x_all(count0+1:count0+count(ii));
    Y{ii}=y_all(count0+1:count0+count(ii));
    count0=count0+count(ii);
end
for ii = 1:numsession  % == sessions numbers ==
    disp(sprintf('%s%s','Reading data for session: ',sessions{ii}));

    t=T{ii};
    x=X{ii};
    y=Y{ii};
    
    timelimit = 100;
    vel0=speed2D(x,y,t); %velocity in cm/s
    vel0(vel0>=timelimit) = 0.5*(vel0(circshift((vel0>=timelimit),-3)) + vel0(circshift((vel0>=timelimit),3)));
    
%     index the running speed
%     ind_run = find(vel0>3); %run is faster than 3cm/s
%     x_run = x(ind_run);
%     y_run = y(ind_run);
%     t_run = t(ind_run);
%     ind_rest = find(vel0<3); %rest is slower than 3cm/s
    
    % Calculate the time map for this session
     timeMaps{ii,1} = findTimeMap(x,y,t,bins,sLength,binWidth);
    % == timeMaps{ii,1} is the bins*bins matrix, where each value is the average time period in each bin ==
    
    % Store path
%     pathCoord{ii,1} = x;
%     pathCoord{ii,2} = y;
%     pathCoord{ii,3} = t;
    % in case there is NaN in position data
    indpos=find(~isnan(x));
    x = x(indpos);
    y = y(indpos);
    t = t(indpos);
    
      
    pathCoord{ii,1} = x;
    pathCoord{ii,2} = y;
    pathCoord{ii,3} = t;
    % END COMPUTING POSITION DATA
    
    % Read the spike data, but must look out for files in the list that
    % don't exist for this session
    dirFiles = dir(sessions{ii});   % Files in directory
    NaFile = cell(1,length(F)); % Store non existing file names here
    NaFileCounter = 0;          % Counts number of non existing files
    for cc=1:length(F)
        I = strmatch(char(F(cc)),char(dirFiles.name),'exact'); % Try to find file in dir
        % == I is the number of line where F(cc) occurs in dirFiles ==
        if isempty(I) % File is non existing
            NaFileCounter = NaFileCounter + 1;
            NaFile(1,NaFileCounter) = F(cc);
        end
    end
    NaFile = NaFile(1,1:NaFileCounter);

    % Load data from the cut files generated by Mclust
    S = loadSpikes_CZ(F,sessions{ii},NaFile);
    disp('Start calculating the ratemaps for the cells');
    for jj=1:numCells
        disp(sprintf('%s%i',' Cell ',jj));
        if ~isa(S{jj},'ts') % Empty cell in this session
            map = zeros(bins);
            ts = 1e64; % use a single ridicilous time stamp if the cell is silent
        else
            % Convert t-file data to timestamps in second
            ts = Data(S{jj}) / 10000;
            if ts(end)-ts(1) > session_period
                t0=t(1)+session_period;
                delta=abs(ts-t0);
                t0_ind=find(delta==min(delta));
                ts=ts(1:t0_ind);
            end
            % Get position to spikes
            [spkx,spky] = spikePos(ts,x,y,t);
            % Calculate rate map
            map = ratemap_cz(spkx,spky,x,y,t,h,mapAxis,vfs);
        end
         rateMaps{ii,jj} = map;
         peakRate(ii,jj) = max(max(map));
         timeStamps{ii,jj} = ts;
        
    end
end
disp('Plot maps and store them to files');

fieldAxis = linspace(-sLength/2,sLength/2,bins+1);

peakRate

% Remove unvisited parts of the box from the map
for ii = 1:numsession
    for jj=1:numCells
        if length(rateMaps{ii,jj})>1
            rateMaps{ii,jj}(timeMaps{ii}==0) = NaN;
        end
    end
end

%__________________________________________________________________________
%
% Field functions
%__________________________________________________________________________

% timeMap will find the amount of time the rat spends in each bin of the
% box. The box is divided into the same number of bins as in the rate map.
% posx, posy, post: Path coordinates and time stamps.
% bins: Number of bins the box is diveded int (bins x bins)
% extremal: minimum and maximum positions.
function timeMap = findTimeMap(posx,posy,post,bins,sLength,binWidth)

% Duration of trial
duration = post(end)-post(1);
% Average duration of each position sample
sampDur = duration/length(posx);

% X-coord for current bin position
pcx = -sLength/2-binWidth/2;
timeMap = zeros(bins);
% Find number of position samples in each bin
for ii = 1:bins
    % Increment the x coordinate
    pcx = pcx + binWidth;
    I = find(posx >= pcx & posx < pcx+binWidth);
    % Y-coord for current bin position
    pcy = -sLength/2-binWidth/2;
    for jj=1:bins
        % Increment the y coordinate
        pcy = pcy + binWidth;
        J = find(posy(I) >= pcy & posy(I) < pcy+binWidth);
        % Number of position samples in the current bin
        timeMap(jj,ii) = length(J);
    end
end
% Convert to time spent in bin
timeMap = timeMap * sampDur;


% Calculates the rate map.
function map = ratemap_cz(spkx,spky,posx,posy,post,h,mapAxis,vfs)
invh = 1/h; % h > 0 is a smoothing parameter called the bandwidth
map = zeros(length(mapAxis),length(mapAxis));
yy = 0;
for y = mapAxis
    yy = yy + 1;
    xx = 0;
    for x = mapAxis
        xx = xx + 1;
        map(yy,xx) = rate_estimator_cz(spkx,spky,x,y,invh,posx,posy,post,vfs);
    end
end

% Calculate the rate for one position value
function r = rate_estimator_cz(spkx,spky,x,y,invh,posx,posy,post,vfs)
% edge-corrected kernel density estimator
n_post=length(post);
post0=1/vfs:1/vfs:n_post/vfs;
conv_sum = sum(gaussian_kernel(((spkx-x)*invh),((spky-y)*invh)));
edge_corrector =  trapz(post0,gaussian_kernel(((posx-x)*invh),((posy-y)*invh)));
%edge_corrector(edge_corrector<0.15) = NaN;
r = (conv_sum / (edge_corrector + 0.01)) + 0.01; % regularised firing rate for "wellbehavedness"
                                                       % i.e. no division by zero or log of zero
% Gaussian kernel for the rate calculation
function r = gaussian_kernel(x,y)
% k(u) = ((2*pi)^(-length(u)/2)) * exp(u'*u)
r = 0.15915494309190 * exp(-0.5*(x.*x + y.*y));


% Finds the position to the spikes
function [spkx,spky] = spikePos(ts,posx,posy,post)
N = length(ts);
spkx = zeros(N,1);
spky = zeros(N,1);
for ii = 1:N
    tdiff = (post-ts(ii)).^2;
    [m,ind] = min(tdiff);
    spkx(ii) = posx(ind(1));
    spky(ii) = posy(ind(1));
end

%__________________________________________________________________________
%
% Function for modifing the path
%__________________________________________________________________________

% Median filter for positions
function [posx,posy,post] = medianFilter(posx,posy,post)
N = length(posx);
x = [NaN*ones(15,1); posx'; NaN*ones(15,1)];
y = [NaN*ones(15,1); posy'; NaN*ones(15,1)];
X = ones(1,N);
Y = ones(1,N);
for cc=16:N+15
    lower = cc-15;
    upper = cc+15;
    X(cc-15) = nanmedian(x(lower:upper));
    Y(cc-15) = nanmedian(y(lower:upper));
end
index = find(isfinite(X));
posx=X(index);
posy=Y(index);
post=post(index);

% Removes position values that are a result of bad tracking
function [posx,posy,post] = offValueFilter(posx,posy,post)

x1 = posx(1:end-1);
x2 = posx(2:end);
y = posy(2:end);
t = post(2:end);

N = 1;
while N > 0
    len = length(x1);
    dist = abs(x2 - x1);
    % Finds were the distance between two neighbour samples are more than 2
    % cm.
    ind = find(dist > 2);
    N = length(ind);
    if N > 0
        if ind(1) ~= len
            x2(:,ind(1)) = [];
            x1(:,ind(1)+1) = [];
            y(:,ind(1)) = [];
            t(:,ind(1)) = [];
        else
            x2(:,ind(1)) = [];
            x1(:,ind(1)) = [];
            y(:,ind(1)) = [];
            t(:,ind(1)) = [];
        end
    end
end
x = x2(2:end);
t = t(2:end);
y1 = y(1:end-1);
y2 = y(2:end);

N = 1;
while N > 0
    len2 = length(y1);
    dist = abs(y2 - y1);
    ind = find(dist > 3);
    N = length(ind);
    if N > 0
        if ind(1) ~= len2
            y2(:,ind(1)) = [];
            y1(:,ind(1)+1) = [];
            x(:,ind(1)) = [];
            t(:,ind(1)) = [];
        else
            y2(:,ind(1)) = [];
            y1(:,ind(1)) = [];
            x(:,ind(1)) = [];
            t(:,ind(1)) = [];
        end
    end
end
posx = x;
posy = y2;
post = t;

% Centre the path/box for the two sessions. Both boxes are set according to
% the path/coordinates to the box for the first session.
function [posx,posy] = centreBox(posx,posy)

% Find border values for box for session 1
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
% Centre both boxes according to the coordinates to the first box
posx = posx - centre(1);
posy = posy - centre(2);


% Calculates the centre of the box from the corner coordinates
function centre = findCentre(NE,NW,SW,SE);

% The centre will be at the point of interception by the corner diagonals
a = (NE(2)-SW(2))/(NE(1)-SW(1)); % Slope for the NE-SW diagonal
b = (SE(2)-NW(2))/(SE(1)-NW(1)); % Slope for the SE-NW diagonal
c = SW(2);
d = NW(2);
x = (d-c+a*SW(1)-b*NW(1))/(a-b); % X-coord of centre
y = a*(x-SW(1))+c; % Y-coord of centre
centre = [x,y];


%__________________________________________________________________________
%
% Additional graphics function
%__________________________________________________________________________

function drawfield(map,faxis,cmap,maxrate,cellid,cell_file,text)
   
   % This function will calculate an RGB image from the rate
   % map. We do not just call image(map) and caxis([0 maxrate]),
   % as it would plot unvisted parts with the same colour code
   % as 0 Hz firing rate. Instead we give unvisited bins
   % their own colour (e.g. gray or white).

   maxrate = ceil(maxrate);
   if maxrate < 1
      maxrate = 1;
   end
   n = size(map,1);
   plotmap = ones(n,n,3);
   for jj = 1:n
      for ii = 1:n
         if isnan(map(jj,ii))
            plotmap(jj,ii,1) = 1; % give the unvisited bins a gray colour
            plotmap(jj,ii,2) = 1; %KJ changed from 1 1 1
            plotmap(jj,ii,3) = 1;
         else
             if (map(jj,ii) > maxrate)
                 plotmap(jj,ii,1) = 1; % give the unvisited bins a gray colour
                 plotmap(jj,ii,2) = 0;
                 plotmap(jj,ii,3) = 0;
             else    
                 rgb = pixelcolour(map(jj,ii),maxrate,cmap);
                 plotmap(jj,ii,1) = rgb(1);
                 plotmap(jj,ii,2) = rgb(2);
                 plotmap(jj,ii,3) = rgb(3);
             end
         end
      end
   end
   image(faxis,faxis,plotmap);
   set(gca,'YDir','Normal');
   axis image;
   axis off
   if strcmp(text,'on')
       title(strcat(cellid,'-',cell_file,'(',num2str(maxrate),' Hz)'),'FontSize',60);
       %title(strcat(cellid,'?0 - ',num2str(maxrate), ' Hz)','?,cell_file),'FontSize',20);
   end


function rgb = pixelcolour(map,maxrate,cmap)

   % This function calculates a colour for each bin
   % in the rate map.

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
      rgb = cmap1(steps,:);
   else
      steps = (31*(map/maxrate))+1;
      steps = round(steps);
      rgb = cmap2(steps,:);
   end
   
%__________________________________________________________________________
%
%      Functions for reading Mclust data
%__________________________________________________________________________
   
function S = LoadSpikes(tfilelist, path, NaFile)
% tfilelist:    List of t-files. Each file contains a cluster of spikes
%               from a cell.
% path:         Path to the directory were the t-files are stored
% NaFile:       List of file names in tfilelist that don't exist
%               in the current directory
%
% inp: tfilelist is a cell array of strings, each of which is a
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
fprintf(2, 'Reading %d files.', anFiles);

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
fprintf(2,'\n');


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
   while ~feof(fp) & ~strcmp(headerLine, endheader)     
      headerLine = fgetl(fp);
      iH = iH+1;
      H{iH} = headerLine;
   end
else % no header
   fseek(fp, curfpos, 'bof');
end

function spkInd = spkIndex(post,ts)
M = length(ts);
spkInd = zeros(M,1);
for ii=1:M
    tdiff = (post-ts(ii)).^2;
    [m,ind] = min(tdiff);
    spkInd(ii) = ind;
end