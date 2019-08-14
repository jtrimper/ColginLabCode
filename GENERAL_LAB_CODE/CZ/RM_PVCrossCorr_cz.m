function PVCrossCorr = RM_PVCrossCorr_cz(stack1_active,stack2_active,cutoff,nonzero,plotmax)
% Do a cross-correlation analysis of the population vectors
% Modified from function 'remapV3_morph'

% Input:
%       stack1_active and stack2_active: nbin*nbin*ncell ratemap matrix from two sessions
%       (active: especially the peak rate of each cell in either session is larger
%       than cutoff (1Hz))
%       plotmax: plot all the crosscorr map in the same scale
% Output: struct PFCorr
%       PVCrossCorr.Corr: Cross correlation matrix
if nargin < 5
    plotmax=0;
end
nbin = size(stack1_active,1);
nbin_corr = nbin*2-1;  % number of bins in corrlation matrix
centreBin = (nbin_corr+1)/2; % Index for the centre bin in the correlation map
ncell=size(stack1_active,3);   % number of cells

% Parameters setting
% cutoff = 1; % cutoff by peak rate (peak rate >= 1Hz)
% nonzero = 0.2; % cutoff by firing rate (firing rate >= 0.2Hz)
% NaN firing rate in unvisited bins

% turn dot product on/off
% if dot=='on', use 'normalize'
% if dot=='off', use 'Pearson' CorrCoef
dot = 'off';

% Allocate memory for the cross-correlation map
Rxy = zeros(nbin_corr);  % nbin_corr*nbin_corr matrix
Rdistance = zeros(nbin_corr);

% Do the correlation calculation with a 4 times nested for-loop
for ii = 1:nbin_corr
    % Offset in the x-direction for the second map
    xi = ii-centreBin;
    for jj = 1:nbin_corr
        % Offset in the y-direction for the second map
        yi = jj-centreBin;
        % Counts number of bins that contribute to the current point of
        % the cross-correlation map
        NB = 0; % counts of rate bins
        NB0 = 0; % counts of NaN bins, i.e. unvisited bins
        average_map1 = NaN(nbin);
        average_map2 = NaN(nbin);
        for k1 = 1:nbin  % k1,h1 -- bin number of stack1
            for h1 = 1:nbin
                k2=k1-xi;  % k2,h2 -- bin number of stack2, corresponding to k1,h1 of stack1
                h2=h1-yi;
                if k2>0 && k2<=nbin && h2>0 && h2<=nbin
                    c1=stack1_active(k1,h1,:);
                    c1=reshape(c1,ncell,1);
                    c2=stack2_active(k2,h2,:);
                    c2=reshape(c2,ncell,1);
                    index = find(~isnan(c1)& ~isnan(c2)& (c1 > nonzero | c2 > nonzero));
                    if length(index)>1
                        c1=c1(index);
                        c2=c2(index);
                        NB = NB +1;
                        if ncell > 1
                            if strcmp(dot,'on')
                                %disp('normalize');
                                norm = sqrt(sum(c1.*c1)) * sqrt(sum(c2.*c2));
                                Rxy(ii,jj) = Rxy(ii,jj) + (sum(c1.*c2))/norm;
                            else
                                %disp('Pearson');
                                corr_coeff = corrcoef(c1,c2);
                                Rxy(ii,jj) = Rxy(ii,jj) + corr_coeff(1,2);
                            end
                        else
                            Rxy(ii,jj) = 0;
                        end
                        average_map1(k1,h1) = nanmean(c1);
                        average_map2(k1,h1) = nanmean(c2);
                    else
                        NB0 = NB0 +1;
                        average_map1(k1,h1) = NaN;
                        average_map2(k1,h1) = NaN;
                    end
                end
            end
        end
        if NB~=0
            if ncell > 1
                Rxy(ii,jj) = Rxy(ii,jj)/NB;
            else
                [r,c] = find(~isnan(average_map1)& ~isnan(average_map2)& (average_map1 > nonzero | average_map2 > nonzero));
                x=diag(average_map1(r,c),0);  % x=X(r,c); returns matrix
                y=diag(average_map2(r,c),0);
                spatial_corr = corrcoef(x,y);
                Rxy(ii,jj) = spatial_corr(1,2);
            end
        else
            Rxy(ii,jj)=NaN;
        end
        if (xi == 0 && yi == 0)
            Rdistance(ii,jj) = 0;
        else
            Rdistance(ii,jj) = sqrt(xi*xi+yi*yi);
        end
    end
end

% Output RateOverlap
PVCrossCorr = struct('Corr',Rxy);

% Draw the cross-correlation map
figure(1);
binWidth = 4;

