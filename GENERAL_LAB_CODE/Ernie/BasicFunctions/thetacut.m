function [time,W,Index] = thetacut(theta, Fs)

%  note from Laura:  input "theta" is the raw EEG trace.
%  output "W" is the cut theta cycles.

%Fs = 1893;
Ftheta = 8;    % Hz
Ftol = 0.005;  % s

kstart = 1 - floor(0.3*Fs);
kstop =  1 + floor(0.3*Fs);
time = (1:kstop-kstart+1)/Fs - 0.3;

W = zeros(length(time),10000);
Index = zeros(length(time),10000);

thetaBP = fftbandpass(theta,Fs,Ftheta-5,Ftheta-4,Ftheta+4,Ftheta+5);

dkW = [];
kstart = 0;
j = 0;
for k=2:length(theta)-1
    
	%{
    if mod(k,10000) == 0 
        fprintf('%d\n',100*k/length(theta))
    end
	%}

    % if thetaBP(k-1) > 0 & thetaBP(k) < 0 % downward slope
    %if thetaBP(k-1) < 0 & thetaBP(k) > 0 %upward slope
    if (thetaBP(k-1) > thetaBP(k))  & (thetaBP(k+1) > thetaBP(k)) %trough 
    %if (thetaBP(k-1) < thetaBP(k))  & (thetaBP(k+1) < thetaBP(k))  %peak
        kstartold = kstart;
        kstart = k - floor(0.3*Fs);
        kstop =  k + floor(0.3*Fs);
        time = (1:kstop-kstart+1)/Fs - 0.3;
        if kstart > 0 & kstop < length(thetaBP)
                dk = kstart - kstartold;
                dkW = [dkW dk];
                if dk < Fs/Ftheta + Fs*Ftol & dk > Fs/Ftheta - Fs*Ftol
                    j = j + 1;
                    %Wd(:,j) = diff(theta(kstart:kstop));   
                    W(:,j) = theta(kstart:kstop); 
                    Index(:,j) = kstart:kstop;
                end
        end
        j;
    end
    
end
W = W(:,1:j);
Index = Index(:,1:j);
