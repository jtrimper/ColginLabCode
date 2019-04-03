function varargout = browseGUI(varargin)
% BROWSEGUI M-file for browseGUI.fig
%      BROWSEGUI, by itself, creates a new BROWSEGUI or raises the existing
%      singleton*.
%
%      H = BROWSEGUI returns the handle to a new BROWSEGUI or the handle to
%      the existing singleton*.
%
%      BROWSEGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BROWSEGUI.M with the given input arguments.
%
%      BROWSEGUI('Property','Value',...) creates a new BROWSEGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before browseGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to browseGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help browseGUI

% Last Modified by GUIDE v2.5 13-Feb-2004 14:55:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @browseGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @browseGUI_OutputFcn, ...
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


% --- Executes just before browseGUI is made visible.
function browseGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to browseGUI (see VARARGIN)


% Store path to and name of chosen file TfileLists (set max number of files
% to 20
handles.fileArray = cell(1,20);
handles.pathArray = cell(1,20);
handles.path_name = cell(1,20);
% Counts number of chosen files
handles.counter = 0;
% Store initial and current directory
handles.initDir = pwd;
handles.currentDir = pwd;
% Update handles structure
guidata(hObject, handles);
str = char(pwd);
set(handles.station, 'String', str(1:2));

% Populated the listbox with the files in the current directory
load_listbox(handles.initDir, handles);
% UIWAIT makes browseGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);

% ------------------ End of initialization --------------------


% --- Outputs from this function are returned to the command line.
function varargout = browseGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.fileArray;
varargout{2} = handles.pathArray;
varargout{3} = handles.counter;
% We are done, close this dialog box
delete(handles.figure1);

