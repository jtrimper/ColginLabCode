function ccMap = rateMapXCorr(map1, map2)
% function ccMap = rateMapXCorr(map1, map2)
%
% PURPOSE:
%  To calculate the rate map cross-correlation from a pair of rate maps.
%  This code is copied exactly from that provided by Sean, which was provided by Laura, which was handed 
%  down from Mosers. The only thing I'm adding (JT) is comments at the top so you know what it's doing.
%
% INPUT:
%  map1 = rate map for unit 1
%  map2 = rate map for unit 2
%
% OUTPUT:
%  ccMap = cross-correlation map
%
% JBT 8/2017
% Colgin Lab
%   *but see notes at top about real ownership


% Number of bins in each dimension of the rate map
numBins = size(map1,1);

% Number of correlation bins
numCorrBins = numBins * 2 - 1;

% Index for the centre bin in the correlation map
centreBin = (numCorrBins+1)/2;

% Allocate memory for the cross-correlation map
ccMap = zeros(numCorrBins);


for rowLag = 0:numBins-1
    for colLag = 0:numBins-1
        % Row lag >= 0 and column lag >= 0
        sumX = 0;
        sumY = 0;
        sumX2 = 0;
        sumY2 = 0;
        sumXY = 0;
        N = 0;
        for ii = 1:numBins-rowLag
            for jj = 1:numBins-colLag
                if ~isnan(map1(ii,jj+colLag)) && ~isnan(map2(ii+rowLag,jj))
                    sumX = sumX + map1(ii,jj+colLag);
                    sumY = sumY + map2(ii+rowLag,jj);
                    sumX2 = sumX2 + map1(ii,jj+colLag)^2;
                    sumY2 = sumY2 + map2(ii+rowLag,jj)^2;
                    sumXY = sumXY + map1(ii,jj+colLag) * map2(ii+rowLag,jj);
                    N = N + 1;
                end
            end
        end
        if N > 10
            ccMap(centreBin-rowLag,centreBin+colLag) = (N*sumXY - sumX*sumY)/(sqrt(N*sumX2 - sumX^2) * sqrt(N*sumY2 - sumY^2));
        else
            ccMap(centreBin-rowLag,centreBin+colLag) = NaN;
        end
        
        % Row lag >= 0 and column lag <= 0
        sumX = 0;
        sumY = 0;
        sumX2 = 0;
        sumY2 = 0;
        sumXY = 0;
        N = 0;
        for ii = 1:numBins-rowLag
            for jj = 1:numBins-colLag
                if ~isnan(map1(ii+rowLag,jj+colLag)) && ~isnan(map2(ii,jj))
                    sumX = sumX + map1(ii+rowLag,jj+colLag);
                    sumY = sumY + map2(ii,jj);
                    sumX2 = sumX2 + map1(ii+rowLag,jj+colLag)^2;
                    sumY2 = sumY2 + map2(ii,jj)^2;
                    sumXY = sumXY + map1(ii+rowLag,jj+colLag) * map2(ii,jj);
                    N = N + 1;
                end
            end
        end
        if N > 10
            ccMap(centreBin+rowLag,centreBin+colLag) = (N*sumXY - sumX*sumY)/(sqrt(N*sumX2 - sumX^2) * sqrt(N*sumY2 - sumY^2));
        else
            ccMap(centreBin+rowLag,centreBin+colLag) = NaN;
        end
        
        % Row lag <= 0 and column lag >= 0
        sumX = 0;
        sumY = 0;
        sumX2 = 0;
        sumY2 = 0;
        sumXY = 0;
        N = 0;
        for ii = 1:numBins-rowLag
            for jj = 1:numBins-colLag
                if ~isnan(map1(ii,jj)) && ~isnan(map2(ii+rowLag,jj+colLag))
                    sumX = sumX + map1(ii,jj);
                    sumY = sumY + map2(ii+rowLag,jj+colLag);
                    sumX2 = sumX2 + map1(ii,jj)^2;
                    sumY2 = sumY2 + map2(ii+rowLag,jj+colLag)^2;
                    sumXY = sumXY + map1(ii,jj) * map2(ii+rowLag,jj+colLag);
                    N = N + 1;
                end
            end
        end
        if N > 10
            ccMap(centreBin-rowLag,centreBin-colLag) = (N*sumXY - sumX*sumY)/(sqrt(N*sumX2 - sumX^2) * sqrt(N*sumY2 - sumY^2));
        else
            ccMap(centreBin-rowLag,centreBin-colLag) = NaN;
        end
        
        % Row lag <= 0 and column lag <= 0
        sumX = 0;
        sumY = 0;
        sumX2 = 0;
        sumY2 = 0;
        sumXY = 0;
        N = 0;
        for ii = 1:numBins-rowLag
            for jj = 1:numBins-colLag
                if ~isnan(map1(ii+rowLag,jj)) && ~isnan(map2(ii,jj+colLag))
                    sumX = sumX + map1(ii+rowLag,jj);
                    sumY = sumY + map2(ii,jj+colLag);
                    sumX2 = sumX2 + map1(ii+rowLag,jj)^2;
                    sumY2 = sumY2 + map2(ii,jj+colLag)^2;
                    sumXY = sumXY + map1(ii+rowLag,jj) * map2(ii,jj+colLag);
                    N = N + 1;
                end
            end
        end
        if N > 10
            ccMap(centreBin+rowLag,centreBin-colLag) = (N*sumXY - sumX*sumY)/(sqrt(N*sumX2 - sumX^2) * sqrt(N*sumY2 - sumY^2));
        else
            ccMap(centreBin+rowLag,centreBin-colLag) = NaN;
        end
    end
end


end %fnctn