function varargout = CSC_analyse(varargin)
% CSC_ANALYSE M-file for CSC_analyse.fig
%      CSC_ANALYSE, by itself, creates a new CSC_ANALYSE or raises the existing
%      singleton*.
%
%      H = CSC_ANALYSE returns the handle to a new CSC_ANALYSE or the handle to
%      the existing singleton*.
%
%      CSC_ANALYSE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CSC_ANALYSE.M with the given input arguments.
%
%      CSC_ANALYSE('Property','Value',...) creates a new CSC_ANALYSE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CSC_analyse_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CSC_analyse_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CSC_analyse

% Last Modified by GUIDE v2.5 26-Feb-2004 12:38:25

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CSC_analyse_OpeningFcn, ...
                   'gui_OutputFcn',  @CSC_analyse_OutputFcn, ...
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


% --- Executes just before CSC_analyse is made visible.
function CSC_analyse_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CSC_analyse (see VARARGIN)


% Add the total file path to the file to be analysed into the handles
% structure
handles.filePath = varargin{1};
handles.fileList = varargin{2};
% CSC data is not yet loaded
handles.loaded = 0;
% Position data is not yet loaded
handles.posData = 0;
% No velocity plots has been generated, and velocity has not been
% calculated
handles.velocityCalc = 0;
% No spike plots has been generated, and spikes has not been loaded.
handles.spikeCalc = 0;
% Update handles structure
guidata(hObject, handles);

str = sprintf('%s%s','Working directory: ',char(handles.filePath));
set(handles.infoText1, 'String', str);
% Display status
set(handles.infoText3,'String', 'STATUS: Ready');

% UIWAIT makes CSC_analyse wait for user response (see UIRESUME)
uiwait(handles.CSC_analyse);


% --- Outputs from this function are returned to the command line.
function varargout = CSC_analyse_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- Executes during object creation, after setting all properties.
function chSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in chSelect.
function chSelect_Callback(hObject, eventdata, handles)
% hObject    handle to chSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% User has chosen a different tetrode. CSC data for this tetrode must now
% be loaded
handles.loaded = 0;
guidata(hObject,handles);

