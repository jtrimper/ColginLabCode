function [pos_error] = BayesianDecoder_modeling(model_training,model_testing,celllist_training,celllist_testing) 

posx = model_training.pos_lin;
xBinWidth = model_training.BinWidth;
xStart = 0;
xLength = model_training.Tracklength;
sampleTime = model_training.posSampTime;
timebin = .25; %sec
timebin_increment = timebin/4;
minSpeed = 5; %cm/sec

speed = abs(diff(posx))/sampleTime;
speed = [0, speed];

totalratemap=zeros(ceil(xLength/xBinWidth),size(celllist_training,1)-1);
for ii=2:size(celllist_training,1)
    spkx = posx(intersect(celllist_training{ii,2}, find(speed >= minSpeed)));

    [map, ~, ~, ~] = rateMap4LinearTrack(posx,spkx,xBinWidth,xStart,xLength,sampleTime);

    totalratemap(:,ii-1) = map;

end


posx = model_testing.pos_lin;
xBinWidth = model_testing.BinWidth;
xStart = 0;
%xLength = model_testing.Tracklength;
sampleTime = model_testing.posSampTime;
time = model_testing.post;
spkx = model_training.pos_lin(celllist_testing{1,2});


  [~, ~, xAxis,timeMap] = rateMap4LinearTrack(posx,spkx,xBinWidth,xStart,xLength,sampleTime);



p_x = timeMap./sum(timeMap);


numTimeBins = ceil((time(end)-time(1))/timebin);
startTime = zeros(1,ceil((time(end)-time(1))/timebin_increment));
startTime(1) = time(1);
stopTime = zeros(1,ceil((time(end)-time(1))/timebin_increment));
stopTime(end) = time(end);
for tt=2:ceil((time(end)-time(1))/timebin_increment)
    
    stopTime(tt-1) = startTime(tt-1) + timebin;
    startTime(tt) = startTime(tt-1) + timebin_increment;

end

spikecount = zeros(ceil((time(end)-time(1))/timebin_increment),size(celllist_testing,1)-1);
for ii=2:size(celllist_testing,1)
    spkt = (celllist_testing{ii,1});
    
    for kk=1:ceil((time(end)-time(1))/timebin_increment)
        binSpkt = find(spkt>=startTime(kk) & spkt<stopTime(kk));
        spikecount(kk,ii-1) = length(binSpkt);
        
    end
    
end

p_x_n = zeros(size(totalratemap,1),size(spikecount,1));
for pp=1:size(spikecount,1)
    n = repmat(spikecount(pp,:),[size(totalratemap,1) 1]);
    
%     p_n_x = prod((timebin*totalratemap).^n./factorial(n),2).*exp(-timebin*sum(totalratemap,2));
%     p_x_n(:,pp) = p_x.*p_n_x;
    p_x_n(:,pp) = p_x.*(prod(totalratemap.^n,2).*exp(-timebin*sum(totalratemap,2)));
    p_x_n(:,pp) = p_x_n(:,pp)/sum(p_x_n(:,pp));
end


timeAxis=startTime+(stopTime-startTime)/2;
[~,dpos]=nanmax(p_x_n);

populationFR = sum(spikecount,2)/timebin;

[posxbin] = binpos(posx,xBinWidth);
[match_ind] = match(timeAxis,time);

pos_error = abs(dpos-posxbin(match_ind))*xBinWidth;

figure;
imagesc(timeAxis,xBinWidth*[min(posxbin):max(posxbin)],p_x_n);
colormap rvgray;
hold on; plot(timeAxis,xBinWidth*posxbin(match_ind),'*','Markersize',3)
% plot(timeAxis,pos_error,'b*')
% hold on; plot(timeAxis,populationFR,'r-')

end
