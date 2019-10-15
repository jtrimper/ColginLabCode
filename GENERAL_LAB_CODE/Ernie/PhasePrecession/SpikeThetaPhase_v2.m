function [thetaphase_spk, thetaphase_eeg] = SpikeThetaPhase_v2(eeg,eegt,spkt)

%filter eeg with theta frequency band
Ftheta = 8;    % Hz
Fs = 1/mean(diff(eegt)); %sampling frequency in Hz

thetaBP = fftbandpass(eeg,Fs,Ftheta-5,Ftheta-4,Ftheta+4,Ftheta+5);

hthetaBP = hilbert(thetaBP);
thetaphase_eeg = angle(hthetaBP);
%find the theta phase for each spike  
spkeeg = match(spkt,eegt);
thetaphase_spk = thetaphase_eeg(spkeeg);

end