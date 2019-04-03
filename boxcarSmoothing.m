function sMap = boxcarSmoothing(map)
% function sMap = boxcarSmoothing(map)
%
% PURPOSE: Applies a Gaussian smoothing kernel to a 2D map.
%          Function given to JBT by SGT.
%
% JT modified 8/2017
%    The way it was, any NaNs within the gaussian kernel would turn every
%    point covered by that kernel into a NaN. I'm doing away with that so
%    only points that inputted as NaNs are outputted as NaNs.


%Gaussian box
box = [0.0025 0.0125 0.0200 0.0125 0.0025;...
    0.0125 0.0625 0.1000 0.0625 0.0125;...
    0.0200 0.1000 0.1600 0.1000 0.0200;...
    0.0125 0.0625 0.1000 0.0625 0.0125;...
    0.0025 0.0125 0.0200 0.0125 0.0025;];

% Using pos and phase naming for the bins originate from the first use of
% this function.
[numPhaseBins,numPosBins] = size(map); %"Phase" = x, dim1; "Pos" = y, dim2

sMap = zeros(numPhaseBins,numPosBins);

for ii = 1:numPhaseBins
    for jj = 1:numPosBins
        if ~isnan(map(ii,jj))
            for k = 1:5
                % Phase (x,dim1) index shift
                sii = k-3;
                % Phase (x,dim1) index
                phaseInd = ii+sii;
                % Boundary check
                if phaseInd<1
                    phaseInd = 1;
                end
                if phaseInd>numPhaseBins
                    phaseInd = numPhaseBins;
                end
                
                for l = 1:5
                    % Position (y,dim2) index shift
                    sjj = l-3;
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
                    if ~isnan(map(phaseInd,posInd)) %JT modification
                        sMap(ii,jj) = sMap(ii,jj) + map(phaseInd,posInd) * box(k,l);
                    end
                end
            end
        end
    end
end

sMap(isnan(map)) = NaN; %make sure NaNs, indicating rat didn't enter that pixel, stay as NaNs





