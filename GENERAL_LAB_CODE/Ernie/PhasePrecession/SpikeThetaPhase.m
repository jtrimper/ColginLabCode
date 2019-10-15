function [thetaspkt, thetaphase] = SpikeThetaPhase(eeg,eegt,spkt,varargin)

% default cut for theta is trough-to-trough
if nargin >3
    cut = varargin{1};
else
    cut = 2;
end

%filter eeg with theta frequency band
Ftheta = 8;    % Hz
Fs = 1/mean(diff(eegt)); %sampling frequency in Hz

thetaBP = fftbandpass(eeg,Fs,Ftheta-5,Ftheta-4,Ftheta+4,Ftheta+5);
troughInd = localpeak(thetaBP,cut);

%find the theta phase for each spike
thetaspkt = [];
thetaphase = [];  
spkeeg = match(spkt,eegt);
for ii = 1:size(spkeeg,1)

    distance = troughInd-spkeeg(ii);
    closest = find(abs(distance)==min(abs(distance)),1);
    if distance(closest) > 0
        phase_end = closest;
        phase_start = closest-1;

    elseif distance(closest) <= 0
        phase_end = closest+1;
        phase_start = closest;

    end
    
    if phase_start == 0 || phase_end > size(troughInd,2)
        spkphase = NaN;
    else
        thetaduration = troughInd(phase_end)-troughInd(phase_start);
        spkphase = (spkeeg(ii)-troughInd(phase_start))/thetaduration*360;
    end
    
    if spkphase > 360
        error('spike phase should not be more than 360 degree')
    end

    thetaspkt = [thetaspkt; spkt(ii)];
    thetaphase = [thetaphase; spkphase];

   

end
   if size(spkt,1) ~= size(thetaphase,1)
       keyboard
   end
end