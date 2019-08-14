function [samples,tsi,ts] = loadEeg8(file)

%converts eeg to microVolts. 
%tsi is interpolated 
%time in seconds
%this version interpolates timestamps automatically
% Set the field selection for reading CSC files. 1 = Add parameter, 0 = skip
% parameter
fieldSelection(1) = 1; % Timestamps
fieldSelection(2) = 0; % Channel number
fieldSelection(3) = 0; % Sample Frequency
fieldSelection(4) = 0; % Number of valid samples
fieldSelection(5) = 1; % Samples (EEG data)
% Do we return header, 1 = Yes, 0 = No.
extractHeader = 1;
% 5 different extraction modes, see help file for Nlx2MatCSC_v3

extractMode = 1; % Extract all data

[ts,samp,header] =...
   Nlx2MatCSC(file,fieldSelection,extractHeader,extractMode);

% Transform the 2-D samples array to an 1-D array
M = size(samp,2);
samples = zeros(512*M,1);
%convert ts to seconds
ts = ts/1000000;

for jj = 1:M
    samples(((jj-1)*512)+1:512*jj) = samp(1:512,jj);
end

tsi = interp1(1:1:length(ts),ts,1:(1/512):length(ts));
%add in the last 512 values which were not interpolated
tsi = cat(2,tsi,NaN(1,511));
for i = 1:511
    tsi(length(tsi)-511+i) = tsi(length(tsi)-511-1+i) + (1/2000);
end
tsi = tsi';
ts = ts';
clear i;

%figure out if header 12 or 13 has adbitvolts value
if min(header{12}(2:6) == '-ADBi');
bv = str2num(header{12}(13:end))*10^6; %to convert to uV
elseif min(header{13}(2:6) == '-ADBi');
bv = str2num(header{13}(13:end))*10^6; %to convert to uV
else
    disp('header problem, still in bits');
    bv = 1;
end
samples = samples*bv;


