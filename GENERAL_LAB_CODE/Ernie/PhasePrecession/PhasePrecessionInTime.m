function [p,fighandle,varargout] = PhasePrecessionInTime(tfile,EEGfile,varargin)
% function [p,fighandle,varargout] = PhasePrecessionInTime(tfile,EEGfile,varargin)


%% Set parameters
power_ratio_threshold = 4;

%% Load files
Spktp ={};
EEG ={}; EEGt ={};
% for single folder
if nargin < 3
    Spktp{1,1} = Readtfile(tfile);
    Spktp{1,1} = Spktp{1,1}./10000; %convert to sec
    lfpStruct = read_in_lfp(EEGfile);
    %     [EEG{1,1}, EEGt{1,1}] = LoadEEG(EEGfile);
    EEG{1,1} = lfpStruct.data
    EEGt{1,1} = lfpStruct.ts;
    
    % for mutiple folders
elseif nargin < 4
    foldername = varargin{1};
    dirlist = targetfolder(foldername);
    for ff = 1:size(dirlist,1)
        tdir = strcat(dirlist{ff},'\',tfile);
        eegdir = strcat(dirlist{ff},'\',EEGfile);
        posdir = strcat(dirlist{ff},'\VT1.nvt');
        
        if exist(tdir,'file') == 2
            
            if strfind(lower(posdir),'overnight')
                Spktp{ff,1} = Readtfile(tdir)./10000;
            elseif strfind(lower(posdir),'lineartrack')
                [post,posx,~] = LoadPos(posdir);
                spkt_temp =  Readtfile(tdir)./10000;
                [cutspkt] = CutTrackendSpk(spkt_temp,posx,post); % Remove trackend spikes
                Spktp{ff,1} = cutspkt;
            end
            [EEG{ff,1}, EEGt{ff,1}] = LoadEEG(eegdir);
            
        else
            continue
        end
    end
    EEG = EEG(~cellfun('isempty',Spktp));
    EEGt = EEGt(~cellfun('isempty',Spktp));
    Spktp = Spktp(~cellfun('isempty',Spktp));
end

%% Extract files information
% trialInfo = strsplit(tfile,'\');
% trialID = trialInfo{end-1};
%
% spkInfo = strsplit(tfile,'\');
% spkID = spkInfo{end}(1:end-2);


%% Main Body
Distance = [];
Thetaphase = [];
Inspk = [];
for ff = 1:size(EEG,1)
    eeg = EEG{ff,1};
    eegt = EEGt{ff,1};
    spktp = Spktp{ff,1};
    
    %filter eeg with theta frequency band
    Ftheta = 8;    % Hz
    Fs = 1/mean(diff(eegt)); %sampling frequency in Hz
    
    % Select spikes that occur in high theta to delta power ratio
    spk2eeg_all = match(spktp,eegt);
    spk2eeg_log = false(size(eeg));
    spk2eeg_log(spk2eeg_all) = true;
    
    [in_eegind] = ThetaDeltaThreshold(eeg,eegt,power_ratio_threshold);
    
    spk2eeg = find(spk2eeg_log & in_eegind);
    [~, thetaphase] = SpikeThetaPhase(eeg,eegt,eegt(spk2eeg));
    
    % determine whether most of the spikes occur in the peak or trough of theta
    %     if mean(2*(1-cosd(180-thetaphase)))>2
    %         cut = 1; %peak-to-peak theta
    %         [~, thetaphase] = SpikeThetaPhase(eeg,eegt,eegt(spk2eeg),cut);
    %     else
    %         cut = 2; %trough-to-trough theta
    %     end
    cut = 2;
    % Assign theta cycle number
    thetaBP = fftbandpass(eeg,Fs,Ftheta-5,Ftheta-4,Ftheta+4,Ftheta+5);
    troughInd = localpeak(thetaBP,cut);
    cycID = zeros(size(eeg));
    cycnum = 1;
    for cc = 1:size(troughInd,2)-1
        
        cycID(troughInd(cc):troughInd(cc+1)) = cycnum;
        cycnum = cycnum+1;
        
    end
    
    % Identify accelerating and decelerating spikes
    spk_ac = false(size(spk2eeg));
    spk_dc = false(size(spk2eeg));
    for kk = 1:size(spk2eeg,1)
        
        if sum(spk2eeg>=spk2eeg(kk)-1*Fs & spk2eeg<spk2eeg(kk))<=4 && ...
                sum(spk2eeg<=spk2eeg(kk)+1*Fs & spk2eeg>spk2eeg(kk))>=8
            spk_ac(kk) = true;
            
        elseif sum(spk2eeg>=spk2eeg(kk)-1*Fs & spk2eeg<spk2eeg(kk))>=8 && ...
                sum(spk2eeg<=spk2eeg(kk)+1*Fs & spk2eeg>spk2eeg(kk))<=4
            spk_dc(kk) = true;
        end
        
    end
    % find the start and the end of spike events
    startspk_ind = spk2eeg([false; diff(spk_ac)==1]);
    endspk_ind = spk2eeg([diff(spk_dc)==-1; false]);
    pair_event = [];
    for ee = 1:size(startspk_ind,1)
        
        pair_event(ee,1) = startspk_ind(ee);
        if ~isempty(min(endspk_ind(endspk_ind>startspk_ind(ee))))
            pair_event(ee,2) = min(endspk_ind(endspk_ind>startspk_ind(ee)));
        else
            pair_event(ee,:) = [];
        end
    end
    
    if isempty(pair_event)
        continue
    end
    
    pair_event(pair_event(:,1)==0,:) = []; %remove zeros
    if size(pair_event,1) > 1
        repeat = [false; diff(pair_event(:,2))==0]; %remove event with repeated endings
        pair_event(repeat,:) = [];
    end
    
    if isempty(pair_event)
        continue
    end
    % remove inter-event interval less than 1.5 sec
    interval = pair_event(2:end,1)-pair_event(1:end-1,2);
    pair_event(interval<1.5*Fs,2)= NaN;
    pair_event([false; interval<1.5*Fs],1)= NaN;
    n_event = size(pair_event,1)-sum(isnan(pair_event(:,1)));
    final_event = reshape(pair_event(~isnan(pair_event)),n_event,2); %first column is the start and the second column is the end eeg index
    % remove long duration events
    duration = final_event(:,2)-final_event(:,1);
    final_event(duration>8000,:)=[]; %event should be no more than 4 sec or 8000 sampling points
    
    %     midpt = floor(diff(final_event,[],2)./2)+final_event(:,1);
    
    % Find the middle point of the theta cycle with maximal firing in each
    % event
    midpt = zeros(size(final_event,1),1);
    for mm = 1:size(midpt,1)
        holder = false(size(spk2eeg_log));
        holder(final_event(mm,1):final_event(mm,2)) = true;
        
        thetacyc = cycID(holder & spk2eeg_log & in_eegind);
        Cycle_n = max(thetacyc)-min(thetacyc)+1;
        [co,ce]=hist(thetacyc, Cycle_n);
        [~, maxloc] = max(co);
        centcyc = round(ce(maxloc));
        midpt(mm) = round(mean(find(cycID==centcyc)));
    end
    
    inspk = false(size(spk2eeg));
    distance = [];
    d = 0;
    conseq = false;
    temp = [];
    for kk = 1:size(spk2eeg,1)
        
        if sum(spk2eeg(kk)>=final_event(:,1) & spk2eeg(kk)<=final_event(:,2))==1;
            if cycID(spk2eeg(kk-1)) ~= cycID(spk2eeg(kk)) && ~conseq
                inspk(kk) = true;
                d = d+1;
                distance(d,1) = spk2eeg(kk)-midpt(spk2eeg(kk)>=final_event(:,1) & spk2eeg(kk)<=final_event(:,2));
            elseif cycID(spk2eeg(kk-1)) == cycID(spk2eeg(kk))
                conseq = true;
                temp = [temp; kk];
            elseif cycID(spk2eeg(kk-1)) ~= cycID(spk2eeg(kk)) && conseq
                % ensure odd number of samples
                if rem(size(temp,1),2) == 0
                    temp(end) = [];
                end
                ind = median(temp); %choose the middle spike in each theta cycle
                inspk(ind) = true;
                d = d+1;
                distance(d,1) = spk2eeg(ind)-midpt(spk2eeg(ind)>=final_event(:,1) & spk2eeg(ind)<=final_event(:,2));
                temp = [];
                conseq = false;
            end
            
        end
    end
    % Normalize event time
    %     breakpt = find(distance>0&[diff(distance)<0;false]);
    %     ndistance = zeros(size(distance));
    %     ndistance(1:breakpt(1)) = distance(1:breakpt(1))/max(abs(distance(1:breakpt(1))));
    %     for bb = 2:size(breakpt,1)
    %         range = breakpt(bb-1)+1:breakpt(bb);
    %         ndistance(range) = distance(range)/max(abs(distance(range)));
    %     end
    %     ndistance(breakpt(end)+1:end) = distance(breakpt(end)+1:end)/max(abs(distance(breakpt(end)+1:end)));
    
    Distance = [Distance; distance];
    Thetaphase = [Thetaphase; thetaphase];
    Inspk = [Inspk; inspk];
end

Inspk = logical(Inspk);
InThetaphase = Thetaphase(Inspk);


%% Plot results
fighandle = figure; plot(Distance,InThetaphase,'*')
hold on; plot(Distance,InThetaphase+360,'*')

if ~isempty(Distance)
    [para,z,p] = circ_lin_regress(Distance, InThetaphase,2/max(abs(Distance)));
    calphase = 2*pi*para(1,1)*[min(Distance):max(Distance)]+para(1,2);
    calphase = calphase*360/2/pi;
    if mean(calphase)<0
        calphase = calphase+360;
    end
    hold on; plot([min(Distance):max(Distance)],calphase,'r')
    plot([min(Distance):max(Distance)],calphase+360,'r')
else
    p = NaN;
end
axis square
figure(fighandle);
title(strcat(tfile,'      p-value: ', num2str(p)))

varargout{1} = Distance;
varargout{2} = InThetaphase;

keyboard

