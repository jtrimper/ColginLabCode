function [cutspkt] = CutTrackendSpk(spkt,posx,post)

tracklength = max(posx)-min(posx);
posstart = min(posx)+.1*tracklength;
posend = max(posx)-.1*tracklength;

spk2pos = match(spkt,post);
inspk = false(size(spk2pos));
for ii = 1:size(spk2pos,1)
    if posx(spk2pos(ii)) > posstart && posx(spk2pos(ii)) < posend
        inspk(ii) = true;
    end
end

cutspkt = spkt(inspk);
