function [fighandle] = SpkPhaseDist(tfile,EEGfile,varargin)
%% Set parameters
power_ratio_threshold = 2;
nbin = 90;

%% Load files
Spktp ={};
EEG ={}; EEGt ={};
% for single folder
if nargin < 3
    Spktp{1,1} = Readtfile(tfile);
    Spktp{1,1} = Spktp{1,1}./10000; %convert to sec
    [EEG{1,1}, EEGt{1,1}] = LoadEEG(EEGfile);

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

%% Main Body
SPK_ac = [];
SPK_dc = [];
Thetaphase = [];
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
    
    % Identify accelerating and decelerating spikes
    spk_ac = false(size(spk2eeg));
    spk_dc = false(size(spk2eeg));
    for kk = 1:size(spk2eeg,1)

        if sum(spk2eeg>=spk2eeg(kk)-1*Fs & spk2eeg<spk2eeg(kk))<=4 && ...
                sum(spk2eeg<=spk2eeg(kk)+1*Fs & spk2eeg>spk2eeg(kk))>=12
            spk_ac(kk) = true;

        elseif sum(spk2eeg>=spk2eeg(kk)-1*Fs & spk2eeg<spk2eeg(kk))>=12 && ...
                sum(spk2eeg<=spk2eeg(kk)+1*Fs & spk2eeg>spk2eeg(kk))<=4
            spk_dc(kk) = true;
        end

    end
        
    SPK_ac = [SPK_ac; spk_ac];
    SPK_dc = [SPK_dc; spk_dc];
    Thetaphase = [Thetaphase; thetaphase];

end
SPK_ac = logical(SPK_ac);
SPK_dc = logical(SPK_dc);


[tout_all,rout_all]=rose(Thetaphase,nbin);
if sum(SPK_ac)<1
    rout_ac = zeros(size(rout_all));
elseif sum(SPK_ac)>=1
    [~,rout_ac]=rose(Thetaphase(SPK_ac),nbin);
end

if sum(SPK_dc)<1
    rout_dc = zeros(size(rout_all));
elseif sum(SPK_dc)>=1
    [~,rout_dc]=rose(Thetaphase(SPK_dc),nbin);
end

prop_ac = rout_ac/size(Thetaphase,1);
prop_ac(isnan(prop_ac)) = 0;

prop_dc = rout_dc/size(Thetaphase,1);
prop_dc(isnan(prop_dc)) = 0;
%% Plot results
fighandle = polar(tout_all,prop_ac);
set(fighandle,'Color',[1 0 0])
hold on; polar(tout_all,prop_dc)
hold off
title(tfile)
