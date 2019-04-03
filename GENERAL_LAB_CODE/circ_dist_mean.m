function [mra, mrl] = circ_dist_mean(thetaBinEdges, rhoVals)
% function [mra, mrl] = circ_dist_mean(thetaVals, rhoVals)
%
% PURPOSE: 
%   Function to find the mean resultant vector coordinates based on circular
%   histogram data (i.e., a vector of angles and a vector of lengths). 
%   
% INPUT: 
%   thetaVals = vector of length n+1 containing the edges for the binned angles (in radians) 
%     rhoVals = vector of length n containing the rho values paired with each angle above
%
% OUTPUT:
%  mra = mean resultant angle
%  mrl = mean resultant length
%
% JB Trimper
% 08/2018
% Colgin Lab


binCntrs = edges_to_x_vals(thetaBinEdges); %get the center of each bin

cartCoords = zeros(2,length(binCntrs)); %pre-allocating for polar coords converted to cartesian
for pb = 1:length(binCntrs)
    [cartCoords(1,pb), cartCoords(2,pb)] = pol2cart(binCntrs(pb), rhoVals(pb));
end
cartAvg = mean(cartCoords,2); 

[mra, mrl] = cart2pol(cartAvg(1), cartAvg(2));


end