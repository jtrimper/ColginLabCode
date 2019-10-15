function [post,posx,posy,Circle] = LoadPos(file)

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

if ~isempty(strfind(file,'Rat'));
    temp = strfind(file,'Rat');
    temp2 = strfind(file(temp:end),'\');
    subfile = file(temp:end);
    
    ratID = subfile(1:temp2(1)-1);
    disp(ratID)
    if exist(ratID,'file')==2
        [cfg] = eval(ratID);
    else
        disp('no configuration file. Use default')
        cfg.square.boxscale=100;
    end
    
else
    disp('Unknown rat')
    cfg.square.boxscale=100;
end

    boxscale = cfg.square.boxscale;

if ~isempty(findstr(lower(file),'lineartrack'));
    fprintf('\nLinear Track');
    
    xx= x((y>0==x>0)==0 & ~isnan(x));
	yy= y((y>0==x>0)==0 & ~isnan(x));
	tt = t((y>0==x>0)==0 & ~isnan(x));

	%tracklength = 198; %track length in cm
    [rx, ry] = axesRotate(xx,yy);
    scale = 198/(max(rx)-min(rx));
    sx = rx*scale; %convert from pixel to cm
    sy = ry*scale;
    
    sx = sx-min(sx);
    sy = sy-min(sy);
    
	%find and report the largest missing chunk of time:
	fprintf('\nLargest time chunk missing: %3.4f\n',max(diff(tt-t(1))));

	%Fill in the gaps that the camera missed by linear interpolation
	posx=interp1(tt,sx,t,'linear');
	posy=interp1(tt,sy,t,'linear');
	post=t;		

	% Moving window mean filter
	for cc = 8:length(posx)-7
		posx(cc) = nanmean(posx(cc-7:cc+7));   
		posy(cc) = nanmean(posy(cc-7:cc+7));
    end
    
elseif ~isempty(findstr(lower(file),'square'));
	fprintf('\nSquare');
    
    %Clear zero values and rescale the positions onto a -50:50 cm square grid NOTE: this assumes that the rat reached each wall at least once
	xx= x((y>0==x>0)==0 & ~isnan(x));
	yy= y((y>0==x>0)==0& ~isnan(x));
	tt = t((y>0==x>0)==0& ~isnan(x));
	
	c_x = (max(xx)-min(xx))/2 + min(xx);
	c_y = (max(yy)-min(yy))/2 + min(yy);
	cfac_x=boxscale*(max(abs(xx))-c_x)/(boxscale/2);
	cfac_y=boxscale*(c_y-max(abs(yy)))/(boxscale/2);
	xx=boxscale*(xx-c_x)/cfac_x;
	yy=boxscale*(c_y-yy)/cfac_y;

	% Create backup structures in case too much interpolation is required
	bak_x = x;
	bak_y=y;
	bak_t=t;
	bak_x((y>0==x>0)==0 & ~isnan(x)) = xx;
	bak_y((y>0==x>0)==0 & ~isnan(x)) = yy;
	bax_x(~((y>0==x>0)==0 & ~isnan(x)))=nan;
	bak_y(~((y>0==x>0)==0 & ~isnan(x)))=nan;
	bak_t(~((y>0==x>0)==0 & ~isnan(x)))=nan;

	%find and report the largest missing chunk of time:
	fprintf('\nLargest time chunk missing: %3.4f\n',max(diff(tt-t(1))));

	%Fill in the gaps that the camera missed by linear interpolation
	posx=interp1(tt,xx,t,'linear');
	posy=interp1(tt,yy,t,'linear');
	%rescale time such that t0=0
	post=t;
    
elseif ~isempty(findstr(lower(file),'circulartrack'));
    xx = x(x>0 & y>0);
    yy = y(x>0 & y>0);
    tt = t(x>0 & y>0);
        
    %find and report the largest missing chunk of time:
	fprintf('\nLargest time chunk missing: %3.4f\n',max(diff(tt-t(1))));
    
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
    posy = posy-z(2);
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
    
    [xc,yc,R] = circfit(posx(speed_thr),posy(speed_thr));
    Circle.xc = xc;
    Circle.yc = yc;
    Circle.radius = R;

    % check how well the fit is
%     figure;plot(posx,posy)
%     axis square tight
%     ang=0:0.01:2*pi;
%     xp=R*cos(ang);
%     yp=R*sin(ang);hold on;
%     plot(xc+xp,yc+yp,'r');
%     xp=(R-5)*cos(ang);
%     yp=(R-5)*sin(ang);hold on;
%     plot(median(xc)+xp,median(yc)+yp,'r');
%     xp=(R+5)*cos(ang);
%     yp=(R+5)*sin(ang);hold on;
%     plot(median(xc)+xp,median(yc)+yp,'r');
else 
    error('unknown arena')
end