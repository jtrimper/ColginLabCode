function pf = get_2d_pfs(rateMap, rmBinSize, minPkFr, minPfArea, plotOrNot)
%function pf = get_2d_pfs(rateMap, rmBinSize, minPkFr, minPfArea, plotOrNot)
%
%
% PURPOSE:
%  - To get place field boundaries in x and y dimensions from a 2d rate-map.
%  - Function applies a minimum firing rate criteria to the cell, but does
%    not apply more stringent criteria for evaluating whether or not the unit
%    is, in fact, a place cell (other than giving place field coordinates).
%    It remains possible that the cell had very broad or poorly defined fields,
%    and this needs to be checked separately by the analyst.
%  - PFs here are defined by a minimum size (25cm^2), which can be modified
%    at the top of the function
%
% INPUT:
%     rateMap = 2d smoothed rate-map for a single unit
%   rmBinSize = the size of bins used to make the rate-map in cm
%               - Employed here to evaluate minimum place field size
%     minPkFr = minimum peak firing rate for a unit to be a place cell
%               - If left empty, minPkFr = 2 Hz;
%   minPfArea = minimum area for a 2d place field, in cm^2
%               - If left empty, minPfSize = 5 cm^2
%   plotOrNot = whether(1) or not(0) to plot the rate-map with the place
%               fields circled in red
%
% OUTPUT:
%       pf = structure array of length #placeFields with subfields:
%            -  pf.inds = the x and y values for the place
%                         field boundaries.
%                         - These will be indices, but will very likely not be
%                           integers since pf bounds will connect across bins
%                         - To plot for field == 1: plot(pfInds({1}(1,:), pfInds{1}(2,:))
%            -  pf.cms = same as variable above, but pf boundaries are in cm
%                        based on inputted rmBinSize
%            - pf.pkFr = peak in-field firing rate (Hz)
%            - pf.pkCoords = spatial indices for peak in-field firing rate
%
%
% JB Trimper
% 09/2019
% Colgin Lab



pfCut = 40; % percent of peak fr; edge for placefield detection using contourc
%                 Adapted from Schlesiger et al. (2015, Nat Neuro) who used 50%



%% CHECK INPUTS AND ASSIGN DEFAULTS
if nargin == 2 || isempty(minPkFr)
    minPkFr = 2;  %Hz -- minimum peak FR for a cell to be place cell
end

if nargin <4 || isempty(minPfArea)
    minPfArea = 5; %cm^2 -- minimum area for a placefield
end

if nargin<5
    plotOrNot = 0;
end


%% MAKE A GRID THE SAME NUMBER OF BINS AS THE RM
xVals = 1:size(rateMap,1);
xVals = xVals .* rmBinSize;
yVals = 1:size(rateMap,2);
yVals = yVals .* rmBinSize;

xGrid = meshgrid(xVals);
xVctr = xGrid(:);
yGrid = meshgrid(fliplr(yVals))';
yVctr = yGrid(:);
mapCoords = [xVctr yVctr];




%% FIND THE PLACE FIELDS
pf = [];
pkFr = max(rateMap(:));
if pkFr>= minPkFr
    
    
    % GET PF EDGE CONTOUR
    normRm = (rateMap ./ pkFr).* 100;
    C = contourc(normRm, [pfCut pfCut]);
    
    % PLOT RATEMAP IF DESIRED
    if plotOrNot == 1
        figure;
        plot_ratemap(normRm,rmBinSize);
        axis square;
        hold on;
    end
    
    startInd = 1;
    pfCntr = 0;
    while startInd<size(C,2)
        numVals = C(2,startInd);
        pfXVals = C(1,startInd+1:startInd+numVals);
        pfXVals = [pfXVals pfXVals(1)]; %#ok
        pfYVals = C(2,startInd+1:startInd+numVals);
        pfYVals = [pfYVals pfYVals(1)]; %#ok
        
        pfArea = polyarea(pfXVals, pfYVals);
        pfArea = pfArea * rmBinSize;
        
        if pfArea > minPfArea^2
            if plotOrNot == 1
                plot(pfXVals.*rmBinSize, pfYVals.*rmBinSize, 'r', 'LineWidth', 2)
            end
            pfCntr = pfCntr + 1;
            
            pf(pfCntr).inds = [pfXVals; pfYVals]; %#ok - %pf bounds in indices
            pf(pfCntr).cms = [pfXVals.*rmBinSize; pfYVals.*rmBinSize]; %#ok - %pf bounds in cm
            
            % grid points that are within the placefield
            inPfBnry = inpolygon(mapCoords(:,1), mapCoords(:,2), pf(pfCntr).cms(1,:), pf(pfCntr).cms(2,:));
            
            % FIND THE PEAK FIRING RATE LOCATION WITHIN THE PLACEFIELD
            tmpMap = fliplr(rateMap')'; %flip the rate-map end-over-end (mirror over x axis) so that it lines
            %                             up with the order that inPfBnry is in when we vectorize it
            
            rmVctr = tmpMap(:);
            rmVctr(inPfBnry==0) = 0;
            [maxVal,maxInd] = max(rmVctr);
            pf(pfCntr).pkFr = maxVal; %#ok - max in field firing rate
            pf(pfCntr).pkCoords = mapCoords(maxInd,:); %#ok - spatial indices for peak in field firing
            
        end
        startInd = startInd+numVals+1;
    end
end



end %fnctn

