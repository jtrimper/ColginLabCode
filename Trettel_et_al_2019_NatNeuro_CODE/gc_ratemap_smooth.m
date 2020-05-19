function smRateMap = gc_ratemap_smooth(rateMap)
% function smRateMap = gc_ratemap_smooth(rateMap)
%
% PURPOSE: 
%   To apply Sean's gaussian smoothing box to the rate maps
%
% INPUT: 
%  rateMap = unsmoothed ratemap
%
% OUTPUT: 
%   smRateMap = smoothed rateMap
%
% JB Trimper 8/2017
% Colgin Lab


% This is the smoothing box Sean said to use
[xx,yy] = meshgrid(-2:2, -2:2);
box =  exp(-(xx.^2+yy.^2)./(2*1.5.^2));
box = box ./ sum(box(:)); % <- but I'm assuming it needs to be normalized... 


% Using pos and phase naming for the bins originate from the first use of
% this function.
[numPhaseBins,numPosBins] = size(rateMap); %"Phase" = x, dim1; "Pos" = y, dim2

smRateMap = zeros(numPhaseBins,numPosBins);

for ii = 1:numPhaseBins
    for jj = 1:numPosBins
        if ~isnan(rateMap(ii,jj))
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
                    if ~isnan(rateMap(phaseInd,posInd)) %JT modification
                        smRateMap(ii,jj) = smRateMap(ii,jj) + rateMap(phaseInd,posInd) * box(k,l);
                    end
                end
            end
        end
    end
end

smRateMap(isnan(rateMap)) = NaN; %make sure NaNs, indicating rat didn't enter that pixel, stay as NaNs

end %fnctn
