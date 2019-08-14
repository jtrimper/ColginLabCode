function [gammaAmpByBinsXTets, phaseBins] = all_nsc_files_gamma_amp_by_theta_phase(directoryName, fRange, ampVers, plotOrNot)
% function [gammaAmpByBinsXTets, phaseBins] = all_nsc_files_gamma_amp_by_theta_phase(directoryName, fRange, ampVers, plotOrNot)
%
% PURPOSE:
%   Finds gamma amplitude by theta phase across the entire recording session for all LFPs within the
%   directory specified.
%
% INPUTS:
%        directoryName = the full path to the directory containing the LFP files (i.e., '*.ncs')
%               fRange = 1x2 vector of frequency range to assess the amplitude of (e.g., fRange = [6 10];
%              ampVers = scalar indicating whether to use (1) wavelet method or (2) amplitude envelope of filtered LFP
%            plotOrNot = OPTIONAL binary input indicating whether (1) or not (0) to plot the results (avg & error across tetrodes)
%
% OUTPUTS:
%   gammaAmpByBinsXTets = #Tets x #PhiBins(16) matrix giving you gamma amplitude by theta phase for each tetrode in the directory
%             phaseBins = 1 x 16 vector indicating the center of each of the 16 phase bins
%
% JB Trimper
% 05/2019
% Colgin Lab




%% IF plotOrNot IS NOT PROVIDED, DEFAULT TO NOT PLOTTING
if nargin < 4
    plotOrNot = 0;
end

%% GO TO FOLDER
cd(directoryName);


%% GET BINS TO SPLIT THETA INTO
numBins = 16;
phiBinEdges = linspace(-pi,pi,17); %16 bins from trough to trough (i.e., -pi to pi)
phaseBins = edges_to_x_vals(phiBinEdges); %the enters of the bins


%% GET A LIST OF THE LFP FILES
lfpFileInfo = dir('*ncs'); %get names of all *.ncs files in the directory

gammaAmpByBinsXTets = zeros(length(lfpFileInfo), numBins); %empty array to catch amp by phase across tetrodes

for tt = 1:length(lfpFileInfo)
    
    %% LOAD IN THE LFP
    lfpName = lfpFileInfo(tt).name; %get currently indexed LFP file name
    fprintf('Working on %s\n', lfpName);
    
    lfpStruct = read_in_lfp(lfpName); %read in LFP
    
    
    %% GET THETA PHASE FOR ENTIRE LFP
    thetaFiltData = filter_lfp(lfpStruct, 6, 10); %filter in theta range and broader range
    broadThetaFiltData = filter_lfp(lfpStruct, 3, 20);
    
    lfpStruct.narrowThetaLfp = thetaFiltData; %attach to data structure for LFP; enter names exactly as is
    lfpStruct.broadThetaLfp = broadThetaFiltData;
    
    thetaPhiVctr = get_asym_theta_phi_vector(lfpStruct); %get instantaneous theta phase
    
    
    
    %% GET GAMMA AMPLITUDE VECTOR
    
    if ampVers == 1
        
        % Version 1: Wavelet
        fxtPow = get_wavelet_power(lfpStruct.data, 2000, fRange, 7, 0, 0); %get power
        gammaPowVctr = mean(fxtPow,1); %average across frequency range
        
    else
        
        %Version 2: Amplitude of Discrete Time Analytic Signal Calculated via Hilbert Transform (AKA: Amplitude Envelope)
        fGammaFiltData = filter_lfp(lfpStruct, fRange(1), fRange(2)); %filter in f gamma range
        gammaPowVctr = abs(hilbert(fGammaFiltData)); %calculate amplitude envelope of filtered trace
        
    end
    
    
    
    %% GET AMPLITUDE BY THETA PHASE
    
    binGammaAmp = zeros(1,numBins);
    for b = 1:numBins
        binInds = thetaPhiVctr>=phiBinEdges(b) & thetaPhiVctr<phiBinEdges(b+1);
        binGammaAmp(b) = mean(gammaPowVctr(binInds));
    end
    
    gammaAmpByBinsXTets(tt,:) = binGammaAmp;
    
end




%% PLOT IT

if plotOrNot == 1
    figure('Position', [361   379  1095  464]);
    AVG = mean(gammaAmpByBinsXTets,1);
    ERR = std(gammaAmpByBinsXTets,[],1);
    errorbar(1:2*numBins, [AVG AVG], [ERR ERR]);
    set(gca, 'XTick', [0 4 8 12 16 20 24 28 32], 'XTickLabels', {'Trough', 'Rise', 'Peak', 'Fall'});
    fix_font;
    ylabel('Gamma Amplitude');
    xlabel('Theta Phase');
    
    
    figure;
    for tt = 1:7
        subplot(4,2,tt);
        plot(1:2*numBins, [gammaAmpByBinsXTets(tt,:) gammaAmpByBinsXTets(tt,:)]);
    end
end




end %function 
