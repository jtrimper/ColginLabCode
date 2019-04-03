function ip = polerr(rho_AVG, rho_SEM, theta_AVG, theta_SEM, colOpts, varargin)
% function polerr(rho_AVG, rho_SEM, theta_AVG, theta_SEM, colOpts, varargin)
%
% SUMMARY: 
%   Makes a polar plot with radial and angular 'error bars' plotted as partially transparent polygons.
%
% INPUT: 
%  rho_AVG = vector of rho (length) values; function will plot one line + error triangles for each of these values
%  rho_SEM = error values that line up with rho_AVG (radial error)
%  theta_AVG = vector of theta (angle) values in radians that line up with rho_AVG
%  theta_SEM = vector of theta error values in radians (angular error)
%  colOpts = length(rho_AVG) x 3 matrix of color triplets; colors to use for each number in rho_AVG
%  varargin = options: 
%               1. flag 'phaseLabel' ; if present, function deletes 'ticks' on the polar plot and labels them by familiar phase initials
%                                    e.g., P (peak), F (falling), T (trough), R (rising)
%               2. flag 'difLabel' ; if present, function changes markers for 0, 90, 180, and 270 to 0 90 +/- 180 -90
%               3. flag 'noLabel' ; if present, function deletes all ticks and magnitude labels
%
% OUTPUT: 
%  ip = handle for the initial polar plot, used for setting the range and tick labels
%
% EXAMPLE INPUTS: 
%   theta_SEM = [.1*pi .05*pi .025*pi .15*pi];
%   rho_AVG = [.2 .3 .4 .35];
%   rho_SEM = [.02 .05 .08 .03];
%   theta_AVG = [0 .5*pi pi 1.5*pi];
%   colOpts = [1 0 0; 0 1 0; 0 0 1; 0 1 1];
%   
% TODO: 
%  Figure out how to define a custom range, since polar will only allow certain values. 
%
% JB Trimper
% 8/2016
% Manns Lab

maxRad = max(rho_AVG + rho_SEM); %get the max radius that will be plotted and use that to define the range of the plot
ip = polar([0 0], [0 maxRad]);%make the initial polar plot
set(ip, 'Color', [0.85938 0.85938 0.85938]);%and set the line you plotted to be the same color as the background plot

if nargin == 6
    if strcmpi(varargin{1}, 'phaseLabel')
        textObjs = findall(gca, 'type', 'text'); %get all the text objects on the polar plot
        textObjs(1).String = 'P';%replace the 0, 90, 180, and 270 degree markers with phase initials
        textObjs(8).String = 'F';
        textObjs(2).String = 'T';
        textObjs(7).String = 'R';
        delete(textObjs([3 4 5 6 9 10 11 12 14 15 16])); %delete all of the angle tick labels
    end
    if strcmpi(varargin{1}, 'difLabel')
        textObjs = findall(gca, 'type', 'text'); %get all the text objects on the polar plot
        textObjs(1).String = '0';%replace the 0, 90, 180, and 270 degree markers with phase difference values
        textObjs(8).String = '90';
        textObjs(2).String = '+/-180';
        textObjs(7).String = '-90';
        delete(textObjs([3 4 5 6 9 10 11 12 14 15 16])); %delete all of the angle tick labels
    end
    if strcmpi(varargin{1}, 'noLabel')
        textObjs = findall(gca, 'type', 'text'); %get all the text objects on the polar plot
        delete(textObjs(1:16)); %delete all labels
    end
end

hold on;


for i = 1:length(rho_AVG) %going to plot a line with error bars for each digit in this vector
    
    rho = rho_AVG(i); %length
    rho_err = rho_SEM(i); %length error
    rho_errLims = [ rho-rho_err  rho+rho_err];%define top and bottom limits 
    
    ang = theta_AVG(i); %angle
    ang_err = theta_SEM(i); %angle error
    ang_errLims = [ ang-ang_err  ang+ang_err];
    
    angRange = ang_errLims(1):.01:ang_errLims(2); %make a vector that spans the angular range
    bottomRhos = repmat(rho_errLims(1), 1, length(angRange));%make a vector of length(rho_errLims(1)) that is the same length as angRange
    topRhos = repmat(rho_errLims(2), 1, length(angRange));%make a vector of length(rho_errLims(2)) that is the same length as angRange
    
    [botCurve_X, botCurve_Y] = pol2cart(angRange, bottomRhos);%get the cartesian coordinates for the curves defined by these rho/angle vector combinations
    [topCurve_X, topCurve_Y] = pol2cart(angRange, topRhos);
    
    hold on;
    pp = polar([0 ang], [0 rho]); %plot the average vector
   
    set(pp, 'Color', colOpts(i,:), 'LineWidth', 1.5);
   
    botTri = fill([0 botCurve_X 0], [0 botCurve_Y 0], [1 1 1]); %plot the bottom error triangle
    alpha(.05); %and make it quite transparent
    set(botTri, 'EdgeColor', colOpts(i,:));

    topQuad = fill([botCurve_X(1) topCurve_X flip(botCurve_X)], [botCurve_Y(1) topCurve_Y flip(botCurve_Y)], colOpts(i,:)); %plot the top error quadrilateral

    alpha(.25); %and make it partially transparent
    set(topQuad, 'EdgeColor', colOpts(i,:));
end