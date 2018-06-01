function varargout = fieldPlot(varargin)
% FIELDPLOT M-file for fieldPlot.fig
%      FIELDPLOT, by itself, creates a new FIELDPLOT or raises the existing
%      singleton*.
%
%      H = FIELDPLOT returns the handle to a new FIELDPLOT or the handle to
%      the existing singleton*.
%
%      FIELDPLOT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FIELDPLOT.M with the given input arguments.
%
%      FIELDPLOT('Property','Value',...) creates a new FIELDPLOT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before fieldPlot_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to fieldPlot_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help fieldPlot

% Last Modified by GUIDE v2.5 19-Apr-2004 10:06:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @fieldPlot_OpeningFcn, ...
                   'gui_OutputFcn',  @fieldPlot_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin & isstr(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before fieldPlot is made visible.
function fieldPlot_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to fieldPlot (see VARARGIN)



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes fieldPlot wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = fieldPlot_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes on button press in tBrowse.
function tBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to tBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.tFile,handles.tPath] = uigetfile('*.txt');
if ~strcmp(handles.tPath(end),'\')
    handles.tPath = strcat(char(handles.tPath),'\');
end
guidata(hObject,handles);
set(handles.text1,'String',strcat(handles.tPath,char(handles.tFile)));

% --- Executes on button press in vBrowse.
function vBrowse_Callback(hObject, eventdata, handles)
% hObject    handle to vBrowse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[handles.vFile,handles.vPath] = uigetfile('*.txt');
if ~strcmp(handles.vFile(end),'\')
    handles.vPath = strcat(char(handles.vPath),'\');
end
guidata(hObject,handles);
set(handles.text2,'String',strcat(handles.vPath,char(handles.vFile)));

% --- Executes on button press in exitButton.
function exitButton_Callback(hObject, eventdata, handles)
% hObject    handle to exitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.figure1);

% --- Executes on button press in goButton.
function goButton_Callback(hObject, eventdata, handles)
% hObject    handle to goButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Set the field selection for reading the video file. 1 = Add parameter, 0 = skip
% parameter
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

list = strcat(handles.tPath,char(handles.tFile));
value = strcat(handles.vPath,char(handles.vFile));

video = strcat(handles.tPath,'vt1.nvt');

% Get positon data
% TimeStamps: Time stamps in microseconds
% ExtractedX: X-coordinates of rat path
% ExtractedY: Y-coordinates of rat path
% NlxHeader:  Header information from the NeuralLynx software, may be empty.
[TimeStamps, ExtractedX, ExtractedY] = Nlx2MatVT(video,fieldSelection,extractHeader,extractMode);

% convert position TimeStamps to seconds
TimeStamps = TimeStamps/1000000;

[ExtractedX,ExtractedY,TimeStamps] = offValueFilter(ExtractedX,ExtractedY,TimeStamps);

% Do median filtering to supress off-values
[ExtractedX,ExtractedY,TimeStamps] = medianFilter(ExtractedX,ExtractedY,TimeStamps);


% Smoothing the position samples with a simple mean filter
[ExtractedX,ExtractedY] = meanFilter(ExtractedX,ExtractedY);

% Get name for trial room
val = get(handles.room, 'Value');
rooms = get(handles.room, 'String');
roomName = char(rooms(val));

% Get parameters for plotting
[centerX, centerY, scale, sLength, bins] = getRoomParameters(roomName);

% adjust xy coordinates to fit parameters for plotting
ExtractedX = (ExtractedX - centerX)*scale;
ExtractedY = (ExtractedY - centerY)*scale;

fieldAxis = linspace(-sLength/2,sLength/2,bins);

% Read the the file names from the t-file list
F = readFileList(list);
numCell = length(F);

% Read values
values = [];
fid = fopen(value,'r');
while ~feof(fid)
    line = fgetl(fid);
    values = [values;str2double(line)];
end


% The file list might contain references to non existing files
% Check what files do exist
dirFiles = dir(handles.tPath); % Files in directory
NaFile = cell(1,length(F)); % Store non existing file names here
NaFileCounter = 0; % Counts number of non existing files
for cc=1:length(F)
    I = strmatch(char(F(cc)),char(dirFiles.name),'exact'); % Try to find file in dir
    if length(I)==0 % File is non existing
        NaFileCounter = NaFileCounter + 1;
        NaFile(1,NaFileCounter) = F(cc);
    end
end
NaFile = NaFile(1,1:NaFileCounter);

    
% Load data from the cut files generated by Mclust
S = LoadSpikes(F,handles.tPath,NaFile);
nCells = length(S); % Number of cell in the list

% Analyse data for all cells
for ii=1:nCells
    filename = strcat(strrep(char(F(ii)),'.t',''),'.bmp');
    epsfilename = strcat(strrep(char(F(ii)),'.t',''),'.eps');
    PathSpikeName = strcat(strrep(char(F(ii)),'.t',''),'Path');
    temp = S{ii};
    
    if isa(temp,'ts')
        % Convert spike data to timestamps in seconds
        ts = Data(S{ii}) / 10000;
        if ~length(ts)
            ts = 1e64; % use a single ridicilous time stamp if the cell is silent
        end
        % Find rate map, sdf and pospdf
        rateMap = field(bins, sLength, ts, ExtractedX', ExtractedY', TimeStamps');
        %mapAxis = linspace(-100,100,40);
        
        % Draw the map
        figure(1)
        drawfield(rateMap,fieldAxis,'jet',values(ii),filename);
        filename = strcat(handles.tPath,filename);
        epsFilename = strcat(handles.tPath,epsfilename);
        
        % BMP
        f = getframe(gcf);
        [pic, cmap] = frame2im(f);
        imwrite(pic, filename, 'bmp');
        % EPSC
        saveas(1,epsFilename,'epsc');
    end 
end







function map = field(bins, slength, ts, posx, posy, post)
   % Estimate the spike density function by convoluting the
   % time stamps with a Blackman smoothing kernel. We will
   % sample the resulting (alias-free) SDF estimate synchronously
   % with the position recording.
   % rateMap:    Map of the spike rate
   % sdf:        Spike density function
   % pospdf:     Position probability density function
    
   posx = posx(2:end);
   posy = posy(2:end);
   dt = diff(post);
   
   n = length(posx);
   sdf = ones(n,1);
   for ii = 1:n
      t = post(ii);
      sdf(ii) = sum( blackman(t-ts,2) );
   end

   % Estimate the rate map from the positions and the
   % SDF estimate. We do this by calculating a weighted
   % mean rate for each point in the map.

   map = ones(bins,bins);
   diffpost = diff(post);
   binwidth = slength/bins;
   pcx = (-slength/2) - 0.5*binwidth;
   
   timeHere = zeros(bins,bins);
   
   for ii = 1:bins
      pcx = pcx + binwidth;
      pcy = (-slength/2) - 0.5*binwidth;
      for jj = 1:bins
         pcy = pcy + binwidth;
         distances = [posx posy] - repmat([pcx pcy],n,1);
         distances = sqrt(sum(distances.^2,2));
         weights = blackman(distances, 6*binwidth);
         sweights = sum(weights);
         if sweights > 0
      	    map(jj,ii) = sum(weights .* sdf) / sum(weights);
         else
            map(jj,ii) = NaN;
         end
         if min(distances)>binwidth % use the binwidth as threshold for defining
            map(jj,ii) = NaN;       % bins visited or unvisited
         end
         
         if ~isnan(map(jj,ii))
             timeHere(jj,ii) = sum(weights .* dt) / sum(weights);
         end
         
      end
   end

% Sets the parameters for the room in use   
function [centerX, centerY, scale, sLength, bins] = getRoomParameters(room)
   % Initialize parameters
   centerX = 0; % X-coordinate of the center of the room/box (found emperically)
   centerY = 0; % Y-coordinate
   scale = 0.25;% Conversion from pixels to cm
   sLength = 0; % Length of the sides in the rate map in cm
   bins = 0;    % Resolution of rate map (bins x bins)
    switch room
        case 'morphbox1'
            centerX = 280;
            centerY = 280;
            sLength = 150; % Length of box is 80 cm, the redundancy is to take care of the situation when the box is moved
            bins = 30; % Give resolution of 5cm x 5cm
        case 'morphbox2'
            centerX = 229;
            centerY = 250;
            sLength = 150;
            bins = 30;
    end

% Median filter
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

% Mean filter for positions
function [posx,posy] = meanFilter(posx,posy)
N = length(posx);
x = [NaN*ones(7,1); posx'; NaN*ones(7,1)];
y = [NaN*ones(7,1); posy'; NaN*ones(7,1)];
X = ones(1,N);
Y = ones(1,N);
for cc=8:N+7
    lower = cc-7;
    upper = cc+7;
    X(cc-7) = nanmean(x(lower:upper));
    Y(cc-7) = nanmean(y(lower:upper));
end
posx = X;
posy = Y;

% Removes position values that are outside the box
function [posx,posy,post] = offValueFilter(posx,posy,post)
medianx = median(posx)
mediany = median(posy)

index = find(posx > (medianx-200) & posx < (medianx+200));
posx = posx(index);
posy = posy(index);
post = post(index);

index = find(posy > (mediany-200) & posy < (mediany+200));
posx = posx(index);
posy = posy(index);
post = post(index);


function [cX,cY] = getCentre(posx,posy)
% Find border values for box
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
cX = centre(1); % X-coord of centre
cY = centre(2); % Y-coord of centre



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


% --- Executes during object creation, after setting all properties.
function room_CreateFcn(hObject, eventdata, handles)
% hObject    handle to room (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in room.
function room_Callback(hObject, eventdata, handles)
% hObject    handle to room (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns room contents as cell array
%        contents{get(hObject,'Value')} returns selected item from room


% Blackman lowpass filter   
function y = blackman(x,s)
   % Blackman kernel
   loc = (x>(-s/2)) & (x<(s/2));
   y = 0.42 - 0.5*cos(2*pi*(x + s/2)/s) + 0.08*cos(4*pi*(x + s/2)/s);
   y = y .* loc;
   ly = y / (0.42*s); % normalise by the integral so the convolution
                      % estimates the SDF


function drawfield(map,faxis,cmap,maxrate,cellid)
   
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
            plotmap(jj,ii,1) = .8; % give the unvisited bins a gray colour
            plotmap(jj,ii,2) = .8;
	    plotmap(jj,ii,3) = .8;
         else
            rgb = pixelcolour(map(jj,ii),maxrate,cmap);
            plotmap(jj,ii,1) = rgb(1);
            plotmap(jj,ii,2) = rgb(2);
            plotmap(jj,ii,3) = rgb(3);
         end
      end
   end
   image(faxis,faxis,plotmap);
   set(gca,'YDir','Normal');
   axis image;
   title(strcat(cellid,'¤(0 - ',num2str(maxrate), ' Hz)'));


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
       