start = -(floor(nbin_corr/2)*binWidth);
stop = floor(nbin_corr/2)*binWidth;
rxyAxis = start:binWidth:stop;
Rdraw = Rxy;
Rdraw(Rxy < 0) = 0;
if plotmax == 0
    plotmax = max(max(Rxy));
end
drawfield(Rdraw,rxyAxis,'jet',plotmax);
axis square
        
figure(2);
hold on;
Rmean=zeros(1,20);
Rsem=zeros(1,20);
for i = 1:20
    distance_bin = 0.50001;
    Rvalues = Rxy(Rdistance >= distance_bin*(i-1) & Rdistance < distance_bin*i);
    Rmean(i) = mean(Rvalues);
    Rsem(i) = std(Rvalues)/sqrt(length(Rvalues));
end
plot(1:20,Rmean)
%errorbar(1:20,Rmean,Rsem)
axis([1 20 -0.5 1]);
hold off;

% =========== SubFunction to draw the cross correlation ===============
function drawfield(map,axis,cmap,maxrate)
maxrate = ceil(maxrate);
if maxrate < 1
    maxrate = 1;
end    
n = size(map,1);
plotmap = ones(n,n,3);
for jj = 1:n
   for ii = 1:n
      if isnan(map(jj,ii))
         plotmap(jj,ii,1) = 1;
         plotmap(jj,ii,2) = 1;
		 plotmap(jj,ii,3) = 1;
      else
         rgb = pixelcolour(map(jj,ii),maxrate,cmap);
         plotmap(jj,ii,1) = rgb(1);
         plotmap(jj,ii,2) = rgb(2);
		 plotmap(jj,ii,3) = rgb(3);
      end   
   end
end   
image(axis,axis,plotmap);
set(gca,'YDir','Normal');
% s = sprintf('%u Hz',maxrate);
% title(s);

function rgb = pixelcolour(map,maxrate,cmap)
cmap1 = ...
    [    0         0    0.5625; ...
         0         0    0.6875; ...
         0         0    0.8125; ...
         0         0    0.9375; ...
         0    0.0625    1.0000; ...
         0    0.1875    1.0000; ...
         0    0.3125    1.0000; ...
         0    0.4375    1.0000; ...
         0    0.5625    1.0000; ...
         0    0.6875    1.0000; ...
         0    0.8125    1.0000; ...
         0    0.9375    1.0000; ...
    0.0625    1.0000    1.0000; ...
    0.1875    1.0000    0.8750; ...
    0.3125    1.0000    0.7500; ...
    0.4375    1.0000    0.6250; ...
    0.5625    1.0000    0.5000; ...
    0.6875    1.0000    0.3750; ...
    0.8125    1.0000    0.2500; ...
    0.9375    1.0000    0.1250; ...
    1.0000    1.0000         0; ...
    1.0000    0.8750         0; ...
    1.0000    0.7500         0; ...
    1.0000    0.6250         0; ...
    1.0000    0.5000         0; ...
    1.0000    0.3750         0; ...
    1.0000    0.2500         0; ...
    1.0000    0.1250         0; ...
    1.0000         0         0; ...
    0.8750         0         0; ...
    0.7500         0         0; ...
    0.6250         0         0 ];

cmap2 = ...
   [0.0417         0         0; ...
    0.1250         0         0; ...
    0.2083         0         0; ...
    0.2917         0         0; ...
    0.3750         0         0; ...
    0.4583         0         0; ...
    0.5417         0         0; ...
    0.6250         0         0; ...
    0.7083         0         0; ...
    0.7917         0         0; ...
    0.8750         0         0; ...
    0.9583         0         0; ...
    1.0000    0.0417         0; ...
    1.0000    0.1250         0; ...
    1.0000    0.2083         0; ...
    1.0000    0.2917         0; ...
    1.0000    0.3750         0; ...
    1.0000    0.4583         0; ...
    1.0000    0.5417         0; ...
    1.0000    0.6250         0; ...
    1.0000    0.7083         0; ...
    1.0000    0.7917         0; ...
    1.0000    0.8750         0; ...
    1.0000    0.9583         0; ...
    1.0000    1.0000    0.0625; ...
    1.0000    1.0000    0.1875; ...
    1.0000    1.0000    0.3125; ...
    1.0000    1.0000    0.4375; ...
    1.0000    1.0000    0.5625; ...
    1.0000    1.0000    0.6875; ...
    1.0000    1.0000    0.8125; ...
    1.0000    1.0000    0.9375];
if strcmp(cmap,'jet')
   steps = (31*(map/maxrate))+1;
   steps = round(steps);
   if steps>32; steps = 32; end
   rgb = cmap1(steps,:);
else
   steps = (31*(map/maxrate))+1;
   steps = round(steps);
   if steps>32; steps = 32; end
   rgb = cmap2(steps,:);
end                        