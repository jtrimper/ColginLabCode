function phaseTimes = get_theta_phase_times(lfpStruct, flipLfp)
% function phaseTimes = get_theta_phase_times(lfpStruct, flipLfp)
%
% PURPOSE:
%   Go get the center times for each theta phase using the asymmetric theta
%   method described in Belluscio et al., 2012
%
% INPUT:
%       lfpStruct = lfp structure outputted by read_in_lfp with additional fields...
%                 narrowThetaLfp: time series for narrowly filtered theta EEG (e.g., 6-12 Hz)
%                  broadThetaLfp: time series for wide filtered theta EEG (e.g., 2-20 Hz)
%         flipLfp = optional binary input indicating whether or not to flip the LFP
%                   - Joe Manns's recording system produced LFPs that were upside down.
%                   - Default to 0 (no flip) if left out.
%
% OUTPUT:
%    phaseTimes = 4 x n matrix of the phase center times for each theta phase,
%                 (1,:) = peak
%                 (2,:) = falling
%                 (3,:) = trough
%                 (4,:) = rising
%
% NOTE:
%   Based on JR Manns's code 'find_theta_quartiles'
%
% JBT 
% 10/2016
% Colgin Lab




%% EXTRACT SOME RECURRING BASICS FROM THE INPUT STRUCTURE
ts = lfpStruct.ts;


%% FLIP THE LFP IF DESIRED 
%   So peaks become troughs and what not
if nargin == 1
    flipLfp = 0;
end

if flipLfp == 1
    lfpStruct.narrowThetaLfp = lfpStruct.narrowThetaLfp .* -1;
    lfpStruct.broadThetaLfp = lfpStruct.broadThetaLfp .* -1;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                   %
%             FIRST FIND THE PHASES IN THE NARROWLY FILTERED THETA EEG              %
%                                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% FIND THE PEAKS IN THE NARROW EEG
narTheta = lfpStruct.narrowThetaLfp;
pkInds = find_lfp_peaks(narTheta);
phaseTimes(1,:) = ts(pkInds(1:end-2));



%% FIND THE TROUGHS IN THE NARROW EEG
tmpNarTheta = narTheta .* -1; %flip the EEG upside down and use the same function
trInds = find_lfp_peaks(tmpNarTheta);

firstTrInd = find(trInds>pkInds(1), 1, 'First');
phaseTimes(3,:) = ts(trInds(firstTrInd:firstTrInd + size(phaseTimes,2)-1));


%% CHECK TO MAKE SURE PEAKS AND TROUGHS ALWAYS ALTERNATE
pkTroughs = [phaseTimes(1,:); phaseTimes(3,:)];
if sum(diff(pkTroughs)<0) ~= 0
    error('Peaks and troughs do not always alternate.');
end


%% FIND ZERO CROSSINGS
%   First look for exact zeros
zeroInds = find(narTheta == 0);

%  Then look for zero crossings that might occur between samples
%   (i.e., x = [-1 1] has a zero crossing between it)
tmp = narTheta(1:end-1) .* narTheta(2:end); %the samples next to each other that include a
%                                            zero crossing between them will be negative
betInds = find(tmp < 0);

%  Bring exact zeros and between indices together
combZeroInds = sort([zeroInds betInds]);
zeroTimes = ts(combZeroInds);


%% LINE UP ZERO CROSSINGS WITH PEAKS AND TROUGHS
for q = 1:length(phaseTimes)
    
    % FALLING ZERO CROSSING
    pkTime = phaseTimes(1,q);
    trTime = phaseTimes(3,q);
    
    tmpCrossInd = find(zeroTimes>pkTime & zeroTimes<trTime);
    if ~isempty(tmpCrossInd)
        phaseTimes(2,q) = zeroTimes(tmpCrossInd);
    else%interpolate where the zero would be
        phaseTimes(2,q) = pkTime + (trTime - pkTime)/2;
    end
    
    
    % RISING ZERO CROSSING
    if q < length(phaseTimes)
        
        pkTime = phaseTimes(1,q+1);
        trTime = phaseTimes(3,q);
        
        tmpCrossInd = find(zeroTimes>trTime & zeroTimes<pkTime);
        if ~isempty(tmpCrossInd)
            phaseTimes(4,q) = zeroTimes(tmpCrossInd);
        else%interpolate where the zero would be
            phaseTimes(4,q) = trTime + (pkTime - trTime)/2;
        end
    end
    
