function  [avgAmpPerBin, semAmpPerBin, avgSpdPerBin, ampsPerBin] = get_lfp_amp_by_runspeed(lfpAndTs, coordsAndTs, winLength)
% function  [avgAmpPerBin, semAmpPerBin, avgSpdPerBin, ampsPerBin] = get_lfp_amp_by_runspeed(lfpAndTs, coordsAndTs, winLength)
%
% PURPOSE:
%  To get the lfp amplitude by runspeed.
%
% INPUT:
%   lfpAndTs = n x 2 matrix where column 1 is time stamps for each lfp sample and col 2 is the time series
%   coordsAndTs = n x 3 matrix where col 1 is frame time for each sample, col2 is xPos and col3 is yPos
%   winLength = window size in seconds in which to evaluate lfp amplitude and run speed (note: is approximate; will be adjusted based on sampling rates)
%
% OUTPUT:
%   avgAmpPerBin = vector of average LFP amplitude per speed bin
%   semAmpPerBin = ..........SEM...................................................
%   avgSpdPerBin = ..................runspeed.....................................
%   ampsPerBin = cell array containing the amplitudes for each speed bin
%                *this one is not averaged to allow you to see how many samples went into it, since it will vary greatly across speeds
%
% JB Trimper
% 10/2016
% Colgin Lab



%% EXAMPLE CODE TO ORGANIZE INPUT
%
% % GET COORDS & FRAMETIMES
% coordFn = 'C:\LAB_STUFF\COLGIN_LAB_STUFF\Grid_Field_Migration\MEC_Recordings\rat74\04152015\begin1\VT1.nvt';
% coordsAndTs = read_in_coords(coordFn);
%
% % GET LFP TIME STAMPS
% dataStructFn = 'C:\LAB_STUFF\COLGIN_LAB_STUFF\Grid_Field_Migration\project_data_structure_100416';
% tmp = load(dataStructFn);
% rat = tmp.rat;
% lfpAndTs(:,1) = rat(4).session(8).runWin(1).lfpStruct.ts;
%
% % GET FAST GAMMA FILTERED LFP DATA
% filtLfpFn = 'C:\LAB_STUFF\COLGIN_LAB_STUFF\Grid_Field_Migration\Filtered_LFPs\R4S8B1_fGammaFiltLfp';
% tmp = load(filtLfpFn);
% lfpData = tmp.filtLfpData;
% lfpAndTs(:,2) = lfpData;
%
%


%% PARAMETERS

plotResults = 0; %set to 1 to plot a graph of the results

spdBinWidth = 5; %cm/s per bin

rndedVidSampRate = round(1/mean(diff(coordsAndTs(:,1)))); %Hz -- video sampling rate



%% GET RUN SPEED PER WINDOW OF winLength DURATION

instRunSpd = get_runspeed(coordsAndTs); %get instantaneous running speed for each frame
ttlNumRunSpdSamps = size(instRunSpd,1);
numRunSpeedSampsPerWin = floor(rndedVidSampRate .* winLength);
% fprintf('\n\nFYI: Actual duration of each run speed window is %0.04g s\n', numRunSpeedSampsPerWin / actVidSampRate);
numWins = floor(ttlNumRunSpdSamps / numRunSpeedSampsPerWin);
instRunSpd(numWins*numRunSpeedSampsPerWin+1:end,:) = [];
rshpRunSpd = reshape(instRunSpd', 2, numRunSpeedSampsPerWin, numWins);%reshape the run speed matrix into winLength segments

rsWinStartStopTimes = squeeze(rshpRunSpd(1,[1 end],:)); %start & stop times for each run speed window

spdPerWin = squeeze(mean(rshpRunSpd(2,:,:)));



%% GET LFP AMPLITUDE FOR EACH RUNSPEED WINDOW

lfpTs = lfpAndTs(:,1);
lfpData = lfpAndTs(:,2);
lfpAmpEnv = abs(hilbert(lfpData));


ampPerWin = zeros(size(rsWinStartStopTimes,2));
for i = 1:size(rsWinStartStopTimes,2)
    startWin = rsWinStartStopTimes(1,i);
    endWin = rsWinStartStopTimes(2,i);
    ampPerWin(i) = mean(lfpAmpEnv(lfpTs>= startWin & lfpTs<=endWin));
end



%% GET AVERAGE FOR EACH RUNSPEED

maxSpd = floor(max(spdPerWin));
spdBinEdgeVctr = 0:spdBinWidth:maxSpd;

avgAmpPerBin = zeros(1,length(spdBinEdgeVctr)-1);
semAmpPerBin = zeros(1,length(spdBinEdgeVctr)-1);
for i = 1:length(spdBinEdgeVctr)-1
    ampsPerBin{i} = ampPerWin(spdPerWin>=spdBinEdgeVctr(i) & spdPerWin<spdBinEdgeVctr(i+1)); %#ok
    if ~isempty(ampsPerBin)
        avgAmpPerBin(i) = mean(ampsPerBin{i});
        semAmpPerBin(i) = semfunct(ampsPerBin{i},1);
    end
end




%% GET AVERAGE SPEED PER SPEED BIN

tmpSpdBins(:,1) = spdBinEdgeVctr(1:end-1);
tmpSpdBins(:,2) = spdBinEdgeVctr(2:end);
xVctr = mean(tmpSpdBins,2);
avgSpdPerBin = xVctr;




%% OPTIONAL PLOTTING
if plotResults == 1
    figure;
    error_fill_plot(xVctr(~isnan(avgAmpPerBin)), avgAmpPerBin(~isnan(avgAmpPerBin)), semAmpPerBin(~isnan(avgAmpPerBin)), 'Teal');
    xlabel('Speed (cm/s)');
    ylabel('LFP Amplitude (\muV)');
    
    coefs = polyfit(1:length(avgAmpPerBin), avgAmpPerBin, 2);
    xVals = 1:length(avgAmpPerBin);
    plot(avgSpdPerBin, coefs(1)*xVals.^2 + coefs(2)*xVals + coefs(3), 'Color', rgb('Orange'), 'LineWidth', 2);
end



end%function








