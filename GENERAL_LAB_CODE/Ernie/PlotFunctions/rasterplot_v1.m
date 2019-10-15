% plot raster plot sorted by location of maximal firing rate
function rasterplot_v1(varargin)

if size(varargin,1)==0
    spkfile = targetfile('.t');
elseif size(varargin,1)==1
    spkfile = Readtextfile(varargin{1,1});
end

% obtain position file. should be in 1D environment
posfile = char(targetfile('.nvt'));
[post, posx, posy] = LoadPos(posfile);

if ~isempty(findstr(lower(posfile),'lineartrack'));
    [posx, posy] = axesRotate(posx,posy);
    posxa =  round(posx-nanmin(posx))+1;
elseif ~isempty(findstr(lower(posfile),'circulartrack'));
    [posxa] = circpos(posx, posy);
    posxa =  round(posxa);
    posxa(posxa==0)=360;
end

% obtain spike location
posk = zeros(nanmax(posxa),size(spkfile,1));
for kk = 1:size(spkfile,1)
    spkt = Readtfile(spkfile{kk,1})./10^4;
    spkpos = match(spkt,post);
    
    for aa = 1:size(spkpos,1)
        posk(posxa(spkpos(aa)),kk) = posk(posxa(spkpos(aa)),kk)+1;
    end
    
end

% amount of time in each location
pos = zeros(nanmax(posxa),1);
for pp = 1:size(posxa,2)
    pos(posxa(pp)) = pos(posxa(pp))+1;
end

% cacluate the firing rate at each location for each cell
rate = posk./repmat(pos,1,size(spkfile,1));

% find the location with maximal firing rate
loc_maxFR = zeros(size(rate,2),1);
for m = 1:size(rate,2)
    tcurve = rate(:,m);
    loc_maxFR(m) = find(tcurve==max(tcurve),1);
end

% plot the raster plot according to the location of maximal firing rate for
% each cell
[~, ind] = sort(loc_maxFR,'descend');
figure;
scaling = size(spkfile,1)/nanmax(posxa);
plot(post,posxa.*scaling,'o','color',[.85 .85 .85])
hold on;
for kk = 1:size(ind,1)
    
    spkt = Readtfile(spkfile{kk,1})./10^4;
    plot(spkt,ind(kk),'k.')
end
hold off