end




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                   %
%           THEN REPEAT STEPS FROM ABOVE ON THE BROAD FILTERED THETA EEG            %
%                                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% FIND THE PEAKS IN THE BROAD EEG
broadTheta = lfpStruct.broadThetaLfp;
pkInds = find_lfp_peaks(broadTheta);
pkVals = broadTheta(pkInds);
pkInds = pkInds(pkVals>0);
broadPkTimes = ts(pkInds);



%% FIND THE TROUGHS IN THE BROAD EEG
tmpBroadTheta = broadTheta .* -1; %flip the EEG upside down and use the same function
trInds = find_lfp_peaks(tmpBroadTheta);
trVals = broadTheta(trInds);
trInds = trInds(trVals<0);
firstTrInd = find(trInds>pkInds(1), 1, 'First');
broadTrTimes = ts(trInds(firstTrInd:end));



%% FIND ZERO CROSSINGS
%   First look for exact zeros
zeroInds = find(broadTheta == 0);

%  Then look for zero crossings that might occur between samples
%   (i.e., x = [-1 1] has a zero crossing between it)
tmp = broadTheta(1:end-1) .* broadTheta(2:end); %the samples next to each other that include a
%                                            zero crossing between them will be negative
betInds = find(tmp < 0);

%  Bring exact zeros and between indices together
combZeroInds = sort([zeroInds betInds]);
broadZeroTimes = ts(combZeroInds);




%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%                                                                                   %
%         REFINE THE NARROW EEG PHASE TIMES USING THE BROAD EEG PHASE TIMES         %
%                                                                                   %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

origPhaseTimes = phaseTimes;

for q = 2:size(phaseTimes,2)-1
    
    % PEAKS
    [~, tmpInd] = min(abs(broadPkTimes-phaseTimes(1,q)));
    if(broadPkTimes(tmpInd)>phaseTimes(4, q-1) & broadPkTimes(tmpInd)<phaseTimes(2, q) & ...
            broadPkTimes(tmpInd)>origPhaseTimes(4, q-1) & broadPkTimes(tmpInd)<origPhaseTimes(2, q)) %#ok<AND2>
        phaseTimes(1,q) = broadPkTimes(tmpInd);
    end
    
    % FALLING ZEROS
    [~, tmpInd] = min(abs(broadZeroTimes-phaseTimes(2,q)));
    if(broadZeroTimes(tmpInd)>phaseTimes(1, q) & broadZeroTimes(tmpInd)<phaseTimes(3, q) & ...
            broadZeroTimes(tmpInd)>origPhaseTimes(1, q) & broadZeroTimes(tmpInd)<origPhaseTimes(3, q)) %#ok<AND2>
        phaseTimes(2,q) = broadZeroTimes(tmpInd);
    end
    
    
    % TROUGHS
    [~, tmpInd] = min(abs(broadTrTimes-phaseTimes(3,q)));
    if(broadTrTimes(tmpInd)>phaseTimes(2, q) & broadTrTimes(tmpInd)<phaseTimes(4, q) & ...
            broadTrTimes(tmpInd)>origPhaseTimes(2, q) & broadTrTimes(tmpInd)<origPhaseTimes(4, q)) %#ok<AND2>
        phaseTimes(3,q) = broadTrTimes(tmpInd);
    end
    
    
    %RISING ZERO
    [~, tmpind] = min(abs(broadZeroTimes-phaseTimes(4,q)));
    if(broadZeroTimes(tmpind)>phaseTimes(3, q) & broadZeroTimes(tmpind)<phaseTimes(1, q+1) & ...
            broadZeroTimes(tmpind)>origPhaseTimes(3, q) & broadZeroTimes(tmpind)<origPhaseTimes(1, q+1)) %#ok<AND2>
        phaseTimes(4,q) = broadZeroTimes(tmpind);
    end
    
    
end%for each quartile




%% CUT OFF THE FIRST AND LAST COLUMN TO AVOID PARTIAL CYCLES

phaseTimes(:,[1 end]) = [];





end%function

