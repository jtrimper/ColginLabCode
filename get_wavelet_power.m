function S = get_wavelet_power(data, Fs, fPass, width, useOrigNorm, dbConv)
% function S = get_wavelet_power(data, Fs, fPass, width, useOrigNorm, dbConv)
%
% PURPOSE:
%  To calculate spectral power via wavelet transform.
%    Based on (subfunctions copied from) Ole Jensen's code (traces2...). 
%
% INPUT:
%        data = LFP data for channel, #samples(time) x #traces
%          Fs = sampling rate, Hz
%       fPass = 1x2 vector with low and high bounds for frequencies to be considered (e.g., fPass = [6 10] %6-10 Hz bandpass filter)
%       width = # of cycles in Morlet wavelet (>5)
% useOrigNorm = optional binary input indicating whether (1) or not (0) to use the "energy normalization" procedure, as in Tallon-Baudry et 
%               al. (1997, J Neurosci) and used in Colgin publications from 2009 - 2018, or the "area normalization" procedure, based on Liu 
%               et al. (2007, J. Geophys Research), as implemented by B. Gereke. Newer normalization provides better spectral resolution. 
%               If this input is not provided, function defaults to NEW normalization procedure (i.e., useOrigNorm = 0)  
%                 [see lines 116-120 below for implementation]
%     dbConv = optional binary indicating whether (1) or not (0) to convert to dB
%              If this input is not provided, function defaults to decibel conversion (i.e, dbConv = 1)
%
% OUTPUT:
%        S = power in decibels [DIMS = f x t]
%
%
% JBT 11/2016
% Colgin Lab



%% SET DEFAULT NORMALIZATION PROCEDURE IF NOT PROVIDED
if nargin < 5 || isempty(useOrigNorm)
    useOrigNorm = 0;
end

if nargin < 6 || isempty(dbConv)
    dbConv = 1; 
end


%% FREQ RANGE VECTOR
freqVect = fPass(1):fPass(end);


%% CALCULATE POWER/CROSS SPEC FOR EACH TRIAL
tmpPow1 = zeros(length(freqVect),size(data,1), size(data,2));

for t = 1:size(data,2) %for each trial
    
    tmpD1 = detrend(data(:,t));
    
    for f = 1:length(freqVect) %for each frequency
        
        tmpS1 = energyvec(freqVect(f),tmpD1,Fs,width, useOrigNorm); %get the wavelet coefficients
        
        tmpPow1(f,:,t) = conj(tmpS1) .* tmpS1; 
        % If using energy normalization, units become something like microvolts^2/Hz^2
        % If using area normalization, units become microvolts^2
        
    end
end


%% AVERAGE ACROSS TRIALS

S = mean(tmpPow1,3); %microVolts^2


%% CONVERT POWER TO DECIBELS
if dbConv == 1
    S = 10 * log10(abs(S));
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
% function y = energyvec(f,s,sf,width)
%
% Return a vector containing the energy as a
% function of time for frequency f. The energy
% is calculated using Morlet's wavelets.
% s : signal
% sf: sampling frequency
% width : width of Morlet wavelet (>= 5 suggested).
%
% Ole Jensen, 1998

dt = 1/Fs;
sf = f/width;
st = 1/(2*pi*sf);

t = -3.5*st:dt:3.5*st;
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
