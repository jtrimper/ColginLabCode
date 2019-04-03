function lfpStruct = read_in_lfp(lfpFileName)
% function lfpStruct = read_in_lfp(lfpFileName)
%
% PURPOSE: 
%   To read in the LFP file
%
% INPUT: 
%    lfpFileName = name of EEG file (*.ncs)
%
% OUTPUT: 
%    lfpStruct = lfp data structure with fields...
%                - lfpStruct.data = time series in micro-volts
%                - lfpStruct.ts = time stamp for each LFP sample in seconds
%                - lfpStruct.Fs = LFP sampling frequency
%
% NOTES: 
%    Modified from Chenguang Zheng's code. 
%
% JB Trimper 
% 10/16
% Colgin Lab



%% RETRIEVE HEADER

% Remember to load unsplit CSC files

% Set the field selection for reading CSC files. 1 = Add parameter, 0 = skip
% parameter
fieldSelection(1) = 1; % Timestamps
fieldSelection(2) = 1; % Channel number
fieldSelection(3) = 1; % Sample Frequency
fieldSelection(4) = 1; % Number of valid samples
fieldSelection(5) = 0; % Samples (EEG data)
% Do we return header, 1 = Yes, 0 = No.
extractHeader = 1;
% 5 different extraction modes, see help file for Nlx2MatCSC_v3

extractMode = 1; % Extract all data

[~,~,~,~,header] = Nlx2MatCSC(lfpFileName,fieldSelection,extractHeader,extractMode);




%% READ IN THE DATA

for i =1:size(header,1)
    k = findstr(header{i}, 'ADBitVolts');
    if ~isempty(k)
        k = findstr(header{i}, '.');
        ADBitVolts = str2num(header{i}(k-1:end));
        break
    end
end

% change up the parameters where applicable for Neuralynx to read in EEG
fieldSelection(5) = 1; % Samples (EEG data)
extractHeader = 0;             
[rawTs,~,sampFreq,~,samp] = Nlx2MatCSC(lfpFileName,fieldSelection,extractHeader,extractMode);

% Transform the 2-D samples array to an 1-D array
M = size(samp,2);
samples = zeros(512*M,1);
for jj = 1:M
    samples(((jj-1)*512)+1:512*jj) = samp(1:512,jj);
end


%% CONVERT TIME STAMPS TO SECONDS AND EEG DATA TO MICROVOLTS

convTs=zeros(length(samples),1);
n=512;
for i=1:length(rawTs)-1
	fact = n*(i-1);
	temp = linspace(rawTs(i),rawTs(i+1),n+1);
	convTs(1+fact:n+fact) = temp(1:end-1);
end
temp = temp-temp(1);
i=length(rawTs);
fact = n*(i-1);
convTs(1+fact:n+fact)=rawTs(i)+temp(1:end-1);
samples=ADBitVolts.*samples;
samples = samples .* 1000000;  %convert to microvolts
convTs = convTs / 1000000;


%% ASSIGN TO OUTPUT STRUCTURE
lfpStruct.data = samples; 
lfpStruct.ts = convTs; 
lfpStruct.Fs = sampFreq(1); 
lfpStruct.fn = lfpFileName; 

end
