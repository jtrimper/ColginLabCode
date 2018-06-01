% Calculates the head direction for each position sample pair. Direction
% is defined as east = 0 degrees, north = 90 degrees, west = 180 degrees,
% south = 270 degrees. Direction is set to NaN for missing samples.
%
% Version 1.0
% 06. Jan. 2009
%
% Version 1.1       Switch the 2 diodeds. Big spot is in the front.
% 23. Mar. 2010
%
% (c) Raymond Skjerpeng, CBM/KISN, NTNU, 2009-2010.
function direct = headDirection(x1,y1,x2,y2)


direct = 360 * atan2(y2-y1,x2-x1) / (2*pi) + 180;
