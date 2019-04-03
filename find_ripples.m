function ripInfo = find_ripples(lfpStruct, coords, thetaDelta, plotCheck)
% function find_ripples(lfp, coords))
%
% PURPOSE:
%  To get the time stamps and indices for ripple events
%
% INPUT:
%   lfpStruct = lfp data structure
%               with fields:
%                     data = raw lfp time series, converted to micro-volts
%                       ts = time stamps, same length as 'data'
%                       Fs = sampling frequency
%            ripFiltLfp*^ = lfp filtered in ripple frequency range (~150 - 300 Hz)
%                             *this one is not automatic output for the read_in_lfp function.
%                              You've got to filter the LFP and attach it to the structure
%            Optional Fields, needed if thetaDelt == 1
%               thetaFiltLfp^ = lfp filtered in theta frequency range (6-12 Hz)
%               deltaFiltLfp^ = lfp filtered in delta frequency range (2-4 Hz)
%                                 ^All three of these filter ranges can be quickly attached with 'filter_lfp_for_rip_detection'
%
%                  coords = n x 3 matrix where column 1 equals frametimes, column 2 = xPos, and column 3 = yPos
%               thetaDelt = optional binary input indicating whether (1) or not (0) to only evaluate presence
%                           of ripples when TDR (calculated via amplitude of theta/delta filtered LFPs) is low enough
%                           -- If empty or absent, defaults to 1
%               plotCheck = optional binary input indicating whether (1) or not (0) to plot up to the first 10 detected ripple 
%                           for visual inspection
%                           -- If empty or absent, defaults to 0
%
% OUTPUT:
%       ripInfo = structure containing time-stamps and indices relative to LFP structure for when each ripple occurred
%                 - ripInfo.times = n x 2 matrix where column 1 equals start times and column 2 equals end times
%                 -  ripInfo.inds = n x 2 matrix where column 1 equals start index and column 2 equals end index
%
% JB Trimper
% 10/16
% Colgin Lab



%% SET PARAMETERS

pkCut = 7;%# SDs required for ripple peak detection
edgeCut = 3; % #SDs required for ripple edge detection
maxCut = 15; % #SDs for which ripple peak must be below to be included

winLength = 10; %s - window size around each event in which to evaluate speed
maxSpd = 5;%cm/s  - max speed allowable when a 'ripple' occurs

if nargin < 3 || isempty(thetaDelta)
    thetaDelta = 1; %set to 1 to only consider something a ripple if the theta-delta ratio is low
end

if nargin < 4 || isempty(plotCheck)
plotCheck = 0; %set to 1 to plot detected events for visual inspection
end


%% IDENTIFY TIMES WHEN RIPPLE POWER PEAKS

ripPow = zscore(abs(hilbert(lfpStruct.ripFiltLfp)));
ripCandInds = find(ripPow >= pkCut & ripPow <= maxCut);
indDiffs = [0; diff(ripCandInds)]; %get rid of indices for peaks that are right next to each other
ripCandInds(indDiffs == 1) = [];



%% FIND THE EDGES AROUND EACH PEAK

for i = 1:length(ripCandInds)
    pkInd = ripCandInds(i);
    startEdge = find(ripPow(1:pkInd) < edgeCut, 1, 'Last');
    endEdge = find(ripPow(pkInd:end) < edgeCut, 1, 'First');
    endEdge = endEdge + pkInd;
    
    ripEdges(i,:) = [startEdge endEdge]; %#ok
end


%% GET RID OF DETECTED EVENTS THAT SHARE EDGES

i = 2;
while i < size(ripEdges,1)
    if ripEdges(i,2) == ripEdges(i-1,2)
        ripEdges(i,:) = [];
    else
        i = i+1;
    end
end




%% COMBINE EVENTS WITHIN 20ms OF ONE ANOTHER

ripEdgeTimes = lfpStruct.ts(ripEdges);

