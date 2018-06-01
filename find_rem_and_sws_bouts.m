function [remEdgeInds, swsEdgeInds] = find_rem_and_sws_bouts(lfpData, lfpFs, minDur)
% function [remEdgeInds, swsEdgeInds] = find_rem_and_sws_bouts(lfpData, lfpFs, minDur)
%
% PURPOSE: 
%  To identify bouts within the inputted EEG in which the rat was in REM sleep or SWS, based on 
%  the theta-delta ratio. 
%
% INPUT: 
%       lfpData = eeg time series
%         lfpFs = eeg sampling frequency, in Hertz
%        minDur = minimum duration for each bout, in seconds
%
% OUTPUT: 
%   remEdgeInds = LFP start & stop indices for when the rat was in REM sleep
%   swsEdgeInds = LFP start & stop indices for when the rat was in SWS sleep
%
%
% JBT 11/2016
% Colgin Lab


%% ADJUSTABLE PARAMETERS
remTDRCut = 1.5; %TDR greater than ---> cutoff for REM
swsTDRCut = .75; %TDR less than ---> cutoff for SWS
plotResults = 0; %set to 1 to plot the results

winLength = 2;%s - for mw avg of TDR
winStep = .5; %s 


%% CALCULATE DELTA POWER, WITH WAVELETS
deltaPow = get_wavelet_power(lfpData, lfpFs, [2 5], 7, 0, 0); %do NOT do decibel conversion (leave as mV^2)
deltaPow = mean(deltaPow,1);  %avg across freq



%% CALCULATE THETA POWER, WITH WAVELETS
thetaPow = get_wavelet_power(lfpData, lfpFs, [6 10], 7, 0, 0);
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


%% FIND SWS BOUTS 
%   Identified by TDR < swsTDRCut
swsBin = bwconncomp(TDR < swsTDRCut, 4); 

swsEdgeInds = []; 
cntr = 1; 
for c = 1:length(swsBin.PixelIdxList)
    tmpInds = swsBin.PixelIdxList{c}; 
    chunkDur = (tmpInds(end) - tmpInds(1)) * (INDS(2) - INDS(1)) / lfpFs;
    if chunkDur >= minDur
        swsEdgeInds(cntr,:) = round([INDS(tmpInds(1)) INDS(tmpInds(end))]);  %#ok 
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
    
    
    %SWS Sweeps
    if ~isempty(swsEdgeInds)
        figure('name', 'SWS');
        numBouts = size(swsEdgeInds,1);
        if numBouts > 9
            numBouts = 9;
        end
        for e = 1:numBouts
            subplot(3,3,e);
            tmpInds = swsEdgeInds(e,:);
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