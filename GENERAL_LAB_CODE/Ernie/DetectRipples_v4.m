function [RippleOnsetIndex, RippleOffsetIndex, shamp, threshold, filtEEG, RipplePower]=DetectRipples_v4(EEG_all,sampfreq,varargin)
% Reference: Cheng and Frank 2008
% Identify period of ripples. This version accepts EEG files in cell array. The result will be the ripples detected from all eeg files

% Default parameters
n_std = 3; %number of standard deviations for the threshold. Default is 3;
duration_threshold = .015; %in sec. duration of ripple event. Default is 15 msec
time_kernel = sampfreq*.025; %in sec. the kernel used to smooth time series

if nargin > 2
    n_std = varargin{1}; 
end

if nargin > 3
    ISI_threshold = varargin{2};
end

if nargin > 4
    duration_threshold = varargin{3};
end

if nargin > 5
    time_kernel = sampfreq*varargin{4};
end
shamp = [];
%filter EEG
sampFreq=sampfreq;

Fmax=250; %250Hz
Fmin=150; %150Hz

[B,A]=butter(3,[Fmin/(sampFreq*0.5) Fmax/(sampFreq*0.5)]);

start=[];
eegid=[];
RippleAmp = zeros(size(EEG_all,1),length(EEG_all{1}));
threshold = zeros(size(EEG_all,1),1);
for ee = 1:size(EEG_all,1)
	EEG = EEG_all{ee};
	filtEEG=filtfilt(B,A,EEG); 
	heeg = hilbert(filtEEG);
	hamp = abs(heeg);
	%smoothen the data
	kernel = gausskernel(time_kernel,time_kernel);
	RippleAmp(ee,:) = conv(hamp,kernel,'same');
	threshold(ee) = mean(RippleAmp(ee,:))+n_std*std(RippleAmp(ee,:));

	%find local peaks above threshold
	xmax = findpeaks(RippleAmp(ee,:),threshold(ee));
	start = [start; xmax.loc];
    eegid = [eegid; repmat(ee,length(xmax.loc),1)];
end
RipplePower = RippleAmp.^2;
[start,ind] = sort(start);
eegid = eegid(ind);

RippleOnsetIndex = zeros(size(start));
RippleOffsetIndex = zeros(size(start));
thr = mean(RippleAmp,2);
for ii = 1:size(RippleOnsetIndex,1)
    if ~isempty(start)
        x = start(ii);
        ind = eegid(ii);
        onset = x-1;
        while RippleAmp(ind,onset)>threshold(ind) && onset-1>0
            onset = onset-1;
        end

        offset = x+1;
        while RippleAmp(ind,offset)>threshold(ind) && offset+1<=size(RippleAmp,2)
            offset = offset+1;
        end
        
        if (offset-onset)>=duration_threshold*sampFreq % duration exceeding ripple amplitude threshold
            onset = x-1;
            while RippleAmp(ind,onset)>thr(ind) && onset-1>0
                onset = onset-1;
            end

            offset = x+1;
            while RippleAmp(ind,offset)>thr(ind) && offset+1<=size(RippleAmp,2)
                offset = offset+1;
            end
        else
            onset = NaN;
            offset = NaN;
        end

        RippleOnsetIndex(ii,1) = onset;
        RippleOffsetIndex(ii,1) = offset;
    end
end
RippleOnsetIndex(isnan(RippleOnsetIndex))=[];
RippleOffsetIndex(isnan(RippleOffsetIndex))=[];
isi = RippleOnsetIndex(2:end)-RippleOffsetIndex(1:end-1);
% combine overlapping events
RippleOnsetIndex([false;isi<=0])=[];
RippleOffsetIndex([isi<=0;false])=[];

end