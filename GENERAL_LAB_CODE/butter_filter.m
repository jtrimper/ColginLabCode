function filtLfpData = butter_filter(lfpStruct,lowCut, highCut)
% function filtLfpData = butter_filter(lfpStruct,lowCut, highCut)
%
% PURPOSE:
%   To apply a bandpass Butterworth IIR filter to an LFP.
%
% INPUT:
%     lfpStruct = lfp data structure outputted by 'read_in_lfp'
%                 See 'read_in_lfp' for subfield description
%        lowCut = lower bound for bandpass
%       highCut = upper bound for bandpass
%
% OUTPUT:
%       filtLfp = filtered Lfp time series
%
%  From E. Hwaun, to JB Trimper
%  Colgin Lab
%
%  Documentation added, naming adjusted, by JB Trimper 4/16/19




%Design the Butterworth filter
[B,A] = butter(3,[lowCut/(lfpStruct.Fs*0.5) highCut/(lfpStruct.Fs*0.5)]);


%Apply the filter, forwards and backwards
filtLfpData = filtfilt(B,A,lfpStruct.data);
