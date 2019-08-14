function [spikesEeg] = SpikeTStoEegIndex(spikeTS, eegTS, Fs)

%  originally called 
%  "find_spike_times_rs13_no_phase.m"

% spikeTS is the time stamp for the spikes, output of the 'loadSpikes'
% function.
% eegTS is the time stamp for the EEG recordings)(NOT interpolated) (CSC file), one time
% stamp for every 512 points.  This variable is part of the output of the
% 'load_eeg' function.
% eeg is the CSC file containing the EEG recording to which the spikes will be aligned 

spikesEeg = [];
%eliminate spikes that occur earlier than the first time stamp of the EEG

% spikeTS = spikeTS(spikeTS >= eegTS(1));

for k = 1:length(spikeTS)
    % Find closest eeg timestamp to the current spike timestamp
    tDiff = (eegTS-spikeTS(k)).^2;
    [~,eegTS_boundary] = min(tDiff);
    
    % Time difference between eeg timestamp and spike timestamp
    diff = eegTS(eegTS_boundary) - spikeTS(k);
    
    if diff == 0 % Hit timestamp right on
        EegInd = 512*(eegTS_boundary-1)+1;
    elseif diff < 0 % Spike timestamp is in next 512 point data segment
        offset = round(abs(diff)*Fs);
        EegInd = 512*(eegTS_boundary-1)+1 + offset;
    else % Spike timestamp is in previous 512 point data segment
        offset = round(diff*Fs);
        EegInd = 512*(eegTS_boundary-1)+1 - offset;
    end

    spikesEeg = [spikesEeg,EegInd];
    
end
spikesEeg(spikesEeg<1) = 1;

    
   

