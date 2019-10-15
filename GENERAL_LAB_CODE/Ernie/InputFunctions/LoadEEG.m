function [EEG,ts_EEG,sampFreq,bv,ir] = LoadEEG(EEGfile)

fieldSelection(1) = 1; % Timestamps
fieldSelection(2) = 1; % Channel number
fieldSelection(3) = 1; % Sample Frequency
fieldSelection(4) = 1; % Number of valid samples
fieldSelection(5) = 1; % Samples
extractHeader = 1;
extractMode = 1; % Extract all data

[ts,chNum,sampFreq,numSamp,eegdata,header] = Nlx2MatCSC(EEGfile,fieldSelection,extractHeader,extractMode);

eegdata_original = eegdata;
eegdata = reshape(eegdata,[],1);
ts = ts*1e-6;
sampFreq = sampFreq(1);
ts_eeg = zeros(size(eegdata_original));
eegPtsPerStep = size(eegdata_original,1);
ts_eeg = repmat(ts,eegPtsPerStep,1);
eegTimeDiff = diff(ts);
eegTimeStep = repmat(eegTimeDiff/eegPtsPerStep,eegPtsPerStep,1);
eegTimeStep(1,:) = 0;
eegTimeStep = cumsum(eegTimeStep);
ts_eeg(:,1:end-1) = ts_eeg(:,1:end-1)+eegTimeStep;
ts_eeg(:,end) = ts_eeg(:,end)+eegTimeStep(:,end);
ts_EEG = reshape(ts_eeg,[],1);

for ii = 1:size(header,1)
    if ~isempty(strfind(header{ii},'-ADBitVolts'))
        bvloc = ii;
    end
    if ~isempty(strfind(header{ii},'-InputRange'))
        irloc = ii;
    end
end
bv = str2num(header{bvloc}(13:end))*10^6;  %bit-microvolt conversion
ir = str2num(header{irloc}(13:end));  %Input range in microvolts


EEG=eegdata;