function [in_eegind] = ThetaDeltaThreshold(eeg,eegt,threshold)

Fs = 1/mean(diff(eegt)); %sampling frequency in Hz
Ftheta = 8; % Hz
Fdelta = 3; % Hz

thetaBP = fftbandpass(eeg,Fs,Ftheta-5,Ftheta-4,Ftheta+4,Ftheta+5);
deltaBP = fftbandpass(eeg,Fs,Fdelta-1,Fdelta-.5,Fdelta+.5,Fdelta+1);

thetapower = thetaBP.^2;
deltaBP = deltaBP.^2;
power_ratio = thetapower./deltaBP;

in_eegind = false(size(eeg));
in_eegind(power_ratio>threshold) = true;

end
