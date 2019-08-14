function  [episode_spike_time, episode_spike_time_index] = get_spike_times_within_specific_eeg_windows(startTime, stopTime, spike_time)

sampCounter = 0;
temp = spike_time;
for jj = 1:length(startTime)
        ind = find(temp >= startTime(jj) & temp <= stopTime(jj));
        N = length(ind);
        episode_spike_time(sampCounter+1:sampCounter+N) = temp(ind);
        episode_spike_time_index(sampCounter+1:sampCounter+N) = ind;
        sampCounter = sampCounter + N;
end
