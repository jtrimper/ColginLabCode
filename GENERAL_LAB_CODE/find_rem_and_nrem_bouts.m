function [remEdgeInds, nremEdgeInds] = find_rem_and_nrem_bouts(lfpData, lfpFs, minDur)
% function [remEdgeInds, nremEdgeInds] = find_rem_and_nrem_bouts(lfpData, lfpFs, minDur)
%
% PURPOSE:
%  To identify bouts within the inputted EEG in which the rat was in REM sleep or NREM, based on
%  the theta-delta ratio.
%
% INPUT:
%       lfpData = eeg time series
%         lfpFs = eeg sampling frequency, in Hertz
%        minDur = minimum duration for each bout, in seconds
%
% OUTPUT:
%    remEdgeInds = LFP start & stop indices for when the rat was in REM sleep
%   nremEdgeInds = LFP start & stop indices for when the rat was in NREM sleep
%
%
% JB Trimper
% 11/2016
% Colgin Lab


%% ADJUSTABLE PARAMETERS
remTDRCut = 1.5; %TDR greater than ---> cutoff for REM
nremTDRCut = 1; %TDR less than ---> cutoff for NREM
plotResults = 0; %set to 1 to plot the results

winLength = 5;%s - for mw avg of TDR
winStep = .5; %s


%% CALCULATE DELTA POWER, WITH WAVELETS
deltaPow = get_wavelet_power(lfpData, lfpFs, [2 5], 6, 1, 0); %do NOT do decibel conversion but DO perform the old (energy) normalization
deltaPow = mean(deltaPow,1);  %avg across freq


%% CALCULATE THETA POWER, WITH WAVELETS
thetaPow = get_wavelet_power(lfpData, lfpFs, [6 10], 6, 1, 0);
thetaPow = mean(thetaPow,1); %avg across freq


%% CALCULATE THE THETA/DELTA RATIO
TDR = thetaPow ./ deltaPow;


%% GET A MW AVG OF THE TDR
[TDR, INDS] = mw_avg(TDR, winLength*lfpFs, winStep*lfpFs, 0);


%% FIND REM BOUTS
%   Identified by TDR > remTDRCut
remBin = bwconncomp(TDR > remTDRCut, 4);

remEdgeInds = [];
cntr = 1;
for c = 1:length(remBin.PixelIdxList)
    tmpInds = remBin.PixelIdxList{c};
    chunkDur = (tmpInds(end) - tmpInds(1)) * (INDS(2) - INDS(1)) / lfpFs;
    if chunkDur >= minDur
        remEdgeInds(cntr,:) = round([INDS(tmpInds(1)) INDS(tmpInds(end))]);  %#ok
        cntr = cntr + 1;
    end
end%chunks


%% FIND NREM BOUTS
%   Identified by TDR < nremTDRCut
nremBin = bwconncomp(TDR < nremTDRCut, 4);

nremEdgeInds = [];
cntr = 1;
for c = 1:length(nremBin.PixelIdxList)
    tmpInds = nremBin.PixelIdxList{c};
    chunkDur = (tmpInds(end) - tmpInds(1)) * (INDS(2) - INDS(1)) / lfpFs;
    if chunkDur >= minDur
        nremEdgeInds(cntr,:) = round([INDS(tmpInds(1)) INDS(tmpInds(end))]);  %#ok
        cntr = cntr + 1;
    end
end%chunks



%% PLOT THE RESULTS
if plotResults == 1
    
    % REM Sweeps
    if ~isempty(remEdgeInds)
        figure('name', 'REM');
        numBouts = size(remEdgeInds,1);
        if numBouts > 9
            numBouts = 9;
        end
        for e = 1:numBouts
            subplot(3,3,e);
            tmpInds = remEdgeInds(e,:);
            tmpInds(1) = tmpInds(1)-2000;
            tmpInds(2) = tmpInds(2) + 2000;
            if tmpInds(1) > 0 && tmpInds(2) <= length(lfpData)
                eegSeg = lfpData(tmpInds(1):tmpInds(2));
                plot(tmpInds(1):tmpInds(2),eegSeg);
                hold on;
                startInd = find(INDS<=tmpInds(1), 1, 'Last');
                endInd = find(INDS>=tmpInds(end), 1, 'First');
                plot(INDS(startInd:endInd), rescale(TDR(startInd:endInd), min(eegSeg), max(eegSeg)), 'r');
            end
        end
    end
    
    
    %NREM Sweeps
    if ~isempty(nremEdgeInds)
        figure('name', 'NREM');
        numBouts = size(nremEdgeInds,1);
        if numBouts > 9
            numBouts = 9;
        end
        for e = 1:numBouts
            subplot(3,3,e);
            tmpInds = nremEdgeInds(e,:);
            tmpInds(1) = tmpInds(1)-2000;
            tmpInds(2) = tmpInds(2) + 2000;
            if tmpInds(1) > 0 && tmpInds(2) <= length(lfpData)
                eegSeg = lfpData(tmpInds(1):tmpInds(2));
                plot(tmpInds(1):tmpInds(2),eegSeg);
                hold on;
                startInd = find(INDS<=tmpInds(1), 1, 'Last');
                endInd = find(INDS>=tmpInds(end), 1, 'First');
                plot(INDS(startInd:endInd), rescale(TDR(startInd:endInd), min(eegSeg), max(eegSeg)), 'r');
            end
        end
    end
    
end





end%function