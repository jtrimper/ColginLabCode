% fieldBins find which bins are within multiple place field
function fBins = fieldBins(map,binTresh)

nFields = 0;
% Make room for 50 fields, more than ever will be found
fBins = cell(50,2);
[N,M] = size(map);
visited = zeros(N,M);
nanInd = isnan(map);
visited(nanInd) = 1;
visited2 = visited;


% Find bins that are part of a field
while ~prod(prod(visited))
    % Find the current maximum.
    [peak,r] = nanmax(map);
    [peak,pCol] = nanmax(peak);
    pCol = pCol(1);
    pRow = r(pCol);
    
    % Check if peak rate is high enough
    if peak < 1  % peak < 2
        break;
    end
    
    visited2(map <= 0.4*peak) = 1;  % 0.2*peak
    if prod(prod(visited2))
        % Nothing left
    	break;
    end
    
    [NbinsX,NbinsY,visited2] = recursiveBins(map,visited2,[],[],pRow,pCol,N,M);
    % Check if there are enough bins in field for it to qulify as a
    % placefield
    if length(NbinsX) >= binTresh
        nFields = nFields + 1;
        fBins{nFields,1} = NbinsX;
        fBins{nFields,2} = NbinsY;
    end
    visited(NbinsX,NbinsY) = 1;
    map(visited2==1)=0;
end

fBins = fBins(1:nFields,:);


function [binsX,binsY,visited] = recursiveBins(map,visited,binsX,binsY,ii,jj,N,M)
% If outside boundaries of map -> return.
if ii<1 || ii>N || jj<1 || jj>M
    return;
end
% If all bins are visited -> return.
if prod(prod(visited))
    return;
end
if visited(ii,jj) % This bin has been visited before
    return;
else
    binsX = [binsX;ii];
    binsY = [binsY;jj];
    visited(ii,jj) = 1;
    % Call this function again in each of the 4 neighbour bins
    [binsX,binsY,visited] = recursiveBins(map,visited,binsX,binsY,ii,jj-1,N,M);
    [binsX,binsY,visited] = recursiveBins(map,visited,binsX,binsY,ii-1,jj,N,M);
    [binsX,binsY,visited] = recursiveBins(map,visited,binsX,binsY,ii,jj+1,N,M);
    [binsX,binsY,visited] = recursiveBins(map,visited,binsX,binsY,ii+1,jj,N,M);
end