function [sspeed] = speedestimated(post,posx,posy,varargin)

sampfreq = 1/mean(diff(post));
if nargin == 3
    distance = sqrt(diff(posx).^2+diff(posy).^2);    
    speed = distance*sampfreq;

    sspeed = smooth(speed,round(sampfreq/2),'lowess');
    sspeed(end+1)=0;
    
elseif nargin >= 4
    track_shape = varargin{1};
    if strcmp(track_shape,'circular')
        if nargin == 5
            R = varargin{2};
            angle_rad = -unwrap(atan2(posy,posx));
        else
            [~,~,R] = circfit(posx,posy);
            [angle_deg] = circpos(posx, posy);
            angle_rad = -unwrap(angle_deg/360*2*pi);
        end
        sangle_rad = smooth(angle_rad,round(sampfreq/4));
        distance = diff(sangle_rad)*R; %in cm
        speed = distance*sampfreq;
        
        sspeed = abs(smooth(speed,round(sampfreq/2),'lowess'));
        sspeed(end+1)=0; 
    end
end