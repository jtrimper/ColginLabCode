% Edited version of Paulo Girao's stat function (More descriptive variable
% names and added comments)
% All methods is taken from chapter 26 and 27 of Jerrold H. Zar "Biostatistical
% Analysis, Fourth Edition"
% Edited by Raymond Skjerpeng
function [meanAngle,angDev,vectorLength,rayleighP,rayleighZ,cirDev] = circularStat(spikePhase)

meanAngle = NaN;
angDev = NaN;
vectorLength = NaN;
rayleighP = NaN;rayleighZ = NaN;

if isempty(spikePhase)  % No spikes
    return
end

if max(spikePhase) <= 2*pi % Phases in radians
    x = (nansum(cos(spikePhase))/length(spikePhase));
    y = (nansum(sin(spikePhase))/length(spikePhase));
    r = sqrt((x^2)+(y^2));
    if y >= 0
        meanAngle = atan2(y,x)*180/pi;
    else
        meanAngle = 360+atan2(y,x)*180/pi;
    end
    % Calculate mean angular deviation
    angDev = (180/pi)*sqrt(2*(1-r));
    % Calculate circular standard deviation
    cirDev = (180/pi)*sqrt((-2)*log(r));

else % Phases in degrees
    x = (nansum(cosd(spikePhase))/length(spikePhase));
    y = (nansum(sind(spikePhase))/length(spikePhase));
    r = sqrt((x^2)+(y^2));
    
    if y>=0 && x>0
        meanAngle = atand(y/x);
    elseif x==0 && y>0
        meanAngle = 90;
    elseif y>0 && x<0
        meanAngle = 180 - atand(y/abs(x));
    elseif y==0 && x<0
        meanAngle = 180;
    elseif y<0 && x<0
        meanAngle = 180 + atand(abs(y)/abs(x));
    elseif y<0 && x==0
        meanAngle = 270;
    elseif y<0 && x>0
        meanAngle = 360 - atand(abs(y)/x);
    elseif y==0 && x>0
        meanAngle = 0;
    end
    
    
    % Calculate mean angular deviation
    angDev = (180/pi)*sqrt(2*(1-r));
    % Calculate circular standard deviation
    cirDev = (180/pi)*sqrt((-2)*log(r));
end

% Number of data points
N = length(spikePhase);

% Rayleigh R
R = N * r;

% Calculate the Rayleigh test statistic
rayleighZ = N * r^2;

% Calculate the Rayleigh P. 
% Rayleigh P gives a aproximation to the probaility of Rayleigh R. A value
% below 0.05 (significant level 5%) means that the mean angle is valid.
% (Greenwood and Durand, 1955)
rayleighP = exp(sqrt(1+4*N+4*(N^2-R^2))-(1+2*N));

% The vector length 'r' is a mearsure of concentration
vectorLength = r;