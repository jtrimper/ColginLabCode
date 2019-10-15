function [posbin_ind, binaxis]=binpos(pos,binsize)

if size(pos,1) > size(pos,2)
    pos=pos';    
end

BinBound = min(pos):binsize:max(pos);
posbin_ind = zeros(1,size(pos,2));
for ii=1:size(pos,2)
    
    [~,posbin_ind(ii)] = min(abs(BinBound-pos(ii)));
    
end

binaxis = BinBound;

end