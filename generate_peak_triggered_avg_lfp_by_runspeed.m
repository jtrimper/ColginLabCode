function moveSpeed = generate_peak_triggered_avg_lfp_by_runspeed(lfpStruct, coordsAndTs, plotResults)
% function moveSpeed = generate_peak_triggered_avg_lfp_by_runspeed(lfpStruct, coordsAndTs, plotResults)
%
% PURPOSE:
%   To generate plots of peak triggered LFP.
%
% INPUT:
%        lfpStruct = structure array with fields...
%                 -  lfpStruct.data = time series in micro-volts
%                 -  lfpStruct.Fs = lfp sampling frequency
%                 -  lfpStruct.filtLfpData* = filtered LFP time series in micro-volts
%                       *this is the trigger time series
%                       *aside from the filtered lfp time series, this structure is the output of read_in_lfp
%
%       coordsAndTs = n x 3 matrix where (:,1) = frame times, (:,2) = xPos, and (:,3) = yPos
%       plotResults = binary indicating whether or not to graph the peak triggered LFP
%
%
% OUTPUT:
%    moveSpeed(1:2) = structure with subfields...
%                       moveSpeed(m).AVG = average peak triggered wave
%                       moveSpeed(m).lfpSegs = The lfp segments around each detected peak
%                                                m x p matrix where m is the # of lfp segments and
%                                                p is the # of samples
%
% NOTES:
%   internal options to set...
%          (1) the amplitude threshold in SDs for peak detection
%          (1) the speed cut offs for fast vs. slow
%          (2) the # of cycles on each side of the peak to evaluate (and calculate runspeed over)
%          (3) whether to plot with error bars or not
%
% JB Trimper
% 10/2016
% Colgin Lab


%% SET PARAMETERS

ampThresh = 1.5; %SDs -- cutoff for when a peak is large enough amplitude to consider the LFP around it
numCycles = 12; %# of cycles to include on either side of the peak (also defines window in which to evaluate runSpeed)
speedCuts = [3 12; 12 96];
plotErr = 0; %set to 1 to plot error bars (SEM across segments)



%% BREAK UP THE Lfp STRUCTURE

origLfp = lfpStruct.data;
sampRate = lfpStruct.Fs;
filtLfp = lfpStruct.filtLfpData;
lfpTs = lfpStruct.ts;


%% GO!

pkInds = find_lfp_peaks(filtLfp); %find LFP peaks in filtered LFP

pkAmps = filtLfp(pkInds); %get the amplitude of each peak

zPkAmps = zscore(pkAmps); %zscore the peak amplitudes

largeAmpPkInds = pkInds(zPkAmps >= ampThresh);

pkToPkDist = mean(diff(pkInds)); %average # samples between peaks

numSampsEachWay = round(pkToPkDist*numCycles); %number of samples to extend plot in each direction from peak

for m = 1:2
    moveSpeed(m).lfpSegs = []; %#ok
end
cntr = [1 1];

if ~isempty(largeAmpPkInds) %if there were any peaks that surpassed threshold
    for i = 1:size(largeAmpPkInds)
        tmpInd = largeAmpPkInds(i);
        startInd = tmpInd - numSampsEachWay;
        endInd = tmpInd + numSampsEachWay;
        
        
        if startInd > 0 && endInd < length(origLfp)
            
            startTime = lfpTs(startInd);
            endTime = lfpTs(endInd);
            
            pkSegCoords = coordsAndTs(coordsAndTs(:,1) >= startTime & coordsAndTs(:,1) <= endTime,:);
            
            if size(pkSegCoords,1) > 1 %i don't know why, but one time I only got one frame worth of coords so this is side-stepping that
                
                instRunSpd = get_runspeed(pkSegCoords);
                
                pkSegRs = mean(instRunSpd(:,2));
                if pkSegRs >= speedCuts(1,1) && pkSegRs <= speedCuts(1,2) %then it goes in the slow motion category
                    moveSpeed(1).lfpSegs(cntr(1),:) = origLfp(tmpInd-numSampsEachWay:tmpInd+numSampsEachWay); 
                    cntr(1) = cntr(1) + 1;
                elseif pkSegRs >= speedCuts(2,1) && pkSegRs <= speedCuts(2,2) %then it goes in the fast motion category
                    moveSpeed(2).lfpSegs(cntr(2),:) = origLfp(tmpInd-numSampsEachWay:tmpInd+numSampsEachWay); 
                    cntr(2) = cntr(2) + 1;
                end
            end
        end
    end
end

%% FIND THE AVERAGE WAVE

for m = 1:2
    moveSpeed(m).AVG = mean(moveSpeed(m).lfpSegs);
end



%% PLOT RESULTS
if plotResults == 1
    
    figure;
    twoCols = {'Red', 'Green'};
    msNames = {'low', 'high'};
    for m = 1:2
        subplot(1,2,m);
        if ~isempty(moveSpeed(m).lfpSegs)
            
            AVG = moveSpeed(m).AVG;
            SEM = semfunct(moveSpeed(m).lfpSegs,1);
            
            xTime = -numSampsEachWay/sampRate:(1/sampRate):(numSampsEachWay/sampRate);
            if plotErr == 1
                error_fill_plot(xTime, AVG, SEM, twoCols{m});
            else
                ln = plot(xTime, AVG);
                set(ln, 'Color', rgb(twoCols{m}), 'LineWidth', 3);
            end
            xlabel('Time (s)');
            ylabel('Amplitude (\muV)');
            xlim([min(xTime) max(xTime)]);
            title({[msNames{m} ' speeds']; ['(' num2str(speedCuts(m,1)) '-' num2str(speedCuts(m,2)) 'cm/s)']});
            yRange(:,m) = get(gca, 'YLim'); %#ok
        else
            error('No lfpSegs to average or plot; likely that amplitude theshold (ampThresh) is too high for this data');
        end
    end
    
    %format plots for better visual and comparison across runspeeds
    for m = 1:2
        subplot(1,2,m);
        maxRangeVal = max(abs(yRange(:)));
        ylim([-maxRangeVal maxRangeVal])
        grid on;
        ln = line([min(xTime) max(xTime)], [0 0]); %y = 0 line
        set(ln, 'LineStyle', '--', 'Color', [0 0 0]);
        ln = line([0 0], [-maxRangeVal maxRangeVal]); %x = 0 line
        set(ln, 'LineStyle', '--', 'Color', [0 0 0]);
        
    end
    
end%plotResults


