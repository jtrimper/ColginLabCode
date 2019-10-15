function smRateMap = smooth_2d_ratemap(rateMap, boxSize)
% function smRateMap = smooth_2d_ratemap(rateMap, boxSize)
%
% PURPOSE:
%   To apply Gaussian smoothing box to the 2d rate map.
%
% INPUT:
%  rateMap = unsmoothed ratemap
%  boxSize = Optional input indicating how many bins to include in the Gauss smoothing box
%            - Box will be of size 'boxSize^2'
%            - Needs to be an odd number!
%            - Best values either 5 or 7, depending on your rateMap
%              bin size (more bins / cm = greater box size). Max sensible value is 9.
%            - If input 'boxSize' is not provided, function defaults to boxSize = 5
%
% OUTPUT:
%   smRateMap = smoothed rateMap
%
% JB Trimper
% 8/2017
% Colgin Lab



%If boxSize not provided, default to 5
if nargin == 1
    boxSize = 5;
end


% Make your Gaussian smoothing box
binSize = (boxSize-1)/2;
[xx,yy] = meshgrid(-binSize:binSize, -binSize:binSize);
gausBox =  exp(-(xx.^2+yy.^2)./(2*1.5.^2));
gausBox = gausBox ./ sum(gausBox(:)); % <- but I'm assuming it needs to be normalized...

% Using pos and phase naming for the bins originate from the first use of
% this function.
[numPhaseBins,numPosBins] = size(rateMap); %"Phase" = x, dim1; "Pos" = y, dim2


% Apply the smoothing
smRateMap = zeros(numPhaseBins,numPosBins);
for ii = 1:numPhaseBins
    for jj = 1:numPosBins
        if ~isnan(rateMap(ii,jj))
            for k = 1:boxSize
                % Phase (x,dim1) index shift
                sii = k-ceil(boxSize/2);
                % Phase (x,dim1) index
                phaseInd = ii+sii;
                % Boundary check
                if phaseInd<1
                    phaseInd = 1;
                end
                if phaseInd>numPhaseBins
                    phaseInd = numPhaseBins;
                end
                
                for l = 1:boxSize
                    % Position (y,dim2) index shift
                    sjj = 1-ceil(boxSize/2);
                    % Position (y,dim2) index
                    posInd = jj+sjj;
                    % Boundary check
                    if posInd<1
                        posInd = 1;
                    end
                    if posInd>numPosBins
                        posInd = numPosBins;
                    end
                    % Add to the smoothed rate for this bin
                    if ~isnan(rateMap(phaseInd,posInd)) %JT modification
                        smRateMap(ii,jj) = smRateMap(ii,jj) + rateMap(phaseInd,posInd) * gausBox(k,l);
                    end
                end
            end
        end
    end
end

smRateMap(isnan(rateMap)) = NaN; %make sure NaNs, indicating rat didn't enter that pixel, stay as NaNs

end %fnctn
