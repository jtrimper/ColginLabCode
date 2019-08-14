function [eeg_epoch_index2] = find_spike_times_rs13_no_phase_v2(TS_spikes, ts_eeg)

% TS_spikes is the time stamp for the spikes, output of the 'loadSpikes'
% function.
% ts_eeg is the time stamp for the EEG recordings (CSC file), one time
% stamp for every point.  This variable is part of the output of the
% 'load_eeg' function.
% EEG is the CSC file containing the EEG recording to which the spikes will be aligned 

%eeg_epochs_grouped = [];

eeg_epoch_index2 = [];

%sPhase = [];

%ts2 = ts_eeg / 1000000;  % converts spike time stamp from microseconds to seconds
ts2=ts_eeg; 
%eliminate spikes that occur earlier than the first time stamp of the EEG
% TS_spikes_index = find (TS_spikes > ts2(1));  
% TS2_spikes = TS_spikes (TS_spikes_index(1) : length(TS_spikes) );
TS2_spikes = TS_spikes(TS_spikes >= ts2(1) & TS_spikes <= ts2(end));

%EEG_theta_filter = bandpass(EEG, 6, 10, Fs );
%DTAS = hilbert(EEG_theta_filter);
%phase = angle(DTAS);

nSpikes = length(TS2_spikes);
%sPhase = zeros(nSpikes,1);

for k = 1:length(TS2_spikes)
    n = TS2_spikes(k);
%     [eeg_index_boundary] = find(n < ts2 & ts2 > n + 0.2705);

    % Find closest eeg timestamp to the current spike timestamp
    tDiff = (ts2-n).^2;
    [minDist,eeg_index_boundary] = min(tDiff);
    if length(eeg_index_boundary) > 1
        eeg_index_boundary = eeg_index_boundary(1);
    end
    
    eeg_epoch_index2 = [eeg_epoch_index2, eeg_index_boundary];
    

    
    
end


    
   

