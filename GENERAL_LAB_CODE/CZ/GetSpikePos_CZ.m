function [spkx,spky,Ind] = GetSpikePos(ts,posx,posy,post)

N = length(ts);
spkx = zeros(N,1);
spky = zeros(N,1);
Ind = zeros(N,1);
for ii = 1:N
    tdiff = (post-ts(ii)).^2;
    [~,ind] = min(tdiff);
%     if v(ind(1))<0 %if want to dpownsample by direction
    spkx(ii) = posx(ind(1));
    spky(ii) = posy(ind(1));
    Ind(ii) = ind(1);
%     end
end