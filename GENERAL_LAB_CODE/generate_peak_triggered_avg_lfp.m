function lfpSegs = generate_peak_triggered_avg_lfp(lfpStruct, plotResults)
% function lfpSegs = generate_peak_triggered_avg_lfp(lfpStruct, plotResults)
%
% PURPOSE:
%   To generate plots of peak triggered LFP.
%
% INPUT:
%        lfpStruct = structure array with fields...
%                 -  lfpStruct.data = time series in micro-volts
%                 -  lfpStruct.Fs = lfp sampling frequency
%                 -  lfpStruct.filtLfpData* = filtered LFP time series in micro-volts
%                       *aside from the filtered lfp time series, this structure is the output of read_in_lfp
%      plotResults = binary indicating whether or not to graph the peak triggered LFP
%
% OUTPUT:
%    lfpSegs = The lfp segments around each detected peak
%             m x p matrix where m is the # of lfp segments and p is the # of samples
%
% NOTES:
%   internal options to set...
%          (1) the amplitude threshold in SDs for peak detection
%          (2) the # of cycles on each side of the peak to evaluate (and calculate runspeed over)
%          (3) whether to plot with error bars or not
%
% JB Trimper 
% 10/2016
% Colgin Lab





%% PARAMETERS
ampThresh = 1.5; %SDs -- cutoff for when a peak is large enough amplitude to consider the LFP around it
numCycles = 3; %# of cycles to include on either side of the peak
plotErr = 0; %set to 1 to plot error bars (standard deviation across segments)



%% BREAK UP THE STRUCTURE

origlfp = lfpStruct.data;
sampRate = lfpStruct.Fs;
filtlfp = lfpStruct.filtLfpData;



%% GO!

pkInds = find_lfp_peaks(filtlfp); %find lfp peaks in filtered lfp

pkAmps = filtlfp(pkInds); %get the amplitude of each peak

zPkAmps = zscore(pkAmps); %zscore the peak amplitudes

largeAmpPkInds = pkInds(zPkAmps >= ampThresh);

pkToPkDist = mean(diff(pkInds)); %average # samples between peaks

numSampsEachWay = round(pkToPkDist*numCycles); %number of samples to extend plot in each direction from peak

lfpSegs = [];
cntr = 1;
if ~isempty(largeAmpPkInds)
    for i = 1:size(largeAmpPkInds)
        tmpInd = largeAmpPkInds(i);
        startInd = tmpInd - numSampsEachWay;
        endInd = tmpInd + numSampsEachWay;
        if startInd > 0 && endInd < length(origlfp)
            lfpSegs(cntr,:) = origlfp(tmpInd-numSampsEachWay:tmpInd+numSampsEachWay); %#ok
            cntr = cntr + 1;
        end
    end
end



%% PLOT RESULTS
if plotResults == 1
    if ~isempty(lfpSegs)
        AVG = mean(lfpSegs);
        SEM = semfunct(lfpSegs,1);
        xTime = -numSampsEachWay/sampRate:(1/sampRate):(numSampsEachWay/sampRate);
        figure;
        if plotErr == 1
            error_fill_plot(xTime, AVG, SEM, 'Purple');
        else
            ln = plot(xTime, AVG);
            set(ln, 'Color', rgb('Purple'), 'LineWidth', 3);
        end
        
        xlabel('Time (s)');
        ylabel('Amplitude (\muV)');
        grid on;
        yRange = get(gca, 'YLim');
        ylim([-max(abs(yRange)) max(abs(yRange))]);
        xlim([min(xTime) max(xTime)]);
        
        ln = line([min(xTime) max(xTime)], [0 0]); %y = 0 line
        set(ln, 'LineStyle', '--', 'Color', [0 0 0]);
        ln = line([0 0], [-max(abs(yRange)) max(abs(yRange))]); %x = 0 line
        set(ln, 'LineStyle', '--', 'Color', [0 0 0]);
    else
        error('No lfpSegs to average or plot; likely that amplitude theshold (ampThresh) is too high for this data');
    end
end


