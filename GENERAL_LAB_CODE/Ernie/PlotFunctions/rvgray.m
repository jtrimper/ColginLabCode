function g = rvgray(m)
%GRAY   Linear gray-scale color map
%   GRAY(M) returns an M-by-3 matrix containing a gray-scale colormap.
%   GRAY, by itself, is the same length as the current figure's
%   colormap. If no figure exists, MATLAB creates one.
%
%   For example, to reset the colormap of the current figure:
%
%             colormap(rvgray)
%
%   See also HSV, HOT, COOL, BONE, COPPER, PINK, FLAG, 
%   COLORMAP, RGBPLOT.

%   Copyright 1984-2004 The MathWorks, Inc.

if nargin < 1, m = size(get(gcf,'colormap'),1); end
g = (sort(0:m-1,'descend'))'/max(m-1,1);
g = [g, g, g];
