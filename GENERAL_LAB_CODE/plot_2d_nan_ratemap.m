function rmHndl = plot_2d_nan_ratemap(rateMap, rmBinSize)
% function rmHndl = plot_2d_nan_ratemap(rateMap, rmBinSize)
%
% PURPOSE: 
%  To plot rate map but gray out the NaNs for they don't just show up as zeros
%
% INPUT: 
%  rateMap = the n x m matrix of firing rate by position bin
%  rmBinSize = optional input saying the size of each bin in cm
%              if left out, plot will just use bin indices for x & y
%
% OUTPUT:
%  rmHndl = handle for the rate map
%
% JB Trimper
% 9/2017
% Colgin Lab

colMap = [.5 .5 .5; jet(100)]; 

xVals = 1:size(rateMap,1);
yVals = 1:size(rateMap,2);
if nargin == 2
    xVals =  (xVals * rmBinSize) - rmBinSize/2; 
    yVals =  (yVals * rmBinSize) - rmBinSize/2; 
end

%rescale the ratemap
minVal = min(rateMap(:)); 
rateMap = rateMap - minVal; %make it so the lowest value is zero
maxVal = max(rateMap(:)); %find the new maximum
rateMap = rateMap ./ maxVal; 
  
rateMap(isnan(rateMap)) = -.01; 
rmHndl = imagesc(xVals, yVals, rateMap); 
axis xy
colormap(colMap)
caxis([-.01 1])


end %fnctn