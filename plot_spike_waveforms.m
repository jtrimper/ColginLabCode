function plot_spike_waveforms(nttPath, spkTms)
% function plot_spike_waveforms(nttPath, spkTms)
%
% PURPOSE: 
%  To plot spike waveforms for visual inspection. 
%
% INPUT: 
%  nttPath = full path to *.ntt file, including file name
%   spkTms = spike times, in seconds, from the unit of interest that was 
%            previously separated from the ntt file being checked
%
% OUTPUT: 
%  A figure showing the average wave +/- std
%
% JB Trimper
% 2/2019
% Colgin Lab


%% LOAD IN THE WAVEFORM DATA FROM THE NTT FILE
[allSpkTms,allSpkWvs] = LoadNTT(nttPath);
allSpkTms = allSpkTms ./ 10^6; %convert to seconds
allSpkTms = round(allSpkTms,4); %round, for the sake of matching

spkTms = round(spkTms,4); %round the inputted spike times also


%% EXTRACT THE WAVEFORMS BY MATCHING THE SPIKE TIMES FROM THE CLUSTER OF INTEREST
unitWaveForms = [];
for st = 1:2:length(spkTms)
    fprintf('Spk #%d: ', st);
    spkInd = find(allSpkTms == spkTms(st));
    if ~isempty(spkInd)
        fprintf('MATCH\n');
        unitWaveForms = cat(3,unitWaveForms, allSpkWvs(:,:,spkInd));
    else
        fprintf('NO MATCH\n');
    end
end



%% GET THE AVERAGE AND STD WAVE
avgWave = mean(unitWaveForms,3);
stdWave = std(unitWaveForms,[],3);



%% DEFINE X-VALUES IN TERMS OF TIME
%   32 kHz Sampling Rate, so Waves = 1 ms Duration
xVals = 1:32;
xVals = xVals/32;


%% PLOT THE RESULT
figure('Position', [616   219   677   674]);
yBnds = [inf -inf]; 
for w = 1:4
    subplot(2,2,w);
    error_fill_plot(xVals, avgWave(:,w), stdWave(:,w), 'Black');
    axis square
    fix_font
    if w > 2
        xlabel('Time (ms)');
    end
    if mod(w,2) == 1
       ylabel('Amplitude (\muV)');
    end
    zero_line;
    title(['Wire #' num2str(w)]); 
    set(gca, 'XTick', 0:.25:1); 
    set(gca, 'XGrid', 'On', 'YGrid', 'On'); 
    tmpYBnds = get(gca, 'YLim'); 
    if tmpYBnds(1)<yBnds(1)
        yBnds(1) = tmpYBnds(1); 
    end
    if tmpYBnds(2)>yBnds(2)
        yBnds(2) = tmpYBnds(2); 
    end
end

for w = 1:4
   subplot(2,2,w); 
   ylim(yBnds); 
end






end %fnctn