% --- Executes on button press in cscButton. This will display the plot of
% the CSC data.
function cscButton_Callback(hObject, eventdata, handles)
% hObject    handle to cscButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check if user has change the tetrode number
if ~handles.loaded % Yes, change is done. Must load data.
    
    set(handles.infoText2,'String', 'Loading .');
    % Get file path
    filepath = char(handles.filePath);
    if ~strcmp(filepath(end),'\')
        filepath = strcat(filepath,'\');
    end
    % Get chosen tetrode
    index = get(handles.chSelect, 'Value'); % Index of chosen values
    tetrodeValues = get(handles.chSelect, 'String'); % Possible choices in list
    tetrode = char(tetrodeValues(index)); % Chosen tetrode
    % Generate filename
    filename = sprintf('%s%s%s','CSC',tetrode,'.Ncs');
    % Path and name to file
    fileName = strcat(filepath,filename);
    % Set the field selection for reading CSC files. 1 = Add parameter, 0 = skip
    % parameter
    fieldSelection(1) = 1; % Timestamps
    fieldSelection(2) = 1; % Channel number
    fieldSelection(3) = 1; % Sample Frequency
    fieldSelection(4) = 1; % Number of valid samples
    fieldSelection(5) = 1; % Samples
    % Do we return header 1 = Yes, 0 = No.
    extractHeader = 1;
    % 5 different extraction modes, see help file for Nlx2MatCSC
    extractMode = 1; % Extract all data

    % **** Read CSC file ***
    % Samples is a 2-D matrix, NlxHeader is a 1-D cell array and the rest are
    % 1-D arrays.
    [handles.timestamps, handles.chanNum, handles.sampleFreq, handles.numValSamples, handles.samples, handles.NlxHeader] = ...
        Nlx2MatCSC(fileName,fieldSelection,extractHeader, extractMode);
    handles.loaded = 1;
    % Update handles structure
    guidata(hObject, handles);
    set(handles.infoText2,'String', 'Loading . .');
    % First registered timestamp
    minTime = handles.timestamps(1) / 1.0e6;
    % Last timestamp
    maxTime = handles.timestamps(end) / 1.0e6;
    % Duration of trial
    handles.duration = maxTime - minTime;
    % Data is loaded
    handles.loaded = 1;
    % Update handles structure
    guidata(hObject, handles);
 
    % Display what tetrode is chosen by the user
    set(handles.infoText2,'String',sprintf('%s%s','Analysing data for tetrode ',tetrode));
    % Display trial length in GUI
    set(handles.loadText,'String', sprintf('%s%4.1f%s','The length of this trial is ',handles.duration,' seconds'));
end
    
% Display status
set(handles.infoText3,'String', 'STATUS: Generating plot');
totalNumValidSamples = sum(handles.numValSamples); % Total number of valid samples in this trial
% Last registered timestamp
maxTime = handles.timestamps(end) / 1.0e6; % Timestamps are in microseconds
% First registered timestamp
minTime = handles.timestamps(1) / 1.0e6;
% Number of samples pr sec, will aproximate the sampleFreq
sampSec = totalNumValidSamples/(maxTime-minTime);    

% Get to/from values set by user
from = str2double(get(handles.fromEdit,'String'));
to =  str2double(get(handles.toEdit,'String'));
 
% Last registered timestamp
maxTime = handles.timestamps(end) / 1.0e6; % Timestamps are in microseconds
% First registered timestamp
minTime = handles.timestamps(1) / 1.0e6;
% Number of samples pr sec, will aproximate the sampleFreq
sampSec = totalNumValidSamples/(maxTime-minTime);

% Convert seconds to samples and change input values if these are invalid
if from <= 0
    from = 1;
    set(handles.fromEdit,'String',0);
else
    from = floor(from*sampSec);
end
if from >= totalNumValidSamples
    from = totalNumValidSamples - 1;
    fromTime = sprintf('%5.1f',from/sampSec);
    set(handles.fromEdit,'String',fromTime);
end
to = round(to*sampSec);
if to<=from
    to = from+1;
    toTime = sprintf('%5.1f',to/sampSec);
    set(handles.toEdit, 'String', toTime);
end
if to > totalNumValidSamples
    to = totalNumValidSamples;
    toTime = sprintf('%5.1f',to/sampSec);
    set(handles.toEdit, 'String', toTime);
end
fromSec = 0;
toSec = 0;
if from == 1
    fromSec = 0;
else
    froSed = from/sampSec;
end
if to == 2
    toSec = 0.1
else
   toSec = to/sampSec;
end

% Display status
set(handles.infoText3,'String', 'STATUS: Plotting CSC');
% Plot data
axes(handles.cscPlot);
plot(handles.samples(from:to));
xlabel('Samples');
ylabel('Amplitude');
% Information about the axes of the plot
str = sprintf('%s%3.1f%s%3.1f%s%5.2f%s','Plot of CSC data from ',fromSec,' sec to ',toSec,' sec. There are in this trial ',sampSec,' samples pr second');
set(handles.plotText, 'String', str);
% Display status
set(handles.infoText3,'String', 'STATUS: Ready');


% --- Executes during object creation, after setting all properties.
function fromEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fromEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function fromEdit_Callback(hObject, eventdata, handles)
% hObject    handle to fromEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fromEdit as text
%        str2double(get(hObject,'String')) returns contents of fromEdit as a double


% --- Executes during object creation, after setting all properties.
function toEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to toEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end

function toEdit_Callback(hObject, eventdata, handles)
% hObject    handle to toEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of toEdit as text
%        str2double(get(hObject,'String')) returns contents of toEdit as a double


% --- Executes on button press in spikeButton. This will generate plot of
% spikes in the files specified by the chosen t-file list
function spikeButton_Callback(hObject, eventdata, handles)
% hObject    handle to spikeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~handles.posData % Position data has not been loaded
    set(handles.infoText3,'String', 'STATUS: Loading position data.');
    % Get file path
    filepath = char(handles.filePath);
    if ~strcmp(filepath(end),'\')
        filepath = strcat(filepath,'\');
    end
    % Video file to be opened
    videoFile = strcat(filepath,'VT1.Nvt');
    % Set the field selection for reading the video file. 1 = Add parameter, 0 = skip
    % parameter
    fieldSelection(1) = 1; % Timestamps
    fieldSelection(2) = 1; % Extracted X
    fieldSelection(3) = 1; % Extracted Y
    fieldSelection(4) = 0; % Extracted Angel
    fieldSelection(5) = 0; % Targets
    fieldSelection(6) = 0; % Points
    % Do we return header? 1 = Yes, 0 = No.
    extractHeader = 0;
    % 5 different extraction modes, see help file for Nlx2MatCSC
    extractMode = 1; % Extract all data
    
    % Get positon data
    % TimeStamps: Time stamps in microseconds
    % ExtractedX: X-coordinates of rat path
    % ExtractedY: Y-coordinates of rat path
    [handles.posTime,handles.ExtractedX, handles.ExtractedY] = Nlx2MatVT(videoFile,fieldSelection,extractHeader,extractMode);
    % convert position TimeStamps to seconds
    handles.posTime = handles.posTime/1000000;

    handles.posData = 1; % Position data is finished loading
end

if ~handles.spikeCalc % This is the first plot of the spikes, and data must be loaded
    set(handles.infoText3,'String', 'STATUS: Loading spike data.');
    % Get file path
    filepath = char(handles.filePath);
    if ~strcmp(filepath(end),'\')
        filepath = strcat(filepath,'\');
    end
    % whole path to file
    filelist = strcat(filepath,char(handles.fileList));
    % Read the file name in the t-file list
    F = ReadFileList(filelist);
    % The file list might contain references to non existing files
    % Check what files do exist
    dirFiles = dir(filepath); % Files in directory
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
    handles.S = LoadSpikes(F,char(handles.filePath),NaFile);
    handles.nCells = length(handles.S); % Number of cell in the list
    handles.spikeCalc = 1; % Spike data is finished loaded
    % Cell array to put the time stamps for each cell
    handles.spikeTS = cell(handles.nCells,1); 
    % start and end time stamp for each cell
    startSpike = [];
    endSpike = [];
    for ii=1:handles.nCells
        % Fill in the time stamps (1 stamp for each spike)
        handles.spikeTS(ii,1) = {Data(handles.S{ii})/10000}; % convert timestamp to seconds
        startSpike = [startSpike; handles.spikeTS{ii}(1)];
        endSpike = [endSpike; handles.spikeTS{ii}(end)];
        % Make the timestamp array begin on 0 sec, using the start time in
        % the position time stamp array
        handles.spikeTS(ii,1) = {handles.spikeTS{ii,1}(1:end)-handles.posTime(1)};
    end
    
    % Display trial length in GUI
    if ~handles.loaded
        % Set the approximate duration of trial
        handles.duration = max(endSpike) - min(startSpike);
        set(handles.loadText,'String', sprintf('%s%4.1f%s','The length of this trial is ',handles.duration,' seconds'));
    end
    % Update the handles structure
    guidata(hObject,handles);
    
end
set(handles.infoText3,'String', 'STATUS: Plotting spike data.');
% Get time span from user input
from = str2double(get(handles.fromEdit,'String'));
to =  str2double(get(handles.toEdit,'String'));

% Do boundary check on user input
if from < 0
    from = 0;
    set(handles.fromEdit,'String',0);
end
if from >= handles.duration
    from = handles.duration - 0.1;
    fromTime = sprintf('%5.1f',from);
    set(handles.fromEdit,'String',fromTime);
end
if to<=from
    to = from+0.1;
    toTime = sprintf('%5.1f',to);
    set(handles.toEdit, 'String', toTime);
end
if to > handles.duration
    to = handles.duration;
    toTime = sprintf('%5.1f',to);
    set(handles.toEdit, 'String', toTime);
end
axes(handles.spikePlot);
axis([from to 0 handles.nCells+1]);
% Find spikes for all cells that is within the specified time span
for ii = 1:handles.nCells
    index = find(handles.spikeTS{ii,1}(1:end)>=from & handles.spikeTS{ii,1}(1:end)<=to);
    for jj=1:length(index)
        plot(handles.spikeTS{ii,1}(index(jj)),ii,'r.');
        hold on;
    end
end
hold off;
ylabel('Cell number');
xlabel('Time of spike [s]');
set(handles.spikeText,'String',sprintf('%s%3.1f%s%3.1f%s','Plot of spikes from ',from,' sec to ',to,' sec'));
set(handles.infoText3,'String', 'STATUS: Ready');



% --- Executes on button press in velocityButton. This will plot the
% velocity of the rat.
function velocityButton_Callback(hObject, eventdata, handles)
% hObject    handle to velocityButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~handles.posData % Position data has not been loaded
    set(handles.infoText3,'String', 'STATUS: Loading position data.');
    % Get file path
    filepath = char(handles.filePath);
    if ~strcmp(filepath(end),'\')
        filepath = strcat(filepath,'\');
    end
    % Video file to be opened
    videoFile = strcat(filepath,'VT1.Nvt');
    % Set the field selection for reading the video file. 1 = Add parameter, 0 = skip
    % parameter
    fieldSelection(1) = 1; % Timestamps
    fieldSelection(2) = 1; % Extracted X
    fieldSelection(3) = 1; % Extracted Y
    fieldSelection(4) = 0; % Extracted Angel
    fieldSelection(5) = 0; % Targets
    fieldSelection(6) = 0; % Points
    % Do we return header? 1 = Yes, 0 = No.
    extractHeader = 0;
    % 5 different extraction modes, see help file for Nlx2MatCSC
    extractMode = 1; % Extract all data
    
    % Get positon data
    % TimeStamps: Time stamps in microseconds
    % ExtractedX: X-coordinates of rat path
    % ExtractedY: Y-coordinates of rat path
    [handles.posTime,handles.ExtractedX, handles.ExtractedY] = Nlx2MatVT(videoFile,fieldSelection,extractHeader,extractMode);
    % convert position TimeStamps to seconds
    handles.posTime = handles.posTime/1000000;
    handles.posData = 1; % Position data is finished loading
end
    
    if ~handles.velocityCalc % This is the first velocity plot, and velocity must be calculated
        set(handles.infoText3,'String', 'STATUS: Calculating velocity . .');
        % Ignore invalid points, the algorithm does not need interpolation
        ValidIndex = find(handles.ExtractedX > 0 & handles.ExtractedY > 0);
        handles.ExtractedX = handles.ExtractedX(ValidIndex);
        handles.ExtractedY = handles.ExtractedY(ValidIndex);
        handles.posTime = handles.posTime(ValidIndex);
   
        % Smoothing the position samples with a simple mean filter
        for cc=8:length(handles.ExtractedX)-7
            handles.ExtractedX(cc) = nanmean(handles.ExtractedX(cc-7:cc+7));
            handles.ExtractedY(cc) = nanmean(handles.ExtractedY(cc-7:cc+7));
        end
        set(handles.infoText3,'String', 'STATUS: Calculating velocity . . .');
        % Want velocity in cm/s
        % Scaling value is 0.25 -> 4 pixels pr cm
        handles.ExtractedX = handles.ExtractedX * 0.25;
        handles.ExtractedY = handles.ExtractedY * 0.25;
        % Calculate the velocity of the rat
        handles.velocity = zeros(10,1); % Set velocity to zero for the first 10 samples
        for ii=11:length(handles.posTime)-10
            v = (sqrt((handles.ExtractedX(ii+10)-handles.ExtractedX(ii-10))^2+(handles.ExtractedY(ii+10)-handles.ExtractedY(ii-10))^2)/...
                (handles.posTime(ii+10)-handles.posTime(ii-10)));
            handles.velocity = [handles.velocity; v];
        end
        % Set last 10 samples to zero velocity
        for ii=1:10
            handles.velocity = [handles.velocity; 0];
        end
        handles.velocityCalc = 1;
    % Update handles structure
    guidata(hObject, handles);
    end

set(handles.infoText3,'String', 'STATUS: Plotting Velocity');    
from = str2double(get(handles.fromEdit,'String'));
to =  str2double(get(handles.toEdit,'String'));

 
% Last registered timestamp
maxTime = handles.posTime(end); % Timestamps are in microseconds
% First registered timestamp
minTime = handles.posTime(1);
% Number of samples pr sec, will aproximate the sampleFreq
sampSec = length(handles.ExtractedX)/(maxTime-minTime);
% Adjust the time stamps to begin on 0 s. For plotting purpose
timestamps = handles.posTime - minTime;
   
% Convert seconds to samples and change input values if these are invalid
if from <= 0
    from = 1;
    set(handles.fromEdit,'String',0);
else
    from = floor(from*sampSec);
end
if from >= length(handles.posTime)
    from = handles.posTime - 1;
    fromTime = sprintf('%5.1f',from/sampSec);
    set(handles.fromEdit,'String',fromTime);
end
to = round(to*sampSec);
if to<=from
    to = from+1;
    toTime = sprintf('%5.1f',to/sampSec);
    set(handles.toEdit, 'String', toTime);
end
if to > length(handles.posTime)
    to = length(handles.posTime);
    toTime = sprintf('%5.1f',to/sampSec);
    set(handles.toEdit, 'String', toTime);
end
fromSec = 0;
toSec = 0;
if from == 1
    fromSec = 0;
else
    fromSec = from/sampSec;
end
if to == 2
    toSec = 0.1
else
    toSec = to/sampSec;
end

axes(handles.velocityPlot);
axis([from to min(handles.velocity)-0.5 max(handles.velocity)+0.5]);
plot(timestamps(from:to),handles.velocity(from:to));
set(handles.velocityText,'String',sprintf('%s%3.1f%s%3.1f%s','Plot of velocity from ',fromSec,' sec to ',toSec,' sec'));
xlabel('Time in seconds');
ylabel('Velocity [cm/s]');
set(handles.infoText3,'String', 'STATUS: Ready');


% --- Executes on button press in exitButton.
function exitButton_Callback(hObject, eventdata, handles)
% hObject    handle to exitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

delete(handles.CSC_analyse);
