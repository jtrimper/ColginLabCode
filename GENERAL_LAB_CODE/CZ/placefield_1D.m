% placefield identifies the placefields in the firing map. It returns the
% number of placefields and the location of the peak within each
% placefield.
%
% map           Rate map, need to linearize for circle track
% pTreshold     Field treshold
% pBins         Minimum number of bins in a field
% mapAxis       The map axis
function [nFields,fieldProp] = placefield_1D(map,p,mapAxis)

binWidth = mapAxis(2) - mapAxis(1);


% Counter for the number of fields
nFields = 0;
% Field properties will be stored in this struct array
fieldProp = [];

% Allocate memory to the arrays
N = length(map);
% Array that contain the bins of the map this algorithm has visited
visited = zeros(N,1);
nanInd = isnan(map);
visited(nanInd) = 1;
visited2 = visited;



% Go as long as there are unvisited parts of the map left
while ~prod(visited)
    
    % Find the current maximum
    [peak, peakBin] = nanmax(map);
    
    % Array that will contain the bin positions to the current placefield
    fieldBins = peakBin;

    
    % Check if peak rate is high enough
    if peak < p.lowestFieldRate
        break;
    end
    
    %visited2(map<p.fieldTreshold*peak_all) = 1; %changed by LLC to be the peak for slow and fast gamma together
    %visited2(map<p.fieldTreshold*peak) = 1;
    
%     if p.fieldTreshold*peak < peak_all
%         peak_all = p.fieldTreshold*peak;
%     end
    
%     visited2(map < peak_all) = 1;
    visited2(map < p.fieldTreshold*peak) = 1;
    
    
    
    % Find the bins that construct the peak field
    [fieldBins,visited2] = recursiveBins(map, visited2, fieldBins, peakBin, N);
    
    

    if length(fieldBins) >= p.minNumBins % Minimum size of a placefield
        nFields = nFields + 1;
        % Find centre of mass (com)
        comX = 0;

        % Total rate
        R = 0;
        for ii = 1:length(fieldBins)
            R = R + map(fieldBins(ii));
            comX = comX + map(fieldBins(ii)) * mapAxis(fieldBins(ii));
        end
        % Average rate in field
        avgRate = nanmean(map(fieldBins));
        % Peak rate in field
        peakRate = nanmax(map(fieldBins));
        % Size of field
        fieldSize = length(fieldBins) * 2.5; %binsize in cm, added by Alex
        % Put the field properties in the struct array
        
        startFieldBin = min(fieldBins);
        stopFieldBin = max(fieldBins);
        
        fieldProp = [fieldProp; struct('x',comX/R,'avgRate',avgRate,'peakRate',peakRate,'size',fieldSize,'startBin',startFieldBin,'stopBin',stopFieldBin)];
    end
    visited(fieldBins) = 1;
    map(visited == 1) = 0;
end


function [binsX,visited] = recursiveBins(map,visited,binsX,ii,N)
% If outside boundaries of map -> return.
if ii<1 || ii>N
    return;
end
% If all bins are visited -> return.
if prod(visited)
    return;
end
if visited(ii) % This bin has been visited before
    return;
else
    binsX = [binsX;ii];
    visited(ii) = 1;
    % Call this function again in each of the 2 neighbour bins
    [binsX,visited] = recursiveBins(map,visited,binsX,ii-1,N);
    [binsX,visited] = recursiveBins(map,visited,binsX,ii+1,N);
end
