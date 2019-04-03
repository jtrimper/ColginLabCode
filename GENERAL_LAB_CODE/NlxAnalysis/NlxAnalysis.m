function varargout = NlxAnalysis(varargin)
% NLXANALYSIS M-file for NlxAnalysis.fig
%      NLXANALYSIS, by itself, creates a new NLXANALYSIS or raises the existing
%      singleton*.
%
%      H = NLXANALYSIS returns the handle to a new NLXANALYSIS or the handle to
%      the existing singleton*.
%
%      NLXANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NLXANALYSIS.M with the given input arguments.
%
%      NLXANALYSIS('Property','Value',...) creates a new NLXANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before NlxAnalysis_OpeningFunction gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to NlxAnalysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help NlxAnalysis

% Last Modified by GUIDE v2.5 20-Feb-2004 11:25:38

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @NlxAnalysis_OpeningFcn, ...
                   'gui_OutputFcn',  @NlxAnalysis_OutputFcn, ...
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


% --- Executes just before NlxAnalysis is made visible.
function NlxAnalysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to NlxAnalysis (see VARARGIN)

% Choose default command line output for NlxAnalysis
handles.output = hObject;
% Add parmeters to the handle structure
handles.fileArray = cell(1,20);
handles.pathArray = cell(1,20);
handles.counter = 0;
handles.initDir = pwd;
% Update handles structure
guidata(hObject, handles);
% Clear global parameters that may be in the working memory
clear global;

% UIWAIT makes NlxAnalysis wait for user response (see UIRESUME)
uiwait(handles.figure1);

% --- Outputs from this function are returned to the command line.
function varargout = NlxAnalysis_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure


% --- Executes on button press in browseButton.
function browseButton_Callback(hObject, eventdata, handles)
% hObject    handle to browseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% User select files from the browse GUI. Returns list of files, list
% of paths to files and number of chosen files.
[handles.fileArray, handles.pathArray, handles.counter] = browseGUI;
guidata(hObject, handles);

