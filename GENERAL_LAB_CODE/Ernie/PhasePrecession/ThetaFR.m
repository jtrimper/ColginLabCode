function [Theta_t] = ThetaFR(eeg,eegt,spkt)

%filter eeg with theta frequency band
Ftheta = 8;    % Hz
Fs = 1/mean(diff(eegt)); %sampling frequency in Hz

thetaBP = fftbandpass(eeg,Fs,Ftheta-5,Ftheta-4,Ftheta+4,Ftheta+5);
troughInd = localpeak(thetaBP,2);
spkeeg = match(spkt,eegt);
spkeef_ind = zeros(size(eegt,1),1);
spkeef_ind(spkeeg) = true;

%find the theta phase for each spike   
theta_t1=[];
theta_t2=[];
theta_t3=[];
for ii = 2:size(troughInd,2)
    duration = (troughInd(ii)-troughInd(ii-1))/Fs; %in sec
    
    if duration > 1/12 && duration < 1/4
        spknum = sum(spkeef_ind(troughInd(ii-1):troughInd(ii)));
        theta_t = eegt(troughInd(ii-1)+floor((troughInd(ii)-troughInd(ii-1))/2));
        
        if spknum == 1
            theta_t1 = [theta_t1,theta_t];
            
        elseif spknum == 2
            theta_t2 = [theta_t2, theta_t];
            
        elseif spknum >= 3
            theta_t3 = [theta_t3, theta_t];
            
        else
            continue
            
        end
        
    end


end

Theta_t{1,1} = theta_t1;
Theta_t{2,1} = theta_t2;
Theta_t{3,1} = theta_t3;
    
end