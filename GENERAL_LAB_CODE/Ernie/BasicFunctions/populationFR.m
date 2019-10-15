% Input
%       post: video timestamps
%       timewindow: the length of timewindow. should be in seconds
%       spklist: the timesteps of the spikes. should be in cell array

function [timeaxis, popFR] = populationFR(post,timewindow, spktlist)

tstart = min(post,[],2);
tend = max(post,[],2);
timeaxis = tstart:timewindow:tend;

popFR = zeros(1,size(timeaxis,2));
for pp = 1:size(spktlist,1)
    spkt = spktlist{pp};
    
    ind = match(spkt,timeaxis);
    for ii = 1:size(ind,1)
        popFR(ind(ii)) = popFR(ind(ii))+1;
    end
    
end

popFR = popFR./timewindow;