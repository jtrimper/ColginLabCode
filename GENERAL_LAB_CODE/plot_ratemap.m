function rmHndl = plot_ratemap(rateMap, rmBinSize, greyNans)
% function rmHndl = plot_ratemap(rateMap, rmBinSize, greyNans)
%
% PURPOSE:
%  To plot rate map but gray out the NaNs for they don't just show up as zeros
%
% INPUT:
%    rateMap = the n x m matrix of firing rate by position bin
%  rmBinSize = Optional nput giving the size of each bin in cm
%              - If empty or nargin == 1, plot will have indices as ticks rather than cm
%   greyNans = optional binary input indicating whether(1) or not(0) to grey
%              out the NaNs in the ratemap. I.e., This will make it so
%              the spots that the rat didn't visit aren't the same color
%              as the spots that the rat visited but no spikes occurred.
%              - If this input is absent, function defaults to greyNans = 1;
%
% OUTPUT:
%  rmHndl = handle for the rate map
%
%  NOTE: 
%   Earlier version with less options titled 'plot_2d_nan_ratemap'
%
% JB Trimper
% 8/2019
% Colgin Lab


%Evaluate whether or not to grey out the NaNs
if nargin < 3
    greyNans = 1;
end

%Figure out X and Y axis values 
xVals = 1:size(rateMap,1); %just indices
yVals = 1:size(rateMap,2);

if exist('rmBinSize', 'var')
    xVals =  (xVals * rmBinSize) - rmBinSize/2;
    yVals =  (yVals * rmBinSize) - rmBinSize/2;
end


%Normalize the ratemap to the max val
if nansum(rateMap(:)) > 0 %don't do this if ALL the values are already 0
    maxVal = max(rateMap(:)); %find the new maximum
    rateMap = rateMap ./ maxVal;
end

%Grey out the NaNs if you chose to do so
if greyNans == 1
    colMap = [.5 .5 .5; jet(100)];
    rateMap(isnan(rateMap)) = -.01;
else
    colMap = jet(100); 
end

% Plot the ratemap
rmHndl = imagesc(xVals, yVals, rateMap);
axis xy %flip the axes to normal orientation
colormap(colMap) %Make the colorscale 'jet' (field standard)

if greyNans == 1 %Make sure the color scale matches up to grey out the NaNs
    caxis([-.01 1])
else
    caxis([0 1]) %... or just cover the whole range
end


end %fnctn