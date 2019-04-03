function varargout = correlationGUI(varargin)
% CORRELATIONGUI M-file for correlationGUI.fig
%      CORRELATIONGUI, by itself, creates a new CORRELATIONGUI or raises the existing
%      singleton*.
%
%      H = CORRELATIONGUI returns the handle to a new CORRELATIONGUI or the handle to
%      the existing singleton*.
%
%      CORRELATIONGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CORRELATIONGUI.M with the given input arguments.
%
%      CORRELATIONGUI('Property','Value',...) creates a new CORRELATIONGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before correlationGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to correlationGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help correlationGUI

% Last Modified by GUIDE v2.5 23-Feb-2004 10:26:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @correlationGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @correlationGUI_OutputFcn, ...
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


% --- Executes just before correlationGUI is made visible.
function correlationGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to correlationGUI (see VARARGIN)


% Add the total file path to the T-file list chosen by the user
handles.filePath = varargin{1};
handles.fileList = varargin{2};
if ~strcmp(handles.filePath(end),'\')
    handles.filePath = strcat(handles.filePath,'\');
end
% Set current path as the initial path
handles.initPath = pwd;
% No cells have been selected yet
handles.cellName1 = {'0'};
handles.cellName2 = {'0'};
% Load list boxes with the t-file in the specified directory
loadListBox(handles.filePath,handles);

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes correlationGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = correlationGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --- Executes during object creation, after setting all properties.
function cell1List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cell1List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in cell1List. If a file is clicked on or
% double clicked on, the file is set as active for the correlation
% calculation.
function cell1List_Callback(hObject, eventdata, handles)
% hObject    handle to cell1List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% user click of double click an item in the list
if strcmp(get(handles.figure1,'SelectionType'),'normal') | strcmp(get(handles.figure1,'SelectionType'),'open')
    indexSelect = get(handles.cell1List,'Value'); % Index of the selected item in the list
    fileList = get(handles.cell1List,'String'); % List of item in the list
    handles.cellName1 = fileList(indexSelect); % Selected item
    pathName = strcat(char(handles.filePath),handles.cellName1); % Path and name to file
    pathName = char(pathName);
    handles.cellPath1 = handles.filePath;
    % Update handles structure
    guidata(hObject,handles);
    
    % Max 30 letters in one line. Split string in multiple lines for
    % display purposes
    n = floor(length(pathName)/30);
    if n==0
        set(handles.cell1Text,'String',pathName);
    else
        str = cell(1,n+1);
        for ii=1:n
            if ii==1
                str(1,ii) = {pathName(1:30)};
            else
                str(1,ii) = {pathName((30*(ii-1)+1):(30*ii))};
            end
        end
        if length(pathName) > 30*n
            str(1,n+1) = {pathName((30*n+1):end)};
        else
            str(1,n+1) = {''};
        end
        displayStr = strvcat(str);
        set(handles.cell1Text,'String',displayStr); % Display choice to user
    end
end

% --- Executes during object creation, after setting all properties.
function cell2List_CreateFcn(hObject, eventdata, handles)
% hObject    handle to cell2List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in cell2List. If a file is clicked on or
% double clicked on, the file is set as active for the correlation
% calculation.
function cell2List_Callback(hObject, eventdata, handles)
% hObject    handle to cell2List (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% user click of double click an item in the list
if strcmp(get(handles.figure1,'SelectionType'),'normal') | strcmp(get(handles.figure1,'SelectionType'),'open')
    indexSelect = get(handles.cell2List,'Value'); % Index of the selected item in the list
    fileList = get(handles.cell2List,'String'); % List of item in the list
    handles.cellName2 = fileList(indexSelect); % Selected item
    pathName = strcat(char(handles.filePath),handles.cellName2); % Path and name to file
    pathName = char(pathName);
    handles.cellPath2 = handles.filePath;
    % Update handles structure
    guidata(hObject,handles);
    
    % Max 30 letters in one line. Split string in multiple lines for
    % display purposes
    n = floor(length(pathName)/30);
    if n==0
        set(handles.cell2Text,'String',pathName);
    else
        str = cell(1,n+1);
        for ii=1:n
            if ii==1
                str(1,ii) = {pathName(1:30)};
            else
                str(1,ii) = {pathName((30*(ii-1)+1):(30*ii))};
            end
        end
        if length(pathName) > 30*n
            str(1,n+1) = {pathName((30*n+1):end)};
        else
            str(1,n+1) = {''};
        end
        displayStr = strvcat(str);
        set(handles.cell2Text,'String',displayStr); % Display choice to user
    end
end


% --- Executes on button press in browse1Button. Display a file browser to
% the user.
function browse1Button_Callback(hObject, eventdata, handles)
% hObject    handle to browse1Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Go to the directory were the T-list was loaded from
cd (char(handles.filePath));
% Display file browser to user
[handles.cellName1,handles.cellPath1] = uigetfile('*.t','Pick a file (cell 1)');
% Go back to the working directory
cd (handles.initPath);
% Update handle structure
guidata(hObject,handles);
if ~strcmp(handles.cellPath1(end),'\')
    handles.cellPath1 = strcat(handles.cellPath1,'\');
end
pathName = strcat(handles.cellPath1,handles.cellName1);
n = floor(length(pathName)/30);
if n==0
    set(handles.cell2Text,'String',pathName);
else
    str = cell(1,n+1);
    for ii=1:n
        if ii==1
            str(1,ii) = {pathName(1:30)};
        else
            str(1,ii) = {pathName((30*(ii-1)+1):(30*ii))};
        end
    end
    if length(pathName) > 30*n
        str(1,n+1) = {pathName((30*n+1):end)};
    else
        str(1,n+1) = {''};
    end
    displayStr = strvcat(str);
    set(handles.cell1Text,'String',displayStr); % Display choice to user
end

% --- Executes on button press in browse2Button. Displays a file browser to
% the user.
function browse2Button_Callback(hObject, eventdata, handles)
% hObject    handle to browse2Button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Go to the directory were the T-list was loaded from
cd (char(handles.filePath));
% Display file browser to user
[handles.cellName2,handles.cellPath2] = uigetfile('*.t','Pick a file (cell 2)');
% Go back to the working directory
cd (handles.initPath);
% Update handle structure
guidata(hObject,handles);
if ~strcmp(handles.cellPath2(end),'\')
    handles.cellPath2 = strcat(handles.cellPath2,'\');
end
pathName = strcat(handles.cellPath2,handles.cellName2);
n = floor(length(pathName)/30);
if n==0
    set(handles.cell2Text,'String',pathName);
else
    str = cell(1,n+1);
    for ii=1:n
        if ii==1
            str(1,ii) = {pathName(1:30)};
        else
            str(1,ii) = {pathName((30*(ii-1)+1):(30*ii))};
        end
    end
    if length(pathName) > 30*n
        str(1,n+1) = {pathName((30*n+1):end)};
    else
        str(1,n+1) = {''};
    end
    displayStr = strvcat(str);
    set(handles.cell2Text,'String',displayStr); % Display choice to user
end

% --- Executes on button press in autoButton. Will do the auto-correlation of
%  cell 1
function autoButton_Callback(hObject, eventdata, handles)
% hObject    handle to autoButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check if the user has chosen a file to be analysed
if strcmp(char(handles.cellName1),'0') % No, user has forgotten it
    str = {sprintf('%s%s','You must choose a t-file representing cell 1 before you can do this analysis ',...
            'This can be done by clicking on a filename in the cell 1 list, or by browsing for the file')};
    infoGUI(str);
    % Can't proceed with this function
    return;
end

% Put file name for Mclust cut file in a cell array
% Must be done do be able to use the LoadSpikes rutine
F = {char(handles.cellName1)};
NaFile = cell(1,1);
NaFile(1,1) = {''};
NaFile = NaFile(1,1:0); %Empty list, must have it as input to the LoadSpikes rutine
% Load the spikes from the cut file
S = LoadSpikes(F,char(handles.cellPath1),NaFile);
% Put data in time stamp array (unit: 1/10000 sec)
handles.spikeTS = Data(S{1});
% Update the handles structure
guidata(hObject,handles);

% Calculate the auto-correlation (Rxx)
Rxx = autoCorr(handles.spikeTS);
%Rxx = zeros(1,2*N-1); % The length of the auto-correlation will be 2*N-1

% Plot the data
axes(handles.corrPlot);
% Draw Rxx using bars
bar(Rxx);
xlabel('Time between neighbour spikes in ms');
ylabel('[Hz]');
str = sprintf('%s%s','Autocorrelation for file ',char(handles.cellName1));
title(str);

% --- Executes on button press in crossButton. Will do the cross-correlation of cell
% 1 vs cell 2
function crossButton_Callback(hObject, eventdata, handles)
% hObject    handle to crossButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check if the user has chosen files to be analysed
if strcmp(char(handles.cellName1),'0') | strcmp(char(handles.cellName2),'0') % No, user has forgotten it
    str = {sprintf('%s%s','You must choose t-files representing cell 1 and cell 2 before you can do this analysis ',...
            'This can be done by clicking on a filename in the cell 1 list, or by browsing for the file')};
    infoGUI(str);
    % Can't proceed with this function
    return;
end

% Put file name for Mclust cut file in a cell array
% Must be done do be able to use the LoadSpikes rutine
F = cell(1,2);
F(1) = {char(handles.cellName1)};
F(2) = {char(handles.cellName2)};
NaFile = cell(1,1);
NaFile(1,1) = {''};
NaFile = NaFile(1,1:0); %Empty list, must have it as input to the LoadSpikes rutine
% Load the spikes from the cut file
S = LoadSpikes(F,char(handles.cellPath1),NaFile);
% Put data in time stamp array (unit: 1/10000 sec)
handles.spikeTS1 = Data(S{1});
handles.spikeTS2 = Data(S{2});
% Update the handles structure
guidata(hObject,handles);

% Calculate normalized crosscorrelation
Rxy = crossCorr(handles.spikeTS1, handles.spikeTS2);

% Plot the data
axes(handles.corrPlot);
% Draw Rxx using bars
bar(Rxy);
xlabel('');
ylabel('');
str = sprintf('%s%s%s%s%s','Normalized Crosscorrelation for file ',char(handles.cellName1),' and ',char(handles.cellName2),...
    ' A perfect match in spike pattern will give a pyramid formed graph and a peak value of 1');
title(str);

% Loads file names into the file lists (Only the t-files)
function loadListBox(filePath,handles)
cd (char(filePath));
dirStruct = dir;
files = cell(1,length(dirStruct));
counter = 0;
for ii=1:length(dirStruct)
    if ~dirStruct(ii).isdir % This is a file
        [pathstr,name,ext,veresn] = fileparts(char(dirStruct(ii).name));
        if strcmp(ext,'.t') % This is a Mclust cut (t) file
            counter = counter + 1;
            files(1,counter) = {dirStruct(ii).name};
        end
    end
end
% Go back to working directory

cd (char(handles.initPath));
if ~length(files) % No t files in directory (if so the user has mest it up!)
    files(1,1:end) = ''    
else
    files = files(1:counter);
end
% Sort filenames alphabetical
files = sortrows(files');
set(handles.cell1List,'String', files);
set(handles.cell2List,'String', files);



% --- Executes on button press in exitButton. Close this GUI.
function exitButton_Callback(hObject, eventdata, handles)
% hObject    handle to exitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Exit GUI
delete(handles.figure1);


% Do an autocorrelation of spike intervals for one cell. This will find if
% the spike pattern for this cell is repeting itself.
function auto = autoCorr(TS)

% Number of spikes in cell
N = length(TS);
% Aproxiate the duration of the trial to the time duration between first
% and last spike
duration = TS(end)-TS(1);
% Convert timestamps to ms
TS = TS/10;
% Set bin duration to 1 ms and length to 100 ms
bins = zeros(1,100);
% Find time difference between "neighbour" spikes
difference = diff(TS);
% Take out spikes that are more than 100 ms apart
index = find(difference <=100);
difference = difference(index);
% Count number of spikes in each bin of 1 ms from 1 to 100 ms
bins(1) = length(find(difference < 1));
for ii = 2:100
    bins(ii) = length(find(difference < ii & difference >= ii-1));
end
% Convert number of spikes in bins to number of spikes in bins pr
% second [Hz]
auto = bins/duration*1000;

% Do a normalized crosscorrelation of the spike pattern in cell 1 versus
% cell 2. A perfect match will give a peak value of 1.
function cross = crossCorr(TS1,TS2)

% Do the crosscorrelation using Matlab's built in function
Rxy = xcorr(TS1,TS2);
% Calculate autocorrelation for both cells.
Rxx = xcorr(TS1,TS1);
Ryy = xcorr(TS2,TS2);
% Normalize the crosscorrelation
cross = Rxy/(sqrt(max(Rxx)*max(Ryy)));