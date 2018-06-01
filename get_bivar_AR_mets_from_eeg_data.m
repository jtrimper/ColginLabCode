function [DTF, S, COH, fVals, params] = get_bivar_AR_mets_from_eeg_data(eegData, params)
% function [DTF, S, COH, fVals, params] = get_bivar_AR_mets_from_eeg_data(eegData, params)
%
% In a way similar to 'calc_bivariate_AR_metrics_via_mvgc', this function uses MVGC and BIOSIG toolboxes to 
% calclate bivariate auto-regressive metrics (non-normalized directed transfer function, cross-spectrum, and coherence). 
%
% Function differs from 'calc_bivariate...' because this function operates on eeg data for a single pair of subregions, 
%  whereas 'calc_bivariate...' does all conditions for all rats and all subregin pairs
%
% INPUT:
%    eegData = eeg data in the form of samples x sweeps x regions(2)
%    params = parameters for AR model coefficient calculation; 
%             This is optional input. If left blank, function will use default parameters at top of function. 
%
% OUTPUT: 
%          ~ all in the form freqBins x 1 ~
%
%    DTF = non-normalized directed transfer function
%      S = cross-spectrum
%    COH = Fisher-transformed coherence
% 
%JBT 4/2016


%% SET UP PARAMETERS
downData = 1; %set to 1 to downsample data by downsample factors indicated in params
Fs = 1500; %Hz - sampling frequency (for mvfreqz)
regmode   = 'LWR';   % VAR model estimation regression mode ('OLS', 'LWR')

if nargin < 3 %if no AMVAR parameters provided, use default... 
    %--AMVAR Params
    %----set 1
    params(1).fpass = [5 13];
    params(1).dsFact = 14; %Downsample factor -- calculated as: round(1500/(params(1).fpass(2)*8)) (8 times the highest frequency in this range; 8 to avoid aliasing)
    params(1).mOrder = 20; %Model order (20 samples of data downsampled by a factor of 14 to 107Hz = ~1 cycle of a 6Hz oscillation)
    params(1).winScaleFctr = 2.5; %How many chunks of mOrder length in each window (20 samples of downsampled data * 2.5 = ~.5 seconds)
    params(1).winStepDvsr = 10; %Sliding window step size is winScaleFctr / winStepDvsr
    %----set 2
    params(2).fpass = [14 90];
    params(2).dsFact = 2;
    params(2).mOrder = 30; %(30 samples of data downsampled by a factor of 2 to 750Hz = ~1 cycle of a 25Hz oscillation)
    params(2).winScaleFctr = 8;
    params(2).winStepDvsr = 10;
end

if length(params) == 2
    fVals = params(1).fpass(1):params(2).fpass(2);
else
    fVals = params(1).fpass(1):params(1).fpass(2);
end

eegData = permute(eegData, [3 1 2]); %flip data to regions x samples x swps

%% standardize the data (zScore to control for variability across channels)
dataByReg = reshape(eegData,2,size(eegData,2)*size(eegData,3));
regAvg = mean(dataByReg,2);
regStd = std(dataByReg,[],2);
zScoreByReg = zeros(size(dataByReg));
for reg = 1:2;
    zScoreByReg(reg,:) = (dataByReg(reg,:) - regAvg(reg)) ./ regStd(reg);
end
eegData = reshape(zScoreByReg,2,size(eegData,2), size(eegData,3));


%% CALCULATE AR COEFFICIENTS AND METRICS
for p = 1:length(params);
    fprintf('\t\t\tParam Set %d: %d-%d Hz\n', p, params(p).fpass);
    
    %downsample data if you want to
    clear dsData;
    if downData == 1
        for reg = 1:2
            dsData(reg,:,:) = downsample(permute(eegData(reg,:,:), [2 3 1]), params(p).dsFact);
            dsFs = Fs / params(p).dsFact;
        end
    else
        dsData = eegData;
        dsFs = Fs;
    end
    
    
    %assign parameters for this parameter set
    morder = params(p).mOrder; % model order (for real-world data should be estimated)
    f = params(p).fpass(1):params(p).fpass(2); %frequencies to be considered (for mvfreqz)
    wind = params(p).winScaleFctr * morder; % observation regression window size
    ev = round(wind/params(p).winStepDvsr); % evaluate GC at every ev-th sample
    
    %calculate some stuff you need
    numObs = size(dsData,2); %number of samples (observations)
    wnobs = morder+wind;   % number of observations in "vertical slice"
    ek    = wnobs:ev:numObs; % GC evaluation points
    enobs = length(ek);    % number of GC evaluations
    
    
    for e = 1:enobs
        j = ek(e);
        
        %calculate AR coefficients (MVGC toolbox)
        [A,SIG] = tsdata_to_var(dsData(:,j-wnobs+1:j,:),morder, regmode);%A is numChan x numChan x mOrder
        
        %calculate a few things you need for BIOSIG's 'mvfreqz'
        A = reshape(A, 2, 2*morder);
        M = size(A,1); %numChan
        A = [eye(M), -A];
        B = eye(M);
        C = SIG; %SIG is the error covariance matrix
        %         ... but 'mvfreqz' instructs as to how to calculate C from mvar's output PE and I am pretty positive
        %             the last MxM portion of PE is equivalent to the error covariance matrix, but I'm not 100% positive (JT 3/16)
        
        
        %calculate the directed connectivity metrics
        [tmpS, tmpH, ~, tmpCOH] = mvfreqz(B,A,C,f,dsFs);
        %FYI: [S,h,PDC,COH,DTF,DC,pCOH,dDTF,ffDTF, pCOH2, PDCF, coh,GGC,Af,GPDC,GGC2, DCOH]=mvfreqz(B,A,C,N,Fs)
        %---- Note 1: h = transfer function = non-normalized DTF
        %---- Note 2: Af = fourier transformed AR coefficients = non-normalized PDC
        
        
        %some transformations to get the metrics in the desired format...
        tmpS = 10*log10(abs(tmpS));%log transform & convert spectrum to decibels
        tmpDTF = abs(tmpH.^2); %complex magnitude of squared transfer function is non-normalized DTF
        tmpCOH = atanh(abs(tmpCOH)); %complex magnitude of coherency is coherence, then we fisher transform it (atanh)
        
        
        %store metrics for this parameter set.
        %--only keep the direction that makes sense (i.e., DG->CA3, not CA3->DG or DG->DG)
        pSet(p).S(:,e) = squeeze(tmpS(2,1,:)); %OP = f x t
        pSet(p).DTF(:,e) = squeeze(tmpDTF(2,1,:));
        pSet(p).COH(:,e) = squeeze(tmpCOH(2,1,:));
        
        
    end %e (time)
end%paramSet


if length(params) == 2 %concatenate across frequency ranges
    S = [mean(pSet(1).S,2); mean(pSet(2).S,2)];
    DTF = [mean(pSet(1).DTF,2); mean(pSet(2).DTF,2)];
    COH = [mean(pSet(1).COH,2); mean(pSet(2).COH,2)];
else
    S = mean(pSet(1).S,2);
    DTF = mean(pSet(1).DTF,2);
    COH = mean(pSet(1).COH,2);
end
