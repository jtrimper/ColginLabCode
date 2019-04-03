function filtLfp = filter_lfp(lfpStruct, lowCut, highCut)
% function filtLfp = filter_lfp(lfpStruct, lowCut, highCut)
%
% PURPOSE: 
%   Function to filter LFP from low to high cut using a Parks-McClellan FIR filter. 
%
% INPUT: 
%   lfpStruct = eeg data structure outputted by 'read_in_lfp'
%               See 'read_in_lfp' for subfield descriptions. 
%      lowCut = low frequency range cutoff
%     highCut = high frequency range cutoff
%
% OUTPUT: 
%     filtLfp = time series of LFP filtered in desired range
%
% JB Trimper 
% 10/16*
%  *But entirely based on JR Manns's code, which was based on Murat Okatan's code in eegrhythm


[N,Fo,Ao,W] = firpmord([lowCut-1 lowCut highCut highCut+1], [0 1 0], [.01 .01 .01], lfpStruct.Fs); 
b = firpm(N,Fo,Ao,W); 
a = 1;
filtLfp = filtfilt(b,a, lfpStruct.data);
