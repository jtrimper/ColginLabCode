function evInds = find_lfp_events_in_filtered_ts2(filtEegData, broadFiltEegData, eegSf, pkThresh, edgeThresh, minDur, plotSwps)
% function evInds = find_lfp_events_in_filtered_ts2(filtEegData, broadFiltEegData, eegSf, pkThresh, edgeThresh, minDur, plotSwps)
%
% PURPOSE:
%  To get the edge indices for oscillatory events that meet the criteria specified.
%  This function also applies a second check, verifying that the directionality of the broadband trace
%  on average matches what you'd expect based on the filtered trace.
%
% INPUT:
%      filtEegData = eeg time series, filtered in range of interest
% broadFiltEegData = broadband eeg time series
%        eegSf = eeg sampling frequency (in Hz)
%     pkThresh = event peak detection threshold in standard deviations (suggestion: 2)
%   edgeThresh = event edge detection threshold in standard deviations (suggestion: 1)
%       minDur = minimum duration for an event in seconds; suggestion = 3 x average cycle length
%                 For Slow Gamma (25 - 50 Hz)
%                          Average frequency = 40 Hz
%                     Average cycle duration = 25 ms
%                       Three cycle duration = 75 ms
%                           suggested minDur = 0.075
%
%                 For Fast Gamma (65 - 100 Hz)
%                          Average frequency = 80 Hz
%                     Average cycle duration = 12.5 ms
%                       Three cycle duration = 37.5 ms
%                           suggested minDur = 0.0375
%       plotSwps = optional binary indicating whether or not to plot individual gamma event sweeps
%                  If left out, default is 0
%
%
% OUTPUT:
%      evInds = n x 2 matrix containing the indices for the edges of each event detected
%               evInds(:,1) = start indices
%               evInds(:,2) = end indices
%
%
% JBT 11/2016
% Colgin Lab


if nargin < 7
plotSwps = 0; %default plot swps to 0
end


%% GET THE EEG AMPLITUDE ENVELOPE
%   And find times when the amplitude envelope is above peak threshold
ampEnv = abs(hilbert(filtEegData)); 
ampEnv = (ampEnv - nanmean(ampEnv)) ./ nanstd(ampEnv); %z-score, ignoring nans (which come in before/after 1st/last peak)
highAmpInds = find(ampEnv>pkThresh);
neighbors = find(diff(highAmpInds)==1); %get rid of values right next to each other so this doesn't take all day
highAmpInds(neighbors + 1) = [];



%% GET THE EDGES AROUND EACH TIME WHERE THE ENVELOPE EXCEEDS THE PEAK THRESHOLD
highAmpEdges = [];
edgeCntr = 1;
for i = 1:length(highAmpInds)
    tmpStart = find(ampEnv(1:highAmpInds(i))<=edgeThresh, 1, 'Last');
    tmpEnd = find(ampEnv(highAmpInds(i):end)<=edgeThresh, 1, 'First');
    if ~isempty(tmpStart) && ~isempty(tmpEnd)
        edgeInd(1) = tmpStart;
        edgeInd(2) = tmpEnd + highAmpInds(i) - 1;
        minLength = round(minDur * eegSf);
        if diff(edgeInd) >= minLength
            highAmpEdges(edgeCntr,:) = edgeInd; %#ok
            edgeCntr = edgeCntr + 1;
        end
    end
end


%% ASSIGN OUTPUT
if ~isempty(highAmpEdges)
    highAmpEdges = unique(highAmpEdges, 'rows'); %get rid of 'events' with the same edges
    ctrInds = zeros(size(highAmpEdges,1), 1);
    for e = 1:size(highAmpEdges,1)
        [~,maxInd] = max(ampEnv(highAmpEdges(e,1):highAmpEdges(e,2)));
        ctrInds(e) = maxInd + highAmpEdges(e,1) - 1; %re-calibrate to entire LFP rather than just in this window
    end
    evInds = [highAmpEdges(:,1) ctrInds highAmpEdges(:,2)];
else
    evInds = [];
end


%% CHECK DIRECTIONALITY OF BROADBAND TRACE
badInds = [];
if plotSwps == 1
    figure('Position', [ 2         504        1020         434]);
end
for i = 1:size(evInds,1)
    startEv = evInds(i,1);%event indices
    endEv = evInds(i,3);
    gammaEvTrace = filtEegData(startEv:endEv);%gamma event trace
    bbEvTrace = broadFiltEegData(startEv:endEv);%broadband event trace
    pkInds = find_lfp_peaks(gammaEvTrace); %find peaks
    trInds = find_lfp_peaks(-gammaEvTrace);%find troughs
    [~,minInd] = min([pkInds(1) trInds(1)]);%find if a peak or a trough came first
    goodSwp = 1;%assume the sweep is good
    if minInd == 1
        dirCheck = -1;
    else
        dirCheck = 1;
    end
    pksAndTrs = sort([pkInds; trInds]);
    
    
    if plotSwps == 1
        hold on;
        plot(gammaEvTrace);
        plot(bbEvTrace, 'r');
        plot(pksAndTrs, gammaEvTrace(pksAndTrs), '*b');
        xlabel('Time (ms)');
        ylabel('Amplitude (\muV)')
        ln = line([0 length(gammaEvTrace)], [0 0]);
        set(ln, 'LineSTyle', '--', 'Color', [.5 .5 .5]);
        set(gca, 'FontSize', 18);
        xlim([0 length(gammaEvTrace)]);
        set(gca, 'XTick', [0 length(gammaEvTrace)], 'XTickLabel', [0 round(length(gammaEvTrace)/2000 * 1000,1)]);
    end
    
    numChunks = length(pksAndTrs)-1; 
    maxNumBad = numChunks / 3; 
    numBadChnks = 0; 
    for j = 1:numChunks
        
        chunkInds = pksAndTrs(j):pksAndTrs(j+1);
        chunkDir = sign(mean(diff(bbEvTrace(chunkInds)))); 
        if plotSwps == 1
            plot(chunkInds, bbEvTrace(chunkInds), 'Color', [0 0 0]);
        end
        
        if chunkDir == dirCheck
            if plotSwps == 1
                ln = line([chunkInds(1)+1 chunkInds(end)-1], [0 0]);
                set(ln, 'LineWidth', 3, 'Color', [0 .5 0]);
            end
        elseif chunkDir ~= dirCheck
            if plotSwps == 1
                ln = line([chunkInds(1)+1 chunkInds(end)-1], [0 0]);
                set(ln, 'LineWidth', 3, 'Color', [1 0 0]);
            end
            numBadChnks = numBadChnks + 1;
        end
        
        dirCheck = dirCheck * -1;
        if numBadChnks >= maxNumBad
            goodSwp = 0;
            break; 
        end
                    
    end
    
    if goodSwp == 0
        badInds = [badInds i]; %#ok
    end
    
    if plotSwps == 1
        pause
        clf
    end

end




evInds(badInds,:) = []; %get rid of the ones that didn't live up to their parents' expectations



end%function

