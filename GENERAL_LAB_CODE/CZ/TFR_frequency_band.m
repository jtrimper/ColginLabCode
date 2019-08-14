function [TFR,temp] = TFR_frequency_band(W,Fs,width, f1, f2)

freq(1,:) = [f1 f2];

n = 0;
fprintf('\nTFR: ');
detrend_W=detrend(W);
for l = freq(1,1):2:freq(1,2)
    fprintf('.');
    n = n + 1;
    temp(n,:) = zeros(1,size(W,1));
    temp(n,:) = energyvec(l,detrend_W,Fs,width);
end
TFR(1,1:size(W,1)) = mean(temp, 1);
fprintf('\n');

function y = energyvec(f,s,Fs,width)
% function y = energyvec(f,s,Fs,width)
%
% Return a vector containing the energy as a
% function of time for frequency f. The energy
% is calculated using Morlet's wavelets. 
% s : signal
% Fs: sampling frequency
% width : width of Morlet wavelet (>= 5 suggested).
%
% 

dt = 1/Fs;
sf = f/width;
st = 1/(2*pi*sf);

t=-3.5*st:dt:3.5*st;
m = morlet(f,t,width);
y = convfft(s,m);
%y = conv(s,m);
y = (2*abs(y)/Fs).^2;
y = y(ceil(length(m)/2):length(y)-floor(length(m)/2));

function y = morlet(f,t,width)
% function y = morlet(f,t,width)
% 
% Morlet's wavelet for frequency f and time t. 
% The wavelet will be normalized so the total energy is 1.
% width defines the ``width'' of the wavelet. 
% A value >= 5 is suggested.
%
% Ref: Tallon-Baudry et al., J. Neurosci. 15, 722-734 (1997)
%
% See also: PHASEGRAM, PHASEVEC, WAVEGRAM, ENERGY 
%
% Ole Jensen, August 1998 

sf = f/width;
st = 1/(2*pi*sf);
A = (st*sqrt(pi))^(-0.5);

y = A*exp(-t.^2/(2*st^2)).*exp(i*2*pi*f.*t);