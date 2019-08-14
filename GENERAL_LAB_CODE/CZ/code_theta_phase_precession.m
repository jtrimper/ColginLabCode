% Run this code within each recording session, be sure you copy and paste
% the cell list 'TTList_dCA1_pyr.txt' into this folder.

% You'd better run it step by step to make sure it gets you correct results
% for every step

%% video
% NOTE: change paramaters if need
scale = 0.26;
vfs = 30;

[t,x,y] = loadPos_rescaled_cz('VT1.nvt',scale,scale,vfs);
% NOTE: the following 3 lines are for linear track data
% For the circular data, please use angular instead of the distance, and
% you should get a "xL" with angular data for all time points in the video
[x,y] = axesRotater(x,y);
v = findVelLinear(x);
[xL] = linearizedirection(x,t,x,t,smooth(v,15));

%% spikes
ttfile = 'TTList_dCA1_pyr.txt';
path = pwd;
fid=fopen(ttfile);
if (fid == -1)
    warning([ 'Could not open tfile ' ttfile]);
else
    % read the file names from the t-file list
    TT0 = ReadFileList(ttfile);
    numCells0 = length(TT0);
    if numCells0==1 && max(TT0{1}==-1)
        % no cells in ttlist
        numcells=0;
    else
        numcells=numCells0;
    end
end
NaFile = cell(1,numcells); % Store non existing file names here
NaFile = NaFile(1,1:0);
S = loadSpikes(TT0,path,NaFile);
spikes=cell(numcells,2);

for nc=1:numcells
    if ~isa(S{nc},'ts') % Empty cell in this session
        ts = 1e64; % use a single ridicilous time stamp if the cell is silent
    else
        % Convert t-file data to timestamps in second
        ts = Data(S{nc}) / 10000;
    end
    spikes{nc,1} = TT0{nc,1};
    spikes{nc,2} = ts;
end

%% EEG
tetOld = 0;
eeg = 0;
th1 = 6;
th2 = 10;
for nc = 1:size(spikes,1)
    ts = spikes{nc,2};
    
    % NOTE: change the tetrode name for mice if need
    if spikes{nc,1}(4) ~= '_';
         tetNew = str2double(spikes{nc,1}(3:4));
    elseif spikes{nc,1}(4) == '_';
         tetNew = str2double(spikes{nc,1}(3));
    else
         disp('problem with something');
    end
    
    if tetNew ~= tetOld
        eeg = eeg +1;
        tetOld = tetNew;
        [e,eTSi,eTS] = loadEeg8(strcat('CSC',num2str(tetNew),'.ncs'));
        bpth = fftbandpass(e,2000, th1-2,th1,th2,th2+2);%theta
        phsth = angle(hilbert(-bpth))*180/pi+180;%theta peaks = 0 and 360
    end
    
    % find the theta phase
    ind_eeg = SpikeTStoEegIndex(ts,eTS,2000);
    ts_phsth = phsth(ind_eeg);
    spikes{nc,3} = ts_phsth';
end



%% get the firing rate map for each cell,
% and then get the theta phase and normalized position within the main
% place field

% Note: change the parameters!
binWidth = 3;  % cm
% Minimum number of bins in a placefield. Fields with fewer bins than this
% treshold will not be considered as a placefield. Remember to adjust this
% value when you change the bin width
p.minNumBins = 3;
% Bins with rate at p.fieldTreshold * peak rate and higher will be
% considered as part of a place field
p.fieldTreshold = 0.1;
% Lowest field rate in Hz.
p.lowestFieldRate = 3;
peak_all = 2;

for nc = 1:numcells
    ts = spikes{nc,2};
    tempspkxL = GetSpikePos(ts,xL,xL,t);
    spikes{nc,4} = tempspkxL;
    
    % NOTE: ratemap_decode is for linear data. If you have circular track
    % data, please use the angular ratemap code instead !
    [temprate, xbins] = ratemap_decode(xL,tempspkxL,binWidth);
    spikes{nc,5} = temprate;
    spikes{nc,6} = xbins;
    
    % find the main place field
    % NOTE: This "placefield" code is for linear track rate map. 
    % For the circular rate map, you need to stretch it linearly,
    % (you may need to unfold the angular ratemap with the peak firing
    % position to be the center, in order to ensure the main place field
    % will not be split)
    % or use some placefield code particularlly for circular data
    [nFields,fieldProp] = placefield(temprate,p,xbins,peak_all);
    
    if nFields > 0
        % only use the main place field
        field_start = xbins(fieldProp(1).startBin);
        field_stop = xbins(fieldProp(1).stopBin);
        
        % find the theta phase for spike times, and the corresponding positions
        % within the main place field
        ind = find(tempspkxL >= field_start & tempspkxL <= field_stop);
        thetaphase0 = spikes{nc,3}(ind);
        position0 = spikes{nc,4}(ind);
        position0_norm = (position0-field_start)./(field_stop-field_start);
        
        spikes{nc,7} = thetaphase0;
        spikes{nc,8} = position0_norm;
    end
end

%% plot the theta phase precession, and calculate the phase-position slope
ffa = figure('Units','normalized','Position',[0.2 0.2 0.3 0.5]);
for nc = 1:numcells
    if ~isempty(spikes{nc,7})
        x = spikes{nc,8};
        y = spikes{nc,7};
        
        % circular-linear regression
        bound = 2;
        y_rad = pi*y/180;
        [para,z,p] = circ_lin_regress(x, y_rad, bound);
        x_reg = [min(x),max(x)];
        y_reg = 2*pi*para(1)*x_reg + para(2);
        while ~isempty(find(y_reg < 0))
            y_reg = y_reg+2*pi;
        end
        y_reg = 180*y_reg/pi;
        spikes{nc,9} = [para,p]; % slope, phase-offset, p-value of the regression
        
        % plot
        xx = [x;x];
        yy = [y;y+360];
        plot(xx,yy,'.')
        hold on
        plot(x_reg,y_reg,'r');
        hold off
        xlim([0,1]);
        ylim([0,720]);
        set(gca, 'YTick',0:180:720);
        set(gca, 'FontSize',18);
        xlabel('Normalized position');
        ylabel('Theta phase (degrees)');
        title(strcat('cell-', num2str(nc)),'FontSize',18)
        
        pause
    end
end