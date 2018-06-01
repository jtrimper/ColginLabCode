function [stInd, thetaFreq] = calc_theta_saw_index(phiStartTms)
% function [stInd, thetaFreq] = calc_theta_saw_index(phiStartTms)
%
% PURPOSE: 
%  To calculate an index of "sawtoothiness" which is the log transformed ratio of the 
%  falling phase frequency over the rising phase frequency
%
% INPUT: 
%  phiStartTms = the start times for each phase (PK, FALL, TR, RISE) of each theta cycle
%                4 x n, where n is # of theta cycles
%
% OUTPUT: 
%      stInd = the sawtooth index for each theta cycle 
%  thetaFreq = the estimated frequency for both the rising and falling phases of each theta cycle
%              n x 2
%
% JBT 1/2017
% Colgin Lab




%% PARAMETERS
sampRate = 2000; %Hz
rmOuts = 0; %set to 1 to remove outliers


%% FIND THE DURATION/LENGTH IN SAMPS OF EACH THETA PHASE
riseDur = phiStartTms(1,2:end) - phiStartTms(4,1:end-1); %duration of rise start to peak start = rise time
risePhiNumSamps = riseDur * sampRate; %number of samples in rising phase per sample
fallDur = phiStartTms(3,2:end) - phiStartTms(2,2:end); %duration of fall start to trough start = fall time
fallPhiNumSamps = fallDur * sampRate; %number of samples in falling phase per sample

%% FIND THE SLOPE CORRESPONDING TO THE RISING/FALLING PHASE OF THE THETA WAVES
numCycles = length(risePhiNumSamps); 
thetaSlopes = zeros(numCycles,2); 
for c = 1:numCycles
 tmpCoefs = polyfit([0 risePhiNumSamps(c)],[-.75 .75],1); 
 thetaSlopes(c,1) = tmpCoefs(1); %rising phase slope
 
 tmpCoefs = polyfit([0 fallPhiNumSamps(c)],[-.75 .75],1); %
 thetaSlopes(c,2) = tmpCoefs(1); %falling phase slope (but positive!)
end

if rmOuts == 1 %remove outliers optionally
    riseOutCut = mean(thetaSlopes(:,1)) + (numOutlierSTDs * std(thetaSlopes(:,1)));
    fallOutCut = mean(thetaSlopes(:,2)) + (numOutlierSTDs * std(thetaSlopes(:,2)));
    
    outInds = find(thetaSlopes(:,1)>=riseOutCut | thetaSlopes(:,2)>=fallOutCut);
    if ~isempty(outInds)
        thetaSlopes(outInds,:) = []; %throw out outliers
    end
end




%% FIND THE SLOPE THAT CORRESPONDS TO THE RISING/FALLING
%  PHASE OF SINE WAVES AT EACH FREQUENCY
freqRange = 1:100;
for fInd = 1:length(freqRange)
    f = freqRange(fInd);
    swpLength = (2000/f)/2000;
    swpLength = swpLength + .5*swpLength;
    x = make_a_sine_wave(1,f,swpLength,2000);
    pkInds = find_eeg_peaks(x');
    trInds = find_eeg_peaks(-x');
    
    negWave = x(pkInds(1):trInds(2)); %wave y values from peak to trough
    origWaveLength = length(negWave);
    negWave = interp1(1:length(negWave), negWave, rescale(1:1000, 1,origWaveLength)); 
    %up-sample it (hard af) to better pinpoint transition between phases
    
    fallInds(1) = find(negWave<=.75, 1, 'First'); %peak to falling index
    fallInds(2) = find(negWave<=-.75, 1, 'First'); %falling to trough index
    yInterp = negWave(fallInds); %associated y values (should be ~.75)
    
    tmpRsVctr = rescale([1 fallInds 1000], 1, origWaveLength); %rescale the x values (indices) back to the length of the original wave
    fallInds = tmpRsVctr(2:3);
    
    coefs = polyfit(fallInds,yInterp,1); %get the slope and intercept
    
    freqSlopes(fInd,:) = [f -coefs(1)];%#ok -- store the slope
end



%% FIND THE FREQUENCY THAT BEST CORRESPONDS TO EACH PHASE OF THE THETA WAVE
numCycles = size(thetaSlopes,1); 
thetaFreq = zeros(numCycles,2); 
for c = 1:numCycles
    fInd = find(freqSlopes(:,2)<=thetaSlopes(c,1), 1, 'Last'); 
    thetaFreq(c,1) = freqSlopes(fInd,1); 
    
    fInd = find(freqSlopes(:,2)<=thetaSlopes(c,2), 1, 'Last'); 
    thetaFreq(c,2) = freqSlopes(fInd,1); 
end

stInd = log10(thetaFreq(:,2) ./ thetaFreq(:,1)); 

%% FOR SIMPLICITY'S SAKE, SINCE WE THREW OUT THE FIRST CYCLE, JUST DUPLICATE 
%  THE SECOND CYCLE'S VALUES AS THE FIRST'S
stInd = [stInd(1); stInd]; 
thetaFreq = [thetaFreq(1,:); thetaFreq]; 



end %function