i = 2;
while i < size(ripEdges,1)
    if (ripEdgeTimes(i,1) - ripEdgeTimes(i-1,2)) <= .020
        ripEdges(i-1,2) = ripEdges(i,2);
        ripEdgeTimes(i-1,2) = ripEdgeTimes(i,2);
        ripEdges(i,:) = [];
        ripEdgeTimes(i,:) = [];
    else
        i = i+1;
    end
end




%% GET RID OF EVENTS THAT ARE MORE THAN 150ms IN LENGTH or LESS THAN 20ms

evDurs = diff(ripEdgeTimes,1,2);

ripEdgeTimes(evDurs >= .150,:) = [];
ripEdges(evDurs >= .150,:) = [];

ripEdgeTimes(evDurs <= .020,:) = [];
ripEdges(evDurs <= .020,:) = [];




%% VERIFY THAT SPEED WAS LESS THAN 5 cm/s IN THE 10s WINDOW AROUND EACH EVENT

instRunSpd = get_runspeed(coords);
ripCtrTimes = mean(ripEdgeTimes,2);
i = 1;
while i <= size(ripEdgeTimes,1)
    evSpd = mean(instRunSpd(instRunSpd(:,1) >= ripCtrTimes(i) - (winLength / 2) & instRunSpd(:,1) <= ripCtrTimes(i) + (winLength / 2),2));
    if evSpd > maxSpd
        ripCtrTimes(i) = [];
        ripEdgeTimes(i,:) = [];
        ripEdges(i,:) = [];
    else
        i = i+1;
    end
end



%% OPTIONALLY IMPOSE THETA/DELTA RATIO CRITERIA

if thetaDelta == 1
    
    deltaAmpTs = abs(hilbert(lfpStruct.deltaFiltLfp));
    thetaAmpTs = abs(hilbert(lfpStruct.thetaFiltLfp));
    
    thetaDeltaRatio = thetaAmpTs ./ deltaAmpTs;
    
    thetaDeltaRatio(thetaDeltaRatio == Inf) =  max(thetaDeltaRatio(thetaDeltaRatio~=Inf)); %get rid of infinites
    thetaDeltaRatio(thetaDeltaRatio == 0) = 0.0001; %get rid of zeros
    
    avg = nanmean(thetaDeltaRatio);
    stdev = nanstd(thetaDeltaRatio);
    
    thetaDeltaRatio = (thetaDeltaRatio - avg) ./ stdev;
    
    ripCtrInds = round(mean(ripEdges,2));
    
    i = 1;
    while i <= size(ripCtrInds)
        windowTDR = mean(thetaDeltaRatio(ripCtrInds(i) - round(lfpStruct.Fs * (winLength/2)):ripCtrInds(i) + round(lfpStruct.Fs * (winLength/2))));
        if windowTDR > 0
            ripCtrInds(i) = [];
            ripEdgeTimes(i,:) = [];
            ripEdges(i,:) = [];
        else
            i = i+1;
        end
    end
end




%% CHECK DETECTION

if plotCheck == 1
    
    figure;
    numPlots = size(ripEdges,1);
    if numPlots > 10
        numPlots = 10;
    end
    
    offSet = 150;
    for i = 1:numPlots
        subplot(2,5,i);
        hold on;
        
        startInd = ripEdges(i,1);
        endInd = ripEdges(i,2);
        
        plot(startInd-offSet:endInd+offSet, rescale(lfpStruct.ripFiltLfp(startInd-offSet:endInd+offSet),0,1), 'g');
        plot(startInd-offSet:endInd+offSet, rescale(ripPow(startInd-offSet:endInd+offSet),.5,1), 'm');
        plot(startInd:endInd, rescale(lfpStruct.ripFiltLfp(startInd:endInd),0,1), 'k');
        
    end
    
end


%% ASSIGN OUTPUT

ripInfo.times = ripEdgeTimes; 
ripInfo.inds = ripEdges; 
