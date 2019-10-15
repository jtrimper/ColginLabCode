function [rateMap, binCtrs, tpb, spkCnts] = get_ratemap_circtrack(spkTms, coords, radPos, spatBinSz, velFilt, durCrit)
% function rateMap = get_ratemap_circtrack(spkTms, coords, radPos, spatBinSz, velFilt, durCrit)
%
% PURPOSE:
%  Function to get a 1xn ratemap for circular track data.
%
% INPUT:
%    spkTms = spike times in seconds for a single unit
%    coords = frametimes, x position, and y position for rat at all video frames
%            - NOT the same as the output of 'read_in_coords' in this case (see below)
%    radPos = radial position of rat by frame-time
%              - get 'coords' and 'radPos' by using Ernie's code and re-organizing the output as follows:
%                 [post,posx,posy] = LoadCircPos('VT1.nvt'); %get rat's position on circular track
%                 radPos = circpos(posx,posy); %radial position from x/y position
%                 radPos = [post' radPos']; %adding frame-times to radPos matrix
%                 coords = zeros(length(post), 3); %create coords matrix
%                 coords(:,1) = post; %where column 1 is frametimes
%                 coords(:,2) = posx; %column 2 is the rat's x position
%                 coords(:,3) = posy; %and column 3 is the rat's y position
%  spatBinSz = spatial bin size in degrees (suggestion = 5)
%    velFilt = binary indicating whether(1) or not(0) to velocity filter such that
%              spikes are not included if the rat was moving below runThresh
%              at the time of the spike. Minimum runspeed (runThresh) is defined at top of function as 5 cm/s
%              - If not provided, function defaults to 0 (do not velocity filter)
%    durCrit = binary indicating whether(1) or not(0) to enforce that rat occupies spatial
%              bin for at least a minimum amount of time to not inflate the rate for that bin.
%              Minimum duration (durMin) is defined at top of function as 150 ms per Schlesiger et al., 2015
%              - If not provided, function defaults to durCrit = 0 (do not enforce minimum duration)
%
% OUTPUT:
%    rateMap = 1x(360/spatBinSz) vector indicating firing rate for each spatial bin
%    binCtrs = 1x(360/spatBinSz) vector of the angle corresponding to each rate-map bin
%        tpb = 1x(360/spatBinSz) vector of the time spent in each angular bin
%    spkCnts = 1x(360/spatBinSz) vector of the number of spikes in each spatial bin
%
%
% NOTE:
%  Optionally smooth the rate-map after calling this function by using 'smooth_circtrack_ratemap' function
%
% JB Trimper
% 10/2019
% Colgin Lab


runThresh = 5; %cm/s
durMin = 150; %ms, based on Schlesiger et al., 2015


%% DEFAULT, IF NECESSARY, TO NOT VELOCITY FILTERING
if nargin < 5 || ~exist('velFilt', 'var')
    velFilt = 0;
end


%% DEFAULT, IF NECESSARY, TO NOT COMPARING TO DURATION CRITERIA
if nargin < 6 || ~exist('durCrit', 'var')
    durCrit = 0;
end


% FIND EDGES OF SPATIAL BINS, IN DEGREES
spatBinEdges = 0:spatBinSz:360;
binCtrs = edges_to_x_vals(spatBinEdges);


% FIND TIME OF EACH SPIKE RELATIVE TO FRAME-TIMES
%time-series of length(coords) where each index indicates how many spikes occurred
spkCntsByFrame = zeros(1,size(coords,1));
for st = 1:length(spkTms)
    tmpTm = spkTms(st);
    frameInd = find(radPos(:,1)<=tmpTm, 1, 'Last');
    spkCntsByFrame(frameInd) = spkCntsByFrame(frameInd) + 1; %can be >1 because of sampling rate difs
end


% VELOCITY FILTERING
if velFilt == 1
    instRs = get_runspeed(coords);
    smRs = smooth_runspeed(instRs);
    spkCntsByFrame(smRs<runThresh) = 0;
end


% FIND AMOUNT OF TIME SPENT AND NUMBER OF SPIKES IN EACH SPATIAL BIN
tpb = zeros(1,length(spatBinEdges)-1);
spkCnts = zeros(1,length(spatBinEdges)-1);
for sb = 1:length(spatBinEdges)-1
    binStart = spatBinEdges(sb);
    binEnd = spatBinEdges(sb+1);
    frameInds = find(radPos(:,2)>=binStart & radPos(:,2)<binEnd);
    % +1 extra frame to go from 1/2 a frame before time-start to 1/2 a frame after time-end
    tpb(sb) = (length(frameInds)+1) * mean(diff(coords(:,1)));
    spkCnts(sb) = sum(spkCntsByFrame(frameInds));
end

% IF ENFORCING DURATION MINIMUM...
if durCrit == 1
    spkCnts(tpb<(durMin/1000)) = 0;
end


% CALCULATE RATEMAP
rateMap = spkCnts ./ tpb;


%% PLOTTING FOR UNDERSTANDING PHASE PRECESSION RESULTS
% tmpSpkCnts = rescale(spkCnts, 0, 1);
% tmpTpb = rescale(tpb, 0, 1);
% tmpRm = rescale(rateMap,0,1); 
% 
% figure; 
% bar(binCtrs, tmpSpkCnts); 
% hold on; 
% ln(1) = plot(binCtrs, tmpTpb, 'r'); 
% ln(2) = plot(binCtrs, tmpRm, 'Color', [.5 .5 .5]); 

end %fnctn