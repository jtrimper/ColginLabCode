function [index,totaltimeNOV,totaltimeFAM] = behavindex_cz_v3_quadrant(xnov,ynov,xfam,yfam,radius,starttime,endtime,scale_x,scale_y,vel_limit)
%returns the time windows he was within the radius of interest (start in
%1st column; stoptimes in 2nd column); 
%xobj yobj is the lcoation of the center of object of interest

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
midx = (minx+maxx)/2;
miny = min(y);
maxy = max(y);
midy = (miny+maxy)/2;
xbin = 3;
ybin = 3;
xbins = floor((maxx-minx)/xbin);
ybins = floor((maxy-miny)/ybin);
xaxis0 = minx+xbin/2:xbin:maxx-xbin/2;
yaxis0 = miny+ybin/2:ybin:maxy-ybin/2;
axis0 = {xaxis0,yaxis0};

quad_border = [minx, midx, miny, midy;
    minx, midx, midy, maxy;
    midx, maxx, miny, midy;
    midx, maxx, midy, maxy];

% familiar quadrant
ind_quad = 0;
for nq = 1:size(quad_border,1)
    if xfam > quad_border(nq,1) && xfam <= quad_border(nq,2) && yfam > quad_border(nq,3) && yfam <= quad_border(nq,4)
        ind_quad = nq;
        break
    end
end
indtimes = find(t >= starttime & t<endtime);
ind_inquad = find(x > quad_border(ind_quad,1) & x <= quad_border(ind_quad,2) & y > quad_border(ind_quad,3) & y <= quad_border(ind_quad,4));
indvel = find(vel >= vel_limit(1) & vel <= vel_limit(2));
indaccept = intersect(indtimes,ind_inquad);
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


% novel quadrant
ind_quad = 0;
for nq = 1:size(quad_border,1)
    if xnov > quad_border(nq,1) && xnov <= quad_border(nq,2) && ynov > quad_border(nq,3) && ynov <= quad_border(nq,4)
        ind_quad = nq;
        break
    end
end
indtimes = find(t >= starttime & t<endtime);
ind_inquad = find(x > quad_border(ind_quad,1) & x <= quad_border(ind_quad,2) & y > quad_border(ind_quad,3) & y <= quad_border(ind_quad,4));
indvel = find(vel >= vel_limit(1) & vel <= vel_limit(2));
indaccept = intersect(indtimes,ind_inquad);
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