for ii=1:handles.counter
    handles.path_name(ii) = strcat(strcat(handles.pathArray(ii),'\'),handles.fileArray(ii));
end
guidata(hObject, handles);
% Display chosen files in GUI
set(handles.tFiles, 'String', [handles.path_name]);

% --- Executes during object creation, after setting all properties.
function tFiles_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in tFiles.
function tFiles_Callback(hObject, eventdata, handles)
% hObject    handle to tFiles (see GCBO)
% eventdata  reserved - to be defined in a future version of\+0987654321|123 MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns tFiles contents as cell array
%        contents{get(hObject,'Value')} returns selected item from tFiles


% --- Executes during object creation, after setting all properties.
function arenaChoice_CreateFcn(hObject, eventdata, handles)
% hObject    handle to arenaChoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end


% --- Executes on selection change in arenaChoice.
function arenaChoice_Callback(hObject, eventdata, handles)
% hObject    handle to arenaChoice (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns arenaChoice contents as cell array
%        contents{get(hObject,'Value')} returns selected item from arenaChoice


% --- Executes during object creation, after setting all properties.
function outputFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to outputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc
    set(hObject,'BackgroundColor','white');
else
    set(hObject,'BackgroundColor',get(0,'defaultUicontrolBackgroundColor'));
end



function outputFile_Callback(hObject, eventdata, handles)
% hObject    handle to outputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of outputFile as text
%        str2double(get(hObject,'String')) returns contents of outputFile as a double


% --- Executes on button press in analyseButton. This will actuate the
%  field analysing of the data.
function analyseButton_Callback(hObject, eventdata, handles)
% hObject    handle to analyseButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Check if the user has filled out the information he is supposed to
if handles.counter == 0 % No t-file list has been chosen
    str = 'You must choose at least one t-file list before you start analysing';
    % infoGUI takes cells as input
    strCell = {str};
    infoGUI(strCell);
    return;
end
% Get name for output file
initResultFile = get(handles.outputFile, 'String');
% Check if user input is valid
if length(initResultFile)<=4 % User didn't fill out the output file name
    str = sprintf('%s%s','You must fill out a name for the ouput file.', ...
    ' The file name must have the extention .txt ');
    strCell = {str};
    infoGUI(strCell);
    return;
end

% Get total number of t-files to anayse. 
% This to be able to show progress to screen
numberOfFiles = 0;
% How far we have come now
currentNumberOfFiles = 0; % (used later)
for ii=1:handles.counter
    NAME  = char(handles.path_name(ii));
    fid2 = fopen(NAME, 'r');
    while ~feof(fid2)
        temp = fgetl(fid2);
        numberOfFiles = numberOfFiles + 1;
    end
    fclose(fid2);
end


% Get name for trial room
val = get(handles.arenaChoice, 'Value');
rooms = get(handles.arenaChoice, 'String');
roomName = char(rooms(val));


% Display progress to GUI
set(handles.infoText, 'String', 'The field analysis is starting...');
    
% Set the field selection for reading the video file. 1 = Add parameter, 0 = skip
% parameter
fieldSelection(1) = 1; % Timestamps
fieldSelection(2) = 1; % Extracted X
fieldSelection(3) = 1; % Extracted Y
fieldSelection(4) = 0; % Extracted Angel
fieldSelection(5) = 0; % Targets
fieldSelection(6) = 0; % Points
% Do we return header 1 = Yes, 0 = No.
extractHeader = 1;
% 5 different extraction modes, see help file for Nlx2MatCSC
extractMode = 1; % Extract all data

% Analyse all data.
for NN = 1:handles.counter
    % Highlight current file in the file list
    set(handles.tFiles, 'Value', NN);
    filepath = strcat(char(handles.pathArray(1,NN)),'\');
    fileList = strcat(filepath,char(handles.fileArray(1,NN)));
    resultFile = strcat(filepath,initResultFile);
    % Video file
    currentFile = strcat(filepath,'vt1.nvt');
    % Open file for writing
    fid2 = fopen(resultFile,'w');
    % Write header to output file
    fprintf(fid2,'%s\t','File');
    fprintf(fid2,'%s\t','Avg. rate');
    fprintf(fid2,'%s\t','Peak rate');
    fprintf(fid2,'%s\t','Bursting (%)');
    fprintf(fid2,'%s\t','Field size (cm^2)');
    fprintf(fid2,'%s\t','Sparseness');
    fprintf(fid2,'%s\t','Selectivity');
    fprintf(fid2,'%s\t','Information');
    fprintf(fid2,'%s\t\t','Peak_X');
    fprintf(fid2,'%s\t\t','Peak_Y');
    fprintf(fid2,'%s\t','Centroid_X');
    fprintf(fid2,'%s\n\n','Centroid_Y');
    
    % Get positon data
    % TimeStamps: Time stamps in microseconds
    % ExtractedX: X-coordinates of rat path
    % ExtractedY: Y-coordinates of rat path
    % NlxHeader:  Header information from the NeuralLynx software, may be empty.
    [TimeStamps, ExtractedX, ExtractedY, NlxHeader] = Nlx2MatVt(currentFile,fieldSelection,extractHeader,extractMode);
   
    
    % convert position TimeStamps to seconds
    TimeStamps = TimeStamps/1000000;
    
    % Ignore invalid points, the algorithm does not need interpolation
    ValidIndex = find(ExtractedX > 0 & ExtractedY > 0);
    ExtractedX = ExtractedX(ValidIndex);
    ExtractedY = ExtractedY(ValidIndex);
    TimeStamps = TimeStamps(ValidIndex);
   
    % Smoothing the position samples with a simple mean filter
    for cc=8:length(ExtractedX)-7
        ExtractedX(cc) = nanmean(ExtractedX(cc-7:cc+7));
        ExtractedY(cc) = nanmean(ExtractedY(cc-7:cc+7));
    end
   
    % Get parameters for plotting
    [centerX, centerY, scale, sLength, bins] = getRoomParameters(roomName);
   
    % Plot path of rat
    axes(handles.pathPlot)
    fieldAxis = linspace(-sLength/2,sLength/2,bins);
    plot(ExtractedX,ExtractedY);
    axis image;
    title('path.bmp');
    % take a copy of the frame buffer, and save it to a
    % bitmap file and a epsc image file.
    bmpImage = strcat(filepath,'path.bmp');
    epsImage = strcat(filepath,'path.eps');
    % EPSC
    figure(1);
    fieldAxis = linspace(-sLength/2,sLength/2,bins);
    plot(ExtractedX,ExtractedY);
    axis image;
    title('path');
    % Force MATLAB to update the screen
    drawnow;
    saveas(1,epsImage,'epsc');
    % BMP
    f = getframe(handles.pathPlot);
    [pic, cmap] = frame2im(f);
    imwrite(pic,bmpImage,'bmp');
   
    % adjust xy coordinates to fit parameters for plotting
    ExtractedX = (ExtractedX - centerX)*scale;
    ExtractedY = (ExtractedY - centerY)*scale;
   
    % read the file names from the t-file list
    F = ReadFileList(fileList);
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
    numberOfFiles = numberOfFiles - NaFileCounter;
    
    % Load data from the cut files generated by Mclust
    S = LoadSpikes(F,char(handles.pathArray(1,NN)),NaFile);
    nCells = length(S); % Number of cell in the list
   
    % Display number of files to analyse to GUI
    str1 = sprintf('%s%3.0f%s','There are ',nCells-NaFileCounter,' files to be analysed in this directory');
    set(handles.infoText, 'String', str1);
    % Force MATLAB to update the screen
    drawnow;
   
    % Analyse data for alle cells
    for ii=1:nCells
        % Name of image files
        % Display cell number to GUI
        str2 = sprintf('%s%3.0f','Analysing cell number ',ii);
        set(handles.infoText2,'string',str2);
        drawnow;
        filename = strcat(strrep(char(F(ii)),'.t',''),'.bmp');
        epsfilename = strcat(strrep(char(F(ii)),'.t',''),'.eps');
        PathSpikeName = strcat(strrep(char(F(ii)),'.t',''),'Path');
        temp = S{ii};
        
        if ~isa(temp,'ts') %Empty/ non existing cell
            % Write data to file. Everything is set to NaN
            shortName = filename(1:findstr(filename,'.')-1);
            fprintf(fid2,'%s\t',shortName);
            fprintf(fid2,'%s\t\t','NaN');
            fprintf(fid2,'%s\t\t','NaN');
            fprintf(fid2,'%s\t\t','NaN');
            fprintf(fid2,'%s\t\t\t','NaN');
            fprintf(fid2,'%s\t\t','NaN');
            fprintf(fid2,'%s\t\t','NaN');
            fprintf(fid2,'%s\t\t','NaN');
            fprintf(fid2,'%s\t\t','NaN');
            fprintf(fid2,'%s\t\t','NaN');
            fprintf(fid2,'%s\t\t','NaN');
            fprintf(fid2,'%s','NaN');
            fprintf(fid2,'\n');
        else
            % Convert spike data to timestamps in seconds
            ts = Data(S{ii}) / 10000;
            if ~length(ts)
                ts = 1e64; % use a single ridicilous time stamp if the cell is silent
            end
            
            % Plot path of rat with spikes
            axes(handles.pathPlot);
            fieldAxis = linspace(-sLength/2,sLength/2,bins);
            h = plot(ExtractedX,ExtractedY); % Path
            set(h,'color',[0.5 0.5 0.5]); % Set color of the path to gray
            axis image;
            title('path with spikes');
            hold on;
            spkInd = spkIndex(ts, TimeStamps);
            spkX = ExtractedX(spkInd);
            spkY = ExtractedY(spkInd);
            plot(spkX,spkY,'r*'); % Spikes
            hold off;
            
            figure(1);
            fieldAxis = linspace(-sLength/2,sLength/2,bins);
            h = plot(ExtractedX,ExtractedY);
            set(h,'color',[0.5 0.5 0.5]); % Set color of the path to gray
            axis image;
            title('path with spikes');
            hold on;
            plot(spkX,spkY,'r*'); % Spikes
            hold off;
            saveName = strcat(PathSpikeName,'.eps');
            saveName = strcat(filepath,saveName);
            % Force MATLAB to update the screen
            drawnow;
            saveas(1,saveName,'epsc');
            % BMP
            f = getframe(handles.pathPlot);
            [pic, cmap] = frame2im(f);
            saveName = strcat(PathSpikeName,'.bmp');
            saveName = strcat(filepath,saveName);
            imwrite(pic,saveName,'bmp');
      
            % Calculate the statistics and find the rate map and store it to
            % image files

            % Avarage rate
            spentTime = max(ts);
            nSpikes = length(ts);
            avgRate = nSpikes/spentTime;
    
            % Burstiness
            if length(ts)>1
                [bursts, singleSpikes] = burstfinder(ts,0.01); % 10 ms criterion
            elseif length(ts)==1
                bursts = [];
                singleSpikes = 1;
            else
                bursts = [];
                singleSpikes = [];
            end
            nBursts = length(bursts);
            nSingleSpikes = length(singleSpikes);
            if (nBursts+nSingleSpikes)==0
                percent_of_bursts = NaN;
            else
                percent_of_bursts = 100 * nBursts/(nBursts+nSingleSpikes);
            end
        
            % Find rate map, sdf and pospdf
            [rateMap,sdf,pospdf] = field(bins, sLength, ts, ExtractedX', ExtractedY', TimeStamps');
        
            % Highest rate
            peakRate = max(max(rateMap));
            % Shannon information, sparseness, and selectivity 
            [information, sparseness, selectivity] = mapstat(rateMap,pospdf);
            % Size of field
            fsize = fieldsize(rateMap,.2,1);
            fsize = fsize * 25; % Convert to cm^2
            mapAxis = linspace(-100,100,40);
            % Find peak values and centoid
            [loc_peak,loc_centroid] = fieldloc(rateMap,mapAxis);
    
            % Write data to file
            shortName = filename(1:findstr(filename,'.')-1);
            fprintf(fid2,'%s\t',shortName);
            fprintf(fid2,'%5.2f\t\t',avgRate);
            fprintf(fid2,'%5.2f\t\t',peakRate);
            fprintf(fid2,'%5.2f\t\t',percent_of_bursts);
            fprintf(fid2,'%5.0f\t\t\t',fsize);
            fprintf(fid2,'%5.2f\t\t',sparseness);
            fprintf(fid2,'%5.2f\t\t',selectivity);
            fprintf(fid2,'%5.2f\t\t',information);
            fprintf(fid2,'%5.2f\t\t',loc_peak(1));
            fprintf(fid2,'%5.2f\t\t',loc_peak(2));
            fprintf(fid2,'%5.2f\t\t',loc_centroid(1));
            fprintf(fid2,'%5.2f',loc_centroid(2));
            fprintf(fid2,'\n');
    
            % Calculate maximum rate for scaling the plot
            maxrate = max(max(rateMap));
    
            % Draw the map
            axes(handles.fieldPlot)
            drawfield(rateMap,fieldAxis,'jet',maxrate,filename);
    
            % take a copy of the frame buffer, and save it to a
            % bitmap file and an epcs image file
            filename = strcat(filepath,filename);
            epsFilename = strcat(filepath,epsfilename);
            
            % EPSC
            figure(1);
            drawfield(rateMap,fieldAxis,'jet',maxrate,epsfilename);
            saveas(1,epsFilename,'epsc');
            
            % BMP
            f = getframe(figure(1));
            [pic, cmap] = frame2im(f);
            imwrite(pic, filename, 'bmp');
        
            currentNumberOfFiles = currentNumberOfFiles + 1;
      
            % Display total progress to GUI
            prg = 100 * currentNumberOfFiles/numberOfFiles;
            str3 = sprintf('%s%3.1f%s','Total progress is ',prg,' percentage');
            set(handles.infoText3, 'String', str3);
            if prg == 100 % Finished
                set(handles.infoText4, 'String', 'Finished analysing');
            end
            % Display what file is analysed
            %set(handles.currentFile, 'String', ii);
            % Force MATLAB to update the screen
            drawnow;
        end % End else
    end % Inner for loop
    fclose(fid2);
end % Outer for loop
uiresume(handles.figure1); 

% --- Executes on button press in CSCButton. This brings up the continuous
% data analysing part of the program.
function CSCButton_Callback(hObject, eventdata, handles)
% hObject    handle to CSCButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter == 0 % No t-file list has been chosen
    str = sprintf('%s%s%s','You must choose a t-file list before you start ', ...
        'the continuous sampled data analysis. The chosen list will specify in what directory ',...
        'the program will find the data to be analysed ');
    % infoGUI takes cells as input
    strCell = {str};
    infoGUI(strCell);
    return;
end

% Get the selected list
index_Selected = get(handles.tFiles,'Value');
path = handles.pathArray(index_Selected);
fileList = handles.fileArray(index_Selected);
% Open the CSC-analyse GUI.
CSC_analyse(path,fileList);


% --- Executes on button press in exitButton. This will close and terminate
% the appliaction
function exitButton_Callback(hObject, eventdata, handles)
% hObject    handle to exitButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close(figure(1));
delete(handles.figure1);

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
            centerX = 350;%centerX = 280;
            centerY = 280;
            sLength = 150; % Length of box is 80 cm, the redundancy is to take care of the situation when the box is moved
            bins = 30; % Give resolution of 5cm x 5cm
        case 'morphbox2'
            centerX = 229;
            centerY = 250;
            sLength = 150;
            bins = 30;
    end
    
    
function spkInd = spkIndex(ts,post)
M = length(ts);
spkInd = zeros(M,1);
for ii=1:M
    tdiff = (post-ts(ii)).^2;
    [m,ind] = min(tdiff);
    spkInd(ii) = ind;
end
    
function [map,sdf,pospdf] = field(bins, slength, ts, posx, posy, post)
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
   pospdf = timeHere/(sum(sum(timeHere)));

   
   
function [loc_peak,loc_centroid] = fieldloc(map,mapaxis);

n = size(map,1);
maxrate = max(max(map));
[i1,i2] = find(map == maxrate);
i1 = i1(1);
i2 = i2(1);
loc_peak(1) = mapaxis(i2);
loc_peak(2) = mapaxis(i1);

w_sumx = 0;
w_sumy = 0;
w_sum = 0;
for ii = 1:n
    for jj = 1:n
        if ~isnan( map(ii,jj) )
            w_sumx = w_sumx + map(ii,jj)*mapaxis(ii);
            w_sumy = w_sumy + map(ii,jj)*mapaxis(jj);
            w_sum = w_sum + map(ii,jj);
        end
    end
end

if w_sum > 0
    loc_centroid(1) = w_sumx/w_sum;
    loc_centroid(2) = w_sumy/w_sum;
else
    loc_centroid = [NaN NaN];
end

% Find bursts and singlespikes
function [bursts,singlespikes] = burstfinder(ts,maxisi);
bursts = [];
singlespikes = [];
isi = diff(ts);
n = length(ts);
if isi(1) <= maxisi
   bursts = 1;
else
   singlespikes = 1;
end
for t = 2:n-1;
   if (isi(t-1)>maxisi) & (isi(t)<=maxisi)
      bursts = [bursts; t];
   elseif (isi(t-1)>maxisi) & (isi(t)>maxisi)
      singlespikes = [singlespikes; t];      
   end
end   
if (isi(n-1)>maxisi) 
    singlespikes = [singlespikes; n];      
end


% Shannon information, sparseness, and selectivity  
function [information,sparsity,selectivity] = mapstat(map,posPDF);
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
if length(i1)>0
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

% Size of 4-neighbor connected field. cf. Muller, Kubie & Ranck (1987)
function fsize = fieldsize(map,threshold,minfieldsize);
if max(max(map))<0.3
   fsize = 0;
   return;
end    
set(0,'RecursionLimit',100000);  
[n,m] = size(map);
threshold = threshold * max(max(map));
fsize = 0;
for i = 1:n;
   for j = 1:m;
      	count = 0;
         grid = zeros(n,m);
   		[count, grid] = recursebins(map,grid,i,j,count,threshold);
         if count > fsize;
         	fsize = count;
         end   
  	end   
end   
fsize = fsize * (fsize >=minfieldsize); %ignore if field is too small


function [count, grid] = recursebins(map,grid,i,j,count,threshold);
[n,m] = size(map);
if (i<1) | (i>n);
   return;
elseif (j<1) | (j>m);
   return;
elseif grid(i,j) == 1
   return;
elseif (map(i,j) < threshold) & (grid(i,j) == 0);
   grid(i,j) = 1;
   return;
elseif (map(i,j) >= threshold) & (grid(i,j) == 0);
   count = count+1;
   grid(i,j) = 1;
   if i-1>0
   	if (map(i-1,j) >= threshold) & (grid(i-1,j) == 0);
   		[count, grid] = recursebins(map,grid,i-1,j,count,threshold);
		end
   end
   if j+1<=m
		if (map(i,j+1) >= threshold) & (grid(i,j+1) == 0);
   		[count, grid] = recursebins(map,grid,i,j+1,count,threshold);
   	end
	end
	if i+1<=n
   	if (map(i+1,j) >= threshold) & (grid(i+1,j) == 0);
   		[count, grid] = recursebins(map,grid,i+1,j,count,threshold);
      end
   end   
   if j-1>0   
   	if (map(i,j-1) >= threshold) & (grid(i,j-1) == 0);
   		[count, grid] = recursebins(map,grid,i,j-1,count,threshold);
   	end
   end
   return;
else  % NaN
   grid(i,j) = 1;
   return;
end
   
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
   %title(strcat(cellid,'¤(0 - ',num2str(maxrate), ' Hz)'));
   text(-60,70,strcat(cellid,'¤(0 - ',num2str(maxrate), ' Hz)'),'FontSize',20);


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
       


% --- Executes on button press in correlationButton. This will bring up the
% GUI for doing correlation analysis of the data
function correlationButton_Callback(hObject, eventdata, handles)
% hObject    handle to correlationButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.counter == 0 % No t-file list has been chosen
    str = sprintf('%s%s%s','You must choose a t-file list before you start ', ...
        'the correlation analysis. The chosen list will specify in what directory ',...
        'the program will find the data to be analysed ');
    % infoGUI takes cells as input
    strCell = {str};
    infoGUI(strCell);
    return;
end

% Get the selected list
index_Selected = get(handles.tFiles,'Value');
path = handles.pathArray(index_Selected);
fileList = handles.fileArray(index_Selected);
% Open the CSC-analyse GUI.
correlationGUI(path,fileList);
