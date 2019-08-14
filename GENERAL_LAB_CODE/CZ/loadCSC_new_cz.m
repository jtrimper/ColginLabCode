function [samples, tt, tt_raw, Fs_raw] = loadCSC_new_cz(CSCfile)

%load the csc data
% Original by Sean: [samples, tt_raw, Fs_raw, bv, ir]  = loadEEG(infile);

[currPath, name, ext] = fileparts(CSCfile);
fsep = filesep;  % '\'
pos_v = strfind(currPath,fsep);
fatherpath = currPath(1:pos_v(length(pos_v))-1);

CSCfile0=strcat(fatherpath,fsep,name,ext);
[TS_eeg,chNum,sampFreq,numSamp,header] = load_eeg_retrieve_header_cz(CSCfile0);
%you'll see the ADBitVolts conversion factor.... e.g., ADBitVolts 0.00644
ADBitVolts = str2num(header{15}(13:end))

[tt_raw,chNum,Fs_raw,numSamp,samp,samples] = load_eeg_cz(CSCfile);
Fs_raw=Fs_raw(1);
tt=zeros(length(samples),1);
n=512;
for i=1:length(tt_raw)-1
	fact = n*(i-1);
	temp = linspace(tt_raw(i),tt_raw(i+1),n+1);
	tt(1+fact:n+fact) = temp(1:end-1);
end
temp = temp-temp(1);
i=length(tt_raw);
fact = n*(i-1);
tt(1+fact:n+fact)=tt_raw(i)+temp(1:end-1);
samples=ADBitVolts.*samples;
samples = samples .* 1000000;  %convert to microvolts
tt = tt / 1000000;
tt_raw = tt_raw / 1000000;  %convert to s



function [ts,chNum,sampFreq,numSamp,samp,samples] = load_eeg_cz(file)
%file = 'E:\Chenguang Zheng\DATA\Rat28\2013-09-11_09-18-22-LT\begin1\CSC9.ncs';

% Set the field selection for reading CSC files. 1 = Add parameter, 0 = skip
% parameter
fieldSelection(1) = 1; % Timestamps
fieldSelection(2) = 1; % Channel number
fieldSelection(3) = 1; % Sample Frequency
fieldSelection(4) = 1; % Number of valid samples
fieldSelection(5) = 1; % Samples (EEG data)
% Do we return header, 1 = Yes, 0 = No.
extractHeader = 0;
% 5 different extraction modes, see help file for Nlx2MatCSC_v3

extractMode = 1; % Extract all data

[ts,chNum,sampFreq,numSamp,samp] =...
   Nlx2MatCSC(file,fieldSelection,extractHeader,extractMode);

% Transform the 2-D samples array to an 1-D array
M = size(samp,2);
samples = zeros(512*M,1);

for jj = 1:M
    samples(((jj-1)*512)+1:512*jj) = samp(1:512,jj);
end