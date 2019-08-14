function [post,posx,posy,Circle, xScale, yScale] = LoadCircPos(file)

fieldSelection(1) = 1; % Timestamps
fieldSelection(2) = 1; % Extracted X
fieldSelection(3) = 1; % Extracted Y
fieldSelection(4) = 0; % Extracted Angel
fieldSelection(5) = 0;  % Targets
fieldSelection(6) = 0; % Points
% Do we return header 1 = Yes, 0 = No.
extractHeader = 0;
% 5 different extraction modes, see help file for Nlx2MatVT
extractMode = 1; % Extract all data
[t2, x, y] = Nlx2MatVT(file,fieldSelection,extractHeader,extractMode);

t = t2*10^-6; %convert to seconds


cfg.square.boxscale=100;


boxscale = cfg.square.boxscale;


xx = x(x>0 & y>0);
yy = y(x>0 & y>0);
tt = t(x>0 & y>0);

%find and report the largest missing chunk of time:
% fprintf('\nLargest time chunk missing: %3.4f\n',max(diff(tt-t(1))));

posx=interp1(tt,xx,t,'linear');
posy=interp1(tt,yy,t,'linear');
post=t;


replace_end = find(diff(isnan(posx))==1);
if ~isempty(replace_end)
    posx(replace_end+1:end) = posx(replace_end);
    posy(replace_end+1:end) = posy(replace_end);
end

replace_start = find(diff(isnan(posx))==-1);
if ~isempty(replace_start)
    posx(1:replace_start) = posx(replace_start+1);
    posy(1:replace_start) = posy(replace_start+1);
end

[sspeed] = speedestimated(post,posx,posy,'circular');
speed_thr = sspeed>prctile(sspeed,80);

%scale and center trajectory
D = 90; % in cm
ellipse = fit_ellipse(posx(speed_thr),posy(speed_thr));
z = [ellipse.X0_in, ellipse.Y0_in];
a = ellipse.a;
b = ellipse.b;
alpha = ellipse.phi;
%Translate
posx = posx-z(1);
origPosX = posx; 
posy = posy-z(2);
origPosY = posy; 

%Rotate
Q = [cos(-alpha), -sin(-alpha); sin(-alpha) cos(-alpha)];
ftemp = Q*[posx;posy];
%Scale
ftemp(1,:) = 0.5*D/a*ftemp(1,:);
ftemp(2,:) = 0.5*D/b*ftemp(2,:);
%Rotate back to orginal orientation
Q = [cos(alpha), -sin(alpha); sin(alpha) cos(alpha)];
ftemp = Q*ftemp;
posx = ftemp(1,:);
posy = ftemp(2,:);

newPosX = posx;
newPosY = posy;

xScale = (max(newPosX) - min(newPosX)) / (max(origPosX) - min(origPosX));
yScale = (max(newPosY) - min(newPosY)) / (max(origPosY) - min(origPosY));

[xc,yc,R] = circfit(posx(speed_thr),posy(speed_thr));
Circle.xc = xc;
Circle.yc = yc;
Circle.radius = R;

end%fnctn