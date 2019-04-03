function varargout = infoGUI(varargin)
% INFOGUI M-file for infoGUI.fig
%      INFOGUI, by itself, creates a new INFOGUI or raises the existing
%      singleton*.
%
%      H = INFOGUI returns the handle to a new INFOGUI or the handle to
%      the existing singleton*.
%
%      INFOGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in INFOGUI.M with the given input arguments.
%
%      INFOGUI('Property','Value',...) creates a new INFOGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before infoGUI_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to infoGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help infoGUI

% Last Modified by GUIDE v2.5 17-Feb-2004 09:20:49

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @infoGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @infoGUI_OutputFcn, ...
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


% --- Executes just before infoGUI is made visible.
function infoGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to infoGUI (see VARARGIN)

handles.textString = varargin{1};
% Update handles structure
guidata(hObject, handles);
set(handles.infoText, 'String', char(handles.textString));

% UIWAIT makes infoGUI wait for user response (see UIRESUME)
uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = infoGUI_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% We are done. Close the dialog box
delete(handles.figure1);



% --- Executes on button press in okButton.
function okButton_Callback(hObject, eventdata, handles)
% hObject    handle to okButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

uiresume(handles.figure1);