% --- Executes during object creation, after setting all properties.
function fileFinder_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fileFinder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in fileFinder.
function fileFinder_Callback(hObject, eventdata, handles)
% hObject    handle to fileFinder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns fileFinder contents as cell array
%        contents{get(hObject,'Value')} returns selected item from fileFinder
if strcmp(get(handles.figure1,'SelectionType'),'open') % If double click
    index_selected = get(handles.fileFinder,'Value');
    file_list = get(handles.fileFinder,'String');
    filename = file_list{index_selected}; % Item selected in list box
    cd(handles.currentDir);
    if  handles.is_dir(handles.sorted_index(index_selected)) % If directory
        cd (filename);
        % Set this directory as the current directory
        handles.currentDir = pwd;
        % Update handles structure
        guidata(hObject, handles);
        % Load list box with new directory
        load_listbox(handles.currentDir,handles);
    else % File is selected
        % Check if this is a txt file
        [pathstr,name,ext,versn] = fileparts(filename);
        if strcmp(ext,'.txt') % This is a text file
            % Increment the counter
            handles.counter = handles.counter + 1;
            % Add the elements to the arrays
            handles.fileArray(1,handles.counter) = {filename};
            handles.pathArray(1,handles.counter) = {handles.currentDir};
            handles.path_name(1,handles.counter) = strcat(strcat(handles.pathArray(handles.counter),'\'),handles.fileArray(handles.counter));
            % Update the handles structure
            guidata(hObject,handles);
            % Display chosen files to GUI
            set(handles.ttList, 'String', [handles.path_name]);
        else % Not a text file
            % Display a message to the user
            cd (handles.initDir); % This is were the program files are stored
            str = sprintf('%s%s%s%s','The file ',name,ext,' is not a text file. The t-file list must be a text file');
            strCell = {str};
            infoGUI(strCell);
            cd (handles.currentDir); % Go back to current directory
        end
        if handles.counter==20 % Max number of files is reached
            % Go back to initial directory
            cd (handles.initDir);
            % Work is done! Close GUI and return to parent.  
            uiresume(handles.figure1);
        end
    end
end
% Go back to initial directory
cd (handles.initDir);

% --- Executes during object creation, after setting all properties.
function ttList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ttList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in ttList.
function ttList_Callback(hObject, eventdata, handles)
% hObject    handle to ttList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns ttList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from ttList


% --- Executes on button press in addButton.
function addButton_Callback(hObject, eventdata, handles)
% hObject    handle to addButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get file that is selected
index_selected = get(handles.fileFinder,'Value');
file_list = get(handles.fileFinder,'String');
filename = file_list{index_selected}; % Item selected in list box

if  handles.is_dir(handles.sorted_index(index_selected)) % If directory
    % Do nothing    
else % File is chosen
    % Check if this is a text file
    [pathstr,name,ext,versn] = fileparts(filename);
    if strcmp(ext,'.txt') % This is a text file
        % Increment the counter
        handles.counter = handles.counter + 1;
        % Add the elements to the arrays
        handles.fileArray(1,handles.counter) = {filename};
        handles.pathArray(1,handles.counter) = {handles.currentDir};
        handles.path_name(1,handles.counter) = strcat(strcat(handles.pathArray(handles.counter),'\'),handles.fileArray(handles.counter));
        % Update the handles structure
        guidata(hObject,handles);
        % Display chosen files to GUI
        set(handles.ttList, 'String', [handles.path_name]);
    else % Chosen file is not a text file
        % Display a message to the user
        cd (handles.initDir); % This is were the program files are stored
        str = sprintf('%s%s%s%s','The file ',name,ext,' is not a text file. The t-file list must be a text file');
        strCell = {str};
        infoGUI(strCell);
        cd (handles.currentDir);
    end
    if handles.counter==20 % Max number of files is reached
        % Go back to initial directory
        cd (handles.initDir);
        % Work is done! Close GUI and return to parent.  
        uiresume(handles.figure1);
    end
end


% --- Executes on button press in upButton.
function upButton_Callback(hObject, eventdata, handles)
% hObject    handle to upButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Go to current directory
cd(handles.currentDir);
% Up one level
cd ..;
% Set the new current directory
handles.currentDir = pwd;
% Update handles structure
guidata(hObject, handles);
% Load list box with new directory
load_listbox(handles.currentDir,handles);
% Go back to initial directory
cd(handles.initDir);


% --- Executes on button press in okButton.
function okButton_Callback(hObject, eventdata, handles)
% hObject    handle to okButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Go back to initial directory
cd (handles.initDir);
% Work is done! Close GUI and return to parent.
uiresume(handles.figure1);

% --- Executes during object creation, after setting all properties.
function station_CreateFcn(hObject, eventdata, handles)
% hObject    handle to station (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function station_Callback(hObject, eventdata, handles)
% hObject    handle to station (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of station as text
%        str2double(get(hObject,'String')) returns contents of station as a double


% --- Executes on button press in clearButton.
function clearButton_Callback(hObject, eventdata, handles)
% hObject    handle to clearButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Resets the list
handles.fileArray(1,:) = {''};
handles.pathArray(1,:) = {''};
handles.path_name(1,:) = {''}; 
handles.counter = 0;
guidata(hObject,handles);
set(handles.ttList, 'String', [handles.path_name]);


% --- Executes on button press in removeButton.
function removeButton_Callback(hObject, eventdata, handles)
% hObject    handle to removeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get what item is chosen
index_selected = get(handles.ttList,'Value');
% Remove the selected item from the list
flag = 1;
for ii = 1:handles.counter
    if index_selected == ii
        flag = 0;
    end
    if flag & ii~=index_selected
        handles.fileArray(1,ii) = handles.fileArray(1,ii);
        handles.pathArray(1,ii) = handles.pathArray(1,ii);
        handles.path_name(1,ii) = handles.pathArray(1,ii);
    end
    if ~flag & ii~=index_selected
        handles.fileArray(1,ii-1) = handles.fileArray(1,ii);
        handles.pathArray(1,ii-1) = handles.pathArray(1,ii);L
        handles.path_name(1,ii-1) = handles.pathArray(1,ii);
    end
end
handles.fileArray(1,handles.counter) = {''};
handles.pathArray(1,handles.counter) = {''};
handles.path_name(1,handles.counter) = {''};
handles.counter = handles.counter - 1;
guidata(hObject,handles);
% Display the new list
set(handles.ttList, 'String', [handles.path_name]);

% ------------------------------------------------------------
% Read the current directory and sort the names
% ------------------------------------------------------------
function load_listbox(dir_path,handles)
cd (dir_path)
dir_struct = dir;
[sorted_names,sorted_index] = sortrows({dir_struct.name}');
handles.file_names = sorted_names;
handles.is_dir = [dir_struct.isdir];
handles.sorted_index = [sorted_index];
guidata(handles.figure1,handles)
set(handles.fileFinder,'String',handles.file_names,...
	'Value',1)
set(handles.path_text,'String',pwd)


% --- Executes on key press over figure1 with no controls selected.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over ttList.
function ttList_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to ttList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in changeButton.
function changeButton_Callback(hObject, eventdata, handles)
% hObject    handle to changeButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
str = get(handles.station, 'String');
% Try to make sure that station chosen is valid
if(length(str)==2)
    if strcmp(str(2),':')
        cd (str);
    end
end
% Set the new current directory
handles.currentDir = pwd;
% Load list box with new directory
load_listbox(handles.currentDir,handles);
% Go back to initial directory
cd(handles.initDir);

