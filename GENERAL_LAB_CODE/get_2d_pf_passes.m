function pf = get_2d_pf_passes(coords, pf)
% function pf = get_2d_pf_passes(coords, pf)
%
%  **See 'NOTE' below **
%
% PURPOSE:
%  Function returns the indices for each epoch where the rat crossed through the place-field
%  passing near the central peak.
%   - Method follows de Almeida et al., 2012, Hippocampus
%
%   - NOTE: Use 'get_2d_pf_entries' to get all entries into the pf (optional duration
%           and speed minimums) without considering the rat's trajectory (a la
%           Schlesiger et al., 2012, Nat Neuro). These 'entries' differ, as the rat might
%           have just skirted the field or might have entered and abruptly turned
%           around.
%
% INPUT:
%   coords = nx3 matrix giving rat's positional information
%            - Output of 'read_in_coords'
%       pf = data structure output of get_2d_pfs, containing indices and
%            scaled indices for place field boundaries
%
% OUTPUT:
%    pf = same as input but with additional fields...
%        - pf.passes: includes the start and end index of the coords matrix for
%                     each time the rat passed through the field and all criteria were met
%        - pf.pkCircPlotVals = cell array containing, for each place field, the
%                    x (row1) and y (row2) positions for the 5cm radius around the place-
%                    field peak
%                       * This is just provided for plotting for visual inspection
%
% JB Trimper
% 09/2019
% Colgin Lab



%% IMPORTANT PARAMETERS
minRs = 5; %cm/s -- minimum runspeed during pass
%                   - original JBT default = 5 cm

%when rat passes placefield, rat needs to start/end at least minDist away from pf peak
minDist = 20; %cm
%             - 20 cm is from de Almeida et al., 2012

minTtlDist = 30; %cm
%             - end position of pf pass must be at least 30 cm from start position





%% GET THE RAT'S MOVEMENT DIRECTION BETWEEN EACH FRAME
moveAngs = get_movement_direction(coords);


%% GET RAT'S RUNSPEED FOR EACH FRAME AND SMOOTH IT
rs = get_runspeed(coords);
smRs = smooth_runspeed(rs);



%% FIND PASSES THROUGH EACH PF THAT MEET OUR CRITERIA
for p = 1:length(pf)
    
    pf(p).passes = []; %empty catcher for pf passes indices
    
    pkCoords = pf(p).pkCoords;
    
    % FIND POINTS THAT FELL WITHIN 5 cm OF THE PF PEAK ("transition points")
    th = 0:pi/50:2*pi;
    pkCircPlotVals = [];
    pkCircPlotVals(1,:) = 5 * cos(th) + pkCoords(1);
    pkCircPlotVals(2,:) =  5 * sin(th) + pkCoords(2);
    nearPkPts = inpolygon(coords(:,2), coords(:,3), pkCircPlotVals(1,:), pkCircPlotVals(2,:));
    pf(p).pkCircPlotVals = pkCircPlotVals;
    
    % FOR EACH CHUNK OF TIME WHEN THE RAT PASSED BY THE PF PEAK
    nearPkChunks = bwconncomp(nearPkPts, 4);
    for c = 1:length(nearPkChunks.PixelIdxList)
        
        % Pull out just coords for when the rat passed the peak
        tmpInds = nearPkChunks.PixelIdxList{c};
        tmpCoords = coords(tmpInds,2:3);
        
        %Get coords index for when rat was closest to the peak (within the 5cm boundary)
        [~,minInd] = min(sqrt((tmpCoords(:,1) - pkCoords(1)).^2  +  (tmpCoords(:,2) - pkCoords(2)).^2));
        
        transInd = minInd+tmpInds(1)-1; %revise minInd to be index for whole coords matrix
        %                                     This is called the 'transition point' (index) for when the rat
        %                                     goes from approaching to departing from the peak of the field
        
        transPos = coords(transInd,2:3); %this differs only from pkCoords in that this can be non-integer
        %                              (That's because it's based on spatial resolution/coords, not rate-map bin #)
        
        distFromTransPos = sqrt((coords(:,2) - transPos(1)).^2  +  (coords(:,3) - transPos(2)).^2);
        startPassInd = find(distFromTransPos(1:transInd)>=minDist, 1, 'Last');
        endPassInd = find(distFromTransPos(transInd:end)>=minDist, 1, 'First');
        endPassInd = transInd+endPassInd-1;
        
        if ~isempty(startPassInd) & ~isempty(endPassInd)
            
            %average inbound/outbond movement direction
            inDir = circ_mean(moveAngs(startPassInd:transInd));
            outDir = circ_mean(moveAngs(transInd:endPassInd));
            
            
            %if angular distance between entry and exit movement direction is < 45*
            if abs(circ_dist(inDir, outDir)) < pi/4
                
                
                % Check that start position is at least minTtlDist from end position
                startPos = coords(startPassInd,2:3);
                endPos = coords(endPassInd,2:3);
                pathDist = sqrt(abs(startPos(1)-endPos(1))^2  +  abs(startPos(2)-endPos(2))^2);
                
                if pathDist >= minTtlDist
                    
                    passInds = startPassInd:endPassInd;
                    passRs = smRs(passInds,2);
                    
                    %if runspeed didn't drop below threshold
                    if sum(passRs<=minRs) == 0
                        
                        %then it's a good pass and save the start/end indices
                        pf(p).passes = [pf(p).passes; startPassInd endPassInd];
                        
                    end
                end
            end
        end
    end
    
    
end %pf



end %fnctn