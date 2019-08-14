ttList='CellList.txt';
csclist = [5,25,29,33,49]; %only add CSC with cells
path='C:\Users\Laura\Documents\3xTg project\Mouse 30\2014-12-07_13-02-08'; %change for each day 
session = [1,2,3]; %number of sessions, begin1 begin2 begin3

%theta
f1 = 6;
f2 = 10;


TT0 = ReadFileList(ttList);
    numCells0 = length(TT0);
    
mean_vector_length = zeros(length(TT0));
Nc = 0;
for nsession=1:length(session)
    for ncsc=1:length(csclist)
    % check if tetrode ntt has cells
    tt_ind=strcat('TT',num2str(floor((csclist(ncsc)+3)/4)),'_');
    nc_ntt=0;
    TT=cell(1,1);
    for nc0=1:numCells0
        if strncmp(TT0{nc0},tt_ind,length(tt_ind));
            nc_ntt=nc_ntt+1;
            TT{nc_ntt,1}=TT0{nc0};
        end
    end
    if nc_ntt>0
        % load EEG data
        path_nd=strcat(path,'\begin',num2str(nsession)); 
        eegfile = strcat(path_nd,'\CSC',num2str(csclist(ncsc)),'.ncs');
        [eeg,eTSi,eTS] = loadEeg8(eegfile);
        
        % get theta phase
        bp = fftbandpass(eeg,2000,f1-2,f1,f2,f2+2);%theta
        tphase = thetaPhase_from_Karel(bp); %0 = peak; 180 = trough; 360 = peak
        
        % do phase locking for each cell on this tetrode
        NaFile = cell(1,nc_ntt); % Store non existing file names here
        NaFile = NaFile(1,1:0);
        S = loadSpikes_CZ(TT0,path_nd,NaFile);
        spikes=cell(nc_ntt,1);
        for nc = 1:nc_ntt
            Nc = Nc+1;
            
            % load spikes of this cell
            if ~isa(S{nc},'ts') % Empty cell in this session
                ts = 1e64; % use a single ridicilous time stamp if the cell is silent
            else
                % Convert t-file data to timestamps in second
                ts = Data(S{nc}) / 10000;
            end
        end
            
            % find the corresponding theta phase for each spike
            Ind = find_spike_times_rs13_no_phase_v2(ts, eTSi);
            phase_nc = tphase(Ind);
            
            % calculate the phase locking for this cell
            [meanAngle,angDev,vectorLength,rayleighP,rayleighZ,cirDev] = circularStat(phase_nc);
            
            % save the phase locking data
            mean_vector_length(Nc) = vectorLength;
        end
    end
end