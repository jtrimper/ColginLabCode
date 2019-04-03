function [COMOD, phiVctr, ampVctr] = calc_comod_index(data, Fs, phiRange, ampRange, numPadSampsPerSide, plotOpt)
% function [COMOD, phiVctr, ampVctr] = calc_comod_index(data, Fs, phiRange, ampRange, numPadSampsPerSide, plotOpt)
%
% PURPOSE:
%  To calculate Adriano Tort's comodulation index for comodulogram plotting. Output is phiFreq x ampFreq. 
%
% INPUT:
%               data = 1xn time-series of LFP data
%                 Fs = sampling frequency, in Hz
%           phiRange = 1x2 vector indicating edges of phase frequencies to be considered
%                      Note: bw is +/- 2 so take that into account (i.e., >2)
%           ampRange = 1x2 vector indicating edges of amplitude frequencies to be considered
%                      Note: bw is +/- 5 so take that into account (i.e., >5)
% numPadSampsPerSide = For the filter to work, data length needs to be at least 3x the filter order.
%                      So to work around this, you can pad the LFP by attaching extra samples on each side,
%                      filtering the trace, then lopping off those extra samples. This input indicates how many
%                      extra samples you've added on each side.
%            plotOpt = optional binary indicating whether(1) or not(0) to plot the comodulogram
%                      If left out, default is 0
%
% OUTPUT:
%       COMOD = phi x amplitude comodulation matrix
%     phiVctr = vector of phase frequencies corresponding to COMOD
%     ampVctr = vector of amplitude frequencies corresponding to COMOD
%
% NOTE:
%    1) Transposed into my style from Adriano Tort's code, which was given to Joe Manns.
%    2) To plot: contourf(phiVctr,ampVctr,COMOD',30,'lines','none')
%
% JB Trimper
% 11/2016
% Colgin Lab



%% SOME BASICS...
if nargin < 6
    plotOpt = 0; %to plot or not to plot, that is the question
end
dataLength = length(data);



%% PHASE AND AMPLITUDE FREQUENCY VECTORS
phiVctr = phiRange(1):2:phiRange(2);
phiBw = 4;
ampVctr = ampRange(1):5:ampRange(2);
ampBw = 10;


%% PHASE BINS
nBin = 18;
posn = zeros(1,nBin);
winSize = 2*pi/nBin;
for b = 1:nBin
    posn(b) = -pi+(b-1)*winSize;
end



%% FILTERING AND AMPLITUDE ENVELOPE/PHASE EXTRACTION

for a = 1:length(ampVctr)
    a1 = ampVctr(a) - (ampBw/2);
    a2 = a1+ampBw;
    ampFilt = eegfilt(data,Fs,a1,a2, dataLength); % just filtering
    ampFilt(1:numPadSampsPerSide) = [];
    ampFilt(end-numPadSampsPerSide+1:end) = [];
    ampTs(a, :) = abs(hilbert(ampFilt)); %#ok -  getting the amplitude envelope
end

for p = 1:length(phiVctr)
    p1 = phiVctr(p) - (phiBw/2);
    p2 = p1 + phiBw;
    phiFilt = eegfilt(data,Fs,p1,p2, dataLength);
    phiFilt(1:numPadSampsPerSide) = [];
    phiFilt(end-numPadSampsPerSide+1:end) = [];
    phiTs(p, :) = angle(hilbert(phiFilt)); %#ok -  this is getting the phase time series
end



%% CALCULATE COMODULATION
cntr1=0;
for p=1:length(phiVctr)
    cntr1 = cntr1+1;
    
    cntr2 = 0;
    for a=1:length(ampVctr)
        cntr2 = cntr2+1;
        MI = ModIndex_v2(phiTs(p, :), ampTs(a, :), posn);
        COMOD(cntr1,cntr2) = MI; %#ok
    end
end


%% PLOT COMODULATION
%   Optional

if plotOpt == 1
    figure;
    contourf(phiVctr,ampVctr,COMOD',30,'lines','none')
    set(gca,'fontsize',14)
    ylabel('Amplitude Frequency (Hz)')
    xlabel('Phase Frequency (Hz)')
    colorbar
end



end%function
