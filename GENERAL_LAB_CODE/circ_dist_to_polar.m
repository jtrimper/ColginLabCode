function [angVctr, rhoVctr] = circ_dist_to_polar(thetaVals, rhoVals)
% function [angVctr, rhoVctr] = circ_dist_to_polar(thetaVals, rhoVals)
%
% PURPOSE:
%  The 'polar' plotting function requires zero-padded vectors. This function
%  prepares those.
%
% INPUT:
%   thetaVals = vector of length n+1 containing the edges for the binned angles (in radians)
%     rhoVals = vector of length n containing the rho values paired with each angle above
%
% OUTPUT:
%  angVctr = zero-padded vector of angles ready for use in 'polar' function
%  rhoVctr = zero-padded vector of lengths ready for use in 'polar' function
%
% JB Trimper
% 8/2018
% Colgin Lab


rhoVctr = zeros(1,4*length(rhoVals));
rhoVctr(2:4:end) = rhoVals;
rhoVctr(3:4:end) = rhoVals;

angVctr = zeros(1,4*length(rhoVals));
angVctr(2:4:end) = thetaVals(1:end-1);
angVctr(3:4:end) = thetaVals(2:end);


end