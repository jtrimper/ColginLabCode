function [rateMap, spkCnt, timePerBin] = get_ratemap(spkTms, coords, arenaSz, spatBinSz, plotOrNot, velFilt)
% function [rateMap, spkCnt, timePerBin] = get_ratemap(spkTms, coords, arenaSz, spatBinSz, plotOrNot, velFilt)
%
% PURPOSE:
%   To find the ratemap for a cell.
%
% INPUT:
%      spkTms = spike time vector (n x 1) in seconds
%      coords = coordinate matrix (n x 3) where (:,1) = frametimes, (:,2) = xPos, and (:,3) = yPos
%     arenaSz = 1x2 vector indicating x & y size of the arena (track, box, whatever) in centimeters
%   spatBinSz = size, in cm, of spatial bins.
%   plotOrNot = optional binary input indicating whether or not to plot the results
%                - if not provided, defaults to 0 (do not plot)
%     velFilt = optional binary input indicating whether or not to only consider spikes occuring
%               when the rat was moving >= 5 cm/s 
%                - if not provided, defaults to 0 (do not velocity filter)
%
% OUTPUT:
%     rateMap = raw, unsmoothed ratemap
%      spkCnt = spike counts for each spatial bin
%  timePerBin = time, in s, per spatial bin
%
% JB Trimper
% 7/19/17
% Colgin Lab




%% DEFAULT, IF NECESSARY, TO NOT PLOTTING
if nargin < 5 || isempty(plotOrNot)
    plotOrNot = 0;
end


%% DEFAULT, IF NECESSARY, TO NOT VELOCITY FILTERING
if nargin < 6 || isempty(velFilt)
    velFilt = 0;
end


numXBins = floor(arenaSz(1)/spatBinSz); 
numYBins = floor(arenaSz(2)/spatBinSz); 



%% PLOT THE RAT'S PATH
if plotOrNot == 1
    figure('Position', [253 298 1109 420])
    subplot(1,2,1);
    plot(coords(:,2), coords(:,3), 'r');
    title('Path');
    xlim([0 arenaSz(1)]);
    ylim([0 arenaSz(2)]);
    xlabel('Position (cm)')
    ylabel('Position (cm)')
    set(gca, 'FontSize', 14);
end



%% IF DOING VELOCITY FILTERED RATEMAP, GET A BINARY THAT INDICATES WHEN THE RAT WAS MOVING
if velFilt == 1
    
    runThresh = 5; %cm/s -- threshold for movement
    
    instRs = get_runspeed(coords);
    [mwRs, mwInds] = mw_avg(instRs(:,2),15,7,1); % moving window average the runspeed to 0.5 s windows with 0.23 s steps
    mwRs = [instRs(1:mwInds(1)-1) mwRs instRs(mwInds(end)+1:length(instRs))]; %make the length of the moving window version match
    velFiltBnry = zeros(1,length(mwRs));
    velFiltBnry(mwRs>=runThresh) = 1;
 
end



% This is used for making the time-stamps for when the rat was in each spatial bin more precise
halfFt = mean(diff(coords(:,1)))/2; %half of the frame-rate
%      Mark start time for when the rat was in each bin as the frame-time (mid-point) - half the frame rate
%      and mark the end time as frame-time (mid-point) + half the frame rate



%% GET THE TIMES WHEN THE RAT WAS IN EACH SPATIAL BIN
binTimes = cell(numXBins, numYBins); %catcher for time-stamps when rat is in each bin
binTimeSum = nan(numXBins, numYBins);
for x = 1:numXBins
    xRange = [(x-1)*spatBinSz x*spatBinSz];
    for y = 1:numYBins
        yRange = [(y-1)*spatBinSz y*spatBinSz];
        
        binInds = coords(:,2)>=xRange(1) & coords(:,2)<xRange(2) & coords(:,3)>=yRange(1) & coords(:,3)<yRange(2);
        %                   Indices for when the rat is in each spatial bin
        
        tmpTimeBinary = zeros(1,length(coords(:,1))); %make a binary corresponding to the frames he was in the bin
        tmpTimeBinary(binInds) = 1;
        
        if velFilt == 1
            tmpComboBnry = zeros(1,length(tmpTimeBinary));
            tmpComboBnry(tmpTimeBinary == 1 & velFiltBnry == 1) = 1;
            tmpTimeBinary = tmpComboBnry;
        end
        
        if sum(tmpTimeBinary) > 0 %if rat was in this spatial bin
            
            
            timeChunks = bwconncomp(tmpTimeBinary,4); %find chunks of time where rat was in this spatial bin
            cntr = 1;
            for c = 1:length(timeChunks.PixelIdxList)
                tmpChunkInds = [timeChunks.PixelIdxList{c}(1) timeChunks.PixelIdxList{c}(end)];
                tmpChunkTimes = coords(tmpChunkInds,1);
                binTimes{x,y}(cntr,:) =[tmpChunkTimes(1)-halfFt tmpChunkTimes(2)+halfFt]; %get start and end time for the chunk
                cntr = cntr + 1;
            end %for each chunk of time the rat was in this bin
            
            %NOTE: I'm doing it this 'chunk' way vs. just multiplying # of frames by time-per-frame because it helps in finding spikes below
            %      where I search for all spikes that occurred within each time window
            
            
            binTimeSum(x,y) = sum(diff(binTimes{x,y},[],2)); %amt of time rat spent in this spatial bin
            
        end %if the rat was in this spatial bin at all
        
    end %yRange
end %xRange


%% GET SPIKE COUNTS FOR EACH SPATIAL BIN
binSpkCnt = zeros(numXBins, numYBins);
for x = 1:numXBins
    for y = 1:numYBins
        if ~isempty(binTimes{x,y})
            for t = 1:size(binTimes{x,y},1)
                tmpTimeBnds = binTimes{x,y}(t,:);
                spkInds = find(spkTms>=tmpTimeBnds(1) & spkTms<=tmpTimeBnds(2)); 
                numSpks = length(spkInds); 
                
                if velFilt == 1 %if only looking at firing rate while the rat is moving
                    if ~isempty(spkInds)
                        for si = 1:length(spkInds)
                            spkTmInd = find(coords(:,1)>=spkTms(si), 1, 'First'); % doing '>=' because of the half-frame time adjustment above
                            if velFiltBnry(spkTmInd) == 0 %if the rat wasn't moving when this spike went off... 
                                numSpks = numSpks - 1; %don't count this spike
                            end
                        end
                    end
                end
                
                binSpkCnt(x,y) = binSpkCnt(x,y) + numSpks;
            end %each chunk of time
        end %if the rat was in this spatial bin
    end %y
end %x




%% CALCULATE THE RATE-MAP
rateMap = binSpkCnt ./ binTimeSum;
if plotOrNot == 1
    subplot(1,2,2);
    imagesc(rateMap)
    set(gca, 'Ydir', 'Normal')
    colorbar
    xTix = get(gca, 'XTick');
    yTix = get(gca, 'YTick');
    set(gca, 'XTick', xTix, 'YTick', yTix, 'XTickLabel', xTix*spatBinSz, 'YTickLabel', yTix*spatBinSz);
    xlabel('Position (cm)');
    ylabel('Position (cm)');
    title('Ratemap');
    set(gca, 'FontSize', 14)
end


%% ASSIGN OUTPUT
spkCnt = binSpkCnt;
timePerBin = binTimeSum;

end %function




