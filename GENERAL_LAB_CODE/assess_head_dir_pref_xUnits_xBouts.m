function [frPerBin, WatsonU2] = assess_head_dir_pref_xUnits_xBouts(spkHd, HD)
% function [frPerBin, WatsonU2] = assess_head_dir_pref_xUnits_xBouts(spkHd, HD)
%
% PURPOSE:
%  To figure out whether units are head direction cells, this function calculates
%  Watson's U2 test statistic for each unit across all bouts.
%   - NOTE: Evaluating significance of U^2 by comparing to published tables (Zar, 1981) 
%           is not reliable. Follow Johnson et al., 2005, Hippocampus (Redish Lab) and set
%           an arbitrary threshold for U2 after examining what the plots look like across units.
%
% INPUT:
%   spkHd = cell array of head direction for each spike for each unit (dim1) and each bout (dim2)
%           spkHd = cell(#units,#bouts) where each cell contains a vector of head angle for each spike, in degrees
%      HD = cell array where each cell contains nx2 output of 'get_head_direction' for each bout
%          - (:,1) = timestamps in seconds for each frame
%          - (:,2) = head direction in degrees for each frame
%
% OUTPUT:
%   frPerBin = [#Units x 60Bins] matrix containing distribution firing rate by head directions for each unit binned in 6* bins (n = 60)
%   WatsonU2 = Watson's U2 Test Statistic vector (1 x #Units)
%
%
% JB Trimper
% 7/20/17
% Colgin Lab


%% OPTIONAL PLOTTING
plotFrByHd = 1; %set to 1 to plot firing rate by head direction for each unit


%% BINNING PARAMETERS
binWidth = 6; %degrees
binEdges = 0:binWidth:360;


%% CATCHERS
allHD = []; % catcher for head direction per video frame across bouts
for u = 1:size(spkHd,1)
    allSpkHd{u} = []; %#ok -- catcher for spike head directions across bouts
end
WatsonU2 = zeros(1,u); %Watson's Test Statistic (U^2) output


%% GATHER ALL THE DATA ACROSS BOUTS
for b = 1:length(HD)
    
    % MAKE SURE ANGLES ARE IN DEGREES
    tmpHD = HD{b}; %one bout at a time
    if max(tmpHD(:,2)) < 6.5
        warning('Angles are in radians. Converting to degrees.');
        tmpHD(:,2) = rad2deg(tmpHD(:,2));
    end
    
    % CONCATENATE HEAD DIRECTION ACROSS THE BOUTS
    allHD = [allHD tmpHD(:,2)']; %#ok
    
    for u = 1:size(spkHd,1)
        
        % MAKE SURE ANGLES ARE IN DEGREES
        tmpSpkHd = spkHd{u,b}; %one unit at a time
        if max(tmpSpkHd) < 6.5
            warning('Angles are in radians. Converting to degrees.');
            tmpSpkHd = rad2deg(tmpSpkHd);
        end
        allSpkHd{u} = [allSpkHd{u} tmpSpkHd];
        
    end
    
end



%% GET THE AMOUNT OF TIME THE RAT SPENT FACING EACH DIRECTION
tpf = mean(diff(tmpHD(:,1))); %time per frame
[~,R] = rose(deg2rad(allHD),length(binEdges)-1);
fpb = R(3:4:end);  %# frames in each bin; distribution of head direction across bout
timeInBin = fpb .* tpf;


%% RUN STATS FOR EACH UNIT
for u = 1:size(spkHd,1)
%     fprintf('Unit #%d\n', u);
    
    % DO WATSON'S U^2 TEST
    %   2-sample non-parametric asking if they came from the same distribution
    WatsonU2(u) = watsons_U2(allSpkHd{u}', allHD');
    
    
    % GET THE NUMBER OF SPIKES PER RADIAL BIN
    [T,R] = rose(deg2rad(allSpkHd{u}),length(binEdges)-1);
    spksPerBin = R(3:4:end);
    
    
    % CALCULATE FIRING RATE PER RADIAL BIN
    frPerBin(u,:) = spksPerBin ./ timeInBin;%#ok
    
    % OPTIONAL PLOTTING
    if plotFrByHd == 1
        if u == 1
            figure('name', 'Firing Rate By Head Direction Angle', 'Position', [1 31 1680 943]);
        end
        frR = zeros(1,(length(binEdges)-1)*4);
        frR(2:4:end) = frPerBin(u,:);
        frR(3:4:end) = frPerBin(u,:);
        if u <= 12
            subplot(2,6,u)
            polar(T,frR);
            title(['Unit ' num2str(u) ': U2 = ' num2str(WatsonU2(u))]);
        end
    end
    
end %unit



end %function