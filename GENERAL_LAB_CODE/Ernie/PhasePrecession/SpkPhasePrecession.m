function SpkPhasePrecession(posfile,tfile,EEGfile,outdir,varargin) 

%% Load files
if nargin < 5
    [Post{1,1},X{1,1},~] = LoadPos(posfile);
    [spktp_all] = Readtfile(tfile)./10000;
    [EEG{1,1}, EEGt{1,1}] = LoadEEG(EEGfile);
    
    % cut out spikes at trackend
    [Spktp{1,1}] = CutTrackendSpk(spktp_all,X{1,1},Post{1,1});

elseif nargin < 6
    foldername = varargin{1};
    dirlist = targetfolder(foldername);
    for ff = 1:size(dirlist,1)
        tdir = strcat(dirlist{ff},'\',tfile);
        eegdir = strcat(dirlist{ff},'\',EEGfile);
        posdir = strcat(dirlist{ff},'\',posfile);
        
        [Post{ff,1},X{ff,1},~] = LoadPos(posdir);
        spkt_all =  Readtfile(tdir)./10000;
        [cutspkt] = CutTrackendSpk(spkt_all,X{ff,1},Post{ff,1}); % Remove trackend spikes
        Spktp{ff,1} = cutspkt;
        [EEG{ff,1}, EEGt{ff,1}] = LoadEEG(eegdir);
    end
%% Extract files information
if nargin < 5
    trialInfo = strsplit(posfile,'\');
    trialID = trialInfo{end-1};
end

spkInfo = strsplit(tfile,'\');
spkID = spkInfo{end}(1:end-2);

%% Main Body
Thetaphase_for = [];
Thetaphase_bak = [];
Spkpos_for = [];
Spkpos_bak = [];
for ii = 1:size(Spktp,1)
    spktp = Spktp{ii,1};
    eegt = EEGt{ii,1};
    eeg = EEG{ii,1};
    x = X{ii,1};
    post = Post{ii,1};
    
% Select spikes that occur in high theta to delta power ratio
spk2eeg_all = match(spktp,eegt);
[in_eegind] = ThetaDeltaThreshold(eeg,eegt,2);
in_eeg = find(in_eegind);
inspk = false(size(spktp));
for ee = 1:size(spk2eeg_all,1)
    if sum(in_eeg==spk2eeg_all(ee))>0
        inspk(ee) = true;
    end
end
spktp = spktp(inspk);

% determine whether zero phase should be trough or peak
[~, thetaphase] = SpikeThetaPhase(eeg,eegt,spktp);
if mean(2*(1-cosd(180-thetaphase)))>2
    cut = 1; %peak-to-peak theta
else
    cut = 2; %trough-to-trough theta
end

% select forward and backward run
[for_ind, bak_ind] = splitRun(x);

% select spikes that occurred in forward or backward run
spk2pos = match(spktp,post);
spk_for = false(size(spktp));
spk_bak = false(size(spktp));
for kk = 1:size(spk2pos,1)
    if any(find(for_ind)==spk2pos(kk))
        spk_for(kk) = true;
    elseif any(find(bak_ind)==spk2pos(kk))
        spk_bak(kk) = true;
    end
end

[~, thetaphase_for] = SpikeThetaPhase(eeg,eegt,spktp(spk_for),cut);
[~, thetaphase_bak] = SpikeThetaPhase(eeg,eegt,spktp(spk_bak),cut);

Thetaphase_for = [Thetaphase_for; thetaphase_for];
Thetaphase_bak = [Thetaphase_bak; thetaphase_bak];
Spkpos_for = [Spkpos_for x(spk2pos(spk_for))];
Spkpos_bak = [Spkpos_bak x(spk2pos(spk_bak))];

end
%% Plot and save reuslts 
h = figure;
plot(Spkpos_for,Thetaphase_for,'*'); hold on
plot(Spkpos_for,Thetaphase_for+360,'*'); hold off
set(h,'outerposition',[600 150 850 800])
axis square
h2 = figure;
plot(Spkpos_bak,Thetaphase_bak,'r*'); hold on 
plot(Spkpos_bak,Thetaphase_bak+360,'r*'); hold off
set(h2,'outerposition',[600 150 850 800])
axis square
if nargin < 5
    figure(h)
    title(['SpikePhasePosition_forwardrun Spike: ' spkID ' Trial: ' trialID])
    filename = strcat(outdir,'\SpikePhasePosition_forrun_',spkID,'_',trialID);
    figure(h2)
    title(['SpikePhasePosition_backwardrun Spike: ' spkID ' Trial: ' trialID])
    filename2 = strcat(outdir,'\SpikePhasePosition_bakrun_',spkID,'_',trialID);    
elseif nargin < 6
    figure(h)
    title(['SpikePhasePosition_forwardrun Spike: ' spkID])
    filename = strcat(outdir,'\SpikePhasePosition_forrun',spkID);
    figure(h2)
    title(['SpikePhasePosition_backwardrun Spike: ' spkID])
    filename2 = strcat(outdir,'\SpikePhasePosition_bakrun',spkID);    
end
imageStore(h,'png',filename)
close(h)
imageStore(h2,'png',filename2)
close(h2)
end
