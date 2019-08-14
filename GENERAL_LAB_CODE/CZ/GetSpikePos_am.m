function [spk_phase,Ind] = spikePos_am(ts,phase,post)
N = length(ts);
spk_phase = zeros(N,1);
Ind = zeros(N,1);
for ii = 1:N
    tdiff = (post-ts(ii)).^2;
    [m,ind] = min(tdiff);
    spk_phase(ii) = phase(ind(1));   
    Ind(ii) = ind(1);
end
end