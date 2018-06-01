function [S1, S2, CS, WPLI, COH, PC, PHI] = get_wavelet_metrics(data1, data2, Fs, fPass, width, useOrigNorm, dbConv)
% function [S1, S2, CS, WPLI, COH, PC, PHI] = get_wavelet_metrics(data1, data2, Fs, fPass, width, useOrigNorm, dbConv)
%
% PURPOSE:
%  To calculate several of the primary txf spectral measures via wavelet transform with one function.
%  Based on (subfunctions copied from) Ole Jensen's code (traces2...), but compiled into one function with additional metrics.
%
% INPUT:
%       data1 = LFP data for channel 1, #samples(time) x #traces
%       data2 = LFP data for channel 2, #samples(time) x #traces
%          Fs = sampling frequency, Hz
%       fPass = 1x2 vector with low and high bounds for frequencies to be considered (e.g., fPass = [6 10] %6-10 Hz bandpass filter)
%       width = # of cycles in Morlet wavelet (>5)
% useOrigNorm = optional binary input indicating whether (1) or not (0) to use the "energy normalization" procedure, as in Tallon-Baudry et 
%               al. (1997, J Neurosci) and used in Colgin publications from 2009 - 2018, or the "area normalization" procedure, based on Liu 
%               et al. (2007, J. Geophys Research), as implemented by B. Gereke. Newer normalization provides better spectral resolution. 
%               If this input is not provided, function defaults to NEW normalization procedure (i.e., useOrigNorm = 0)  
%                 [see lines 178-182 below for implementation]
%      dbConv = optional binary indicating whether (1) or not (0) to convert to dB
%               If this input is not provided, function defaults to decibel conversion (i.e, dbConv = 1)
%
% OUTPUT:
%          S1 = power for channel 1 in decibels [DIMS = f x t]
%          S2 = power for channel 2 in decibels [DIMS = f x t]
%          CS = cross spectrum between channel 1 & 2 in decibels [DIMS = f x t]
%        WPLI = debiased WPLI [DIMS = f x 1]
%         COH = coherence, debiased [DIMS = f x t]
%          PC = phase coherence, debiased & fisher transformed [DIMS = f x 1]
%         PHI = phase of coherence [DIMS = f x t]
%
%
% IMPORTANT NOTE:
%   (1) Because of debiasing being based on the degrees of freedom (based on # of trials), having less than 3 trials will lead to infinite values and
%   imaginary numbers for some of the interaction metrics. Therefore, if the number of trials is less than 3, debiasing will not be performed. 
%   (2) The Fisher transformation of coherence can produce values that surpass the range of 0-1, explaining why you may see these values. 
%   
%
% JBT 11/2016
% Colgin Lab



%% SET DEFAULT NORMALIZATION PROCEDURE IF NOT PROVIDED
if nargin < 6 || isempty(useOrigNorm)
    useOrigNorm = 0;
end

%% DEFAULT TO DECIBEL CONVERSION
if nargin < 7 || isempty(dbConv)
    dbConv = 1;
end

%% CHECK DATA INPUT SIZES
if sum(diff([size(data1); size(data2)])) ~= 0
    error('Data sizes do not match.');
end


%% FREQ RANGE VECTOR
freqVect = fPass(1):fPass(end);


%% CALCULATE POWER/CROSS SPEC FRO EACH TRIAL
tmpPow1 = zeros(length(freqVect),size(data1,1), size(data1,2));
tmpPow2 = zeros(length(freqVect),size(data1,1), size(data1,2));
tmpCS = zeros(length(freqVect),size(data1,1), size(data1,2));

for t = 1:size(data1,2) %for each trial
    for f = 1:length(freqVect) %for each frequency
        
        tmpD1 = detrend(data1(:,t));
        tmpD2 = detrend(data2(:,t));
        
        tmpS1 = energyvec(freqVect(f),tmpD1,Fs,width,useOrigNorm); %get the wavelet coefficients
        tmpS2  = energyvec(freqVect(f),tmpD2,Fs,width,useOrigNorm);
        
        tmpPow1(f,:,t) = conj(tmpS1) .* tmpS1;
        tmpPow2(f,:,t) = conj(tmpS2) .* tmpS2;
        tmpCS(f,:,t) = conj(tmpS1) .* tmpS2;
        % If using energy normalization, units become something like microvolts^2/Hz^2
        % If using area normalization, units become microvolts^2
        
    end
end



%% CALCULATE PHASE COHERENCE FOR EACH TRIAL
tmpCY = tmpCS./sqrt(tmpPow1.*tmpPow2); %coherencY
PHI = angle(tmpCY); %coherency phase
PC = squeeze(atanh ( abs(mean(exp(PHI .*1i),2)).^2 )); %fisher transformed phase coherence across time -- OP: freq x trials


%% CALCULATE WPLI FROM CROSS-SPEC
iCS = imag(tmpCS); %extract imaginary component
sxt = squeeze(sum(iCS,2)); %sum across time
sNorm = squeeze(sum(abs(iCS),2)); %for normalization
ssq = squeeze(sum(iCS.^2,2)); %for debiasing
WPLI = (sxt.^2 - ssq)./(sNorm.^2 - ssq); % do the pairwise thing in a handy way


%% AVERAGE ACROSS TRIALS
S1 = mean(tmpPow1,3); %power, channel 1
S2 = mean(tmpPow2,3); %power, channel 2
CS = mean(tmpCS,3); %cross-spec
PC = mean(PC,2); %phase coherence
PHI = circ_mean(PHI,[],3); %phase OF coherence
WPLI = mean(WPLI,2); %wpli


%% CALCULATE COHERENCE
CY = CS ./ sqrt(S1.*S2); %coherencY
COH = abs(CY); %coherence
COH = atanh(COH); %fisher-transform


%% CORRECT FOR BIAS
if size(data1,2) >= 3 %at least 3 trials
    df = 2*t-2; %2 x #Trials - 2;
    PC = PC - (1/(df-2)); %debias phase coherence
    COH = COH - (1/(df-2)); %debias
end



%% CONVERT POWER METRICS TO DECIBELS
if dbConv == 1
    S1 = 10 * log10(abs(S1));
    S2 = 10 * log10(abs(S2));
    CS = 10 * log10(abs(CS));
end




%% %%%%%%%%%%%%%%%%%%%%%%%%%%
%     OLE'S SUBFUNCTIONS    %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%---------------------------------------------------------------
% Ole Jensen, Brain Resarch Unit, Low Temperature Laboratory,
% Helsinki University of Technology, 02015 HUT, Finland,
% Report bugs to ojensen@neuro.hut.fi
%---------------------------------------------------------------
%   Copyright (C) 2000 by Ole Jensen


function y = energyvec(f,s,Fs,width,useOrigNorm)
% function y = energyvec(f,s,Fs,width)
%
% Return a vector containing the energy as a
% function of time for frequency f. The energy
% is calculated using Morlet's wavelets.
% s : signal
% Fs: sampling frequency
% width : width of Morlet wavelet (>= 5 suggested).
%
% Ole Jensen, 1998

dt = 1/Fs;
sf = f/width;
st = 1/(2*pi*sf);

t=-3.5*st:dt:3.5*st;
m = morlet(f,t,width,dt,useOrigNorm);
y = convfft(s,m);
y = y(ceil(length(m)/2):length(y)-floor(length(m)/2));



function y = morlet(f,t,width,dt,useOrigNorm)
% function y = morlet(f,t,width,dt,useOrigNorm)
%
% Morlet's wavelet for frequency f and time t.
% width defines the ``width'' of the wavelet.
% A value >= 5 is suggested.
%
%
% Ole Jensen, August 1998
%
%    Modified by J. Trimper (2018) to include B. Gereke's "area normalization" code

sf = f/width;
st = 1/(2*pi*sf);
if useOrigNorm == 1
    A = sqrt(dt)*(st*sqrt(pi))^(-0.5); %Energy normalization (a la Tallon-Baudry et al., 1997)
else
    A = 2*dt/(st*sqrt(2*pi)); %Area normalization (B. Gereke, a la Liu et al., 2007) 
end
y = A*exp(-t.^2/(2*st^2)).*exp(1i*2*pi*f.*t);

