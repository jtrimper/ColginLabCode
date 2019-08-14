 %Extract theta phase from the band pass filtered EEG signal by
% interpolating phases between peaks and troughs.
function [phase,peakPos,troughPos] = thetaPhase_from_Karel(eeg)

% Number of samples in eeg signal
N = length(eeg);
phase = zeros(1,N);
peakPos = zeros(1,N);
troughPos = zeros(1,N);
peakCount = 0;
troughCount = 0;

% Flag indicating if we are on the rising or falling part of the wave. 0 =
% falling part, 1 = rising part
rising = 0;
% Sample index to last known peak
lastPeak = 0;
% Sample index to last knows trough
lastTrough = 0;
% Index to the first sample after the first peak or trough
startIndex = 0;

% Find if first sample is on a rising or falling wave
first = eeg(1);
second = eeg(2);
if first < second
    rising = 1;
elseif first>second
    rising = 0;
else
    count = 2;
    while 1
        count = count + 1;
        if count == N
            break
        end
        if first < eeg(count)
            rising = 1;
            break
        end
        if first > eeg(count)
            rising = 0;
            break
        end
    end
end

% Locate the first peak or trough
for ii = 2:N
    if rising
        if eeg(ii) < eeg(ii-1)
            lastPeak = ii-1;
            rising = 0;
            startIndex = ii;
            % Add the peak to the peak array
            peakCount = peakCount + 1;
            peakPos(peakCount) = lastPeak;
            break;
        end
    else
        if eeg(ii) > eeg(ii-1)
            lastTrough = ii-1;
            rising = 1;
            startIndex = ii;
            % Add the trough to the trough array
            troughCount = troughCount + 1;
            troughPos(troughCount) = lastTrough;
            break
        end
    end
end

% Set the phase before the first peak/trough to NaN, cause it is not
% possible to calculate the phase of this section with this method
 phase(1:startIndex-1) = NaN;

% Calculate the phase of the theta (bandpass filtered eeg) based on the
% location of peaks and troughs in the signal. Peaks are set as 0/360
% degrees and the troughs are set to 180 degrees. Any sample in between the
% peaks and troughs are interpolated between these two values.
for ii = startIndex:N
    if rising
        if eeg(ii) < eeg(ii-1)
            lastPeak = ii-1;
            phase(lastPeak) = 0;
            numSamp = lastPeak - lastTrough - 1;
            samps = 1:numSamp;
            phase(lastTrough+1:lastPeak-1) = 180 + samps*180/(numSamp+1);
            rising = 0;
            % Add the peak to the peak array
            peakCount = peakCount + 1;
            peakPos(peakCount) = lastPeak;
        end
    else
        if eeg(ii) > eeg(ii-1)
            lastTrough = ii-1;
            phase(lastTrough) = 180;
            numSamp = lastTrough - lastPeak - 1;
            samps = 1:numSamp;
            phase(lastPeak+1:lastTrough-1) = samps*180/(numSamp+1);
            rising = 1;
            % Add the trough to the trough array
            troughCount = troughCount + 1;
            troughPos(troughCount) = lastTrough;
        end
    end
end

lastValue = max(lastPeak,lastTrough);
phase(lastValue+1:N) = NaN;

peakPos = peakPos(1:peakCount);


%______________________