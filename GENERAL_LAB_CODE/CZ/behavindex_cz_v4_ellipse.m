function [index,totaltimeNOV,totaltimeFAM] = behavindex_cz_v4_ellipse(xnov,ynov,xfam,yfam,radius,starttime,endtime,scale_x,scale_y,vel_limit)
%returns the time windows he was within the radius of interest (start in
%1st column; stoptimes in 2nd column); 
%xobj yobj is the lcoation of the center of object of interest

% radius = [r_x_nov, r_y_nov;r_x_fam, r_y_fam];

if size(radius,1) == 1
    r_x_nov = radius(1,1);
    r_y_nov = radius(1,2);
    r_x_fam = radius(1,1);
    r_y_fam = radius(1,2);
elseif size(radius,1) == 2
    r_x_nov = radius(1,1);
    r_y_nov = radius(1,2);
    r_x_fam = radius(2,1);
    r_y_fam = radius(2,2);
end

vfs = 30;
[t,x,y] = loadPos_rescaled_cz('VT1.nvt',scale_x,scale_y,vfs);
starttime = starttime *60 + t(1);
endtime = endtime *60 + t(1);

% Speed
timelimit=120;   % ======= set the highest speed, unit is cm/s ========
vel=speed2D(x,y,t); %velocity in cm/s
vel(vel>=timelimit) = 0.5*(vel(circshift((vel>=timelimit),-3)) + vel(circshift((vel>=timelimit),3)));


minx = min(x);
maxx = max(x);
miny = min(y);
maxy = max(y);
xbin = 3;
ybin = 3;
xbins = floor((maxx-minx)/xbin);
ybins = floor((maxy-miny)/ybin);
xaxis0 = minx+xbin/2:xbin:maxx-xbin/2;
yaxis0 = miny+ybin/2:ybin:maxy-ybin/2;
axis0 = {xaxis0,yaxis0};

dx = (xfam - x).^2/r_x_fam^2 + (yfam - y).^2/r_y_fam^2;
indtimes = find(t >= starttime & t<endtime);
indradius = find(dx <= 1);
indvel = find(vel >= vel_limit(1) & vel <= vel_limit(2));
indaccept = intersect(indtimes,indradius);
indaccept = intersect(indaccept,indvel);
totaltimeFAM = length(indaccept) * (1/vfs);
x0 = x(indaccept)';
y0 = y(indaccept)';
z=(hist3([x0,y0],axis0))';
ind = find(z>0);
if ~isempty(ind)
    bintimeFAM = totaltimeFAM/length(ind);
else
    bintimeFAM = 0;
end

% figure; plot(x(indtimes),y(indtimes)); hold on
% plot(x(indaccept),y(indaccept),'r.')

dx = (xnov - x).^2/r_x_nov^2 + (ynov - y).^2/r_y_nov^2;
indtimes = find(t >= starttime & t<endtime);
indradius = find(dx <= 1);
indvel = find(vel >= vel_limit(1) & vel <= vel_limit(2));
indaccept = intersect(indtimes,indradius);
indaccept = intersect(indaccept,indvel);
totaltimeNOV = length(indaccept) * (1/vfs);
x0 = x(indaccept)';
y0 = y(indaccept)';
z=(hist3([x0,y0],axis0))';
ind = find(z>0);
if ~isempty(ind)
    bintimeNOV = totaltimeNOV/length(ind);
else
    bintimeNOV = 0;
end

index_total = (totaltimeNOV)/(totaltimeNOV+totaltimeFAM);
index_bin = (bintimeNOV)/(bintimeNOV+bintimeFAM);
index = [index_total,index_bin];
% 
% plot(x(indaccept),y(indaccept),'g.')
% keyboard

