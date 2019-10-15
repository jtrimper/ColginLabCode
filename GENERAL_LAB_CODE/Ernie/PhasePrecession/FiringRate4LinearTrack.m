function FiringRate4LinearTrack(posfile,tfile,outdir) 

%% Set parameters
posbin_size = 1; %in cm
sampfreq = 30; %samples/sec
kernel = gausskernel(3,2);

%% Load files
[post,x,~] = LoadPos(posfile);
[spktp] = Readtfile(tfile);

%% Extract files information
trialInfo = strsplit(posfile,'\');
trialID = trialInfo{end-1};

spkInfo = strsplit(tfile,'\');
spkID = spkInfo{end}(1:end-2);

%% Main Body
% set position bin
[posbin_ind, posaxis] = binpos(x,posbin_size);
% select continuous forward and backward run
[for_ind, bak_ind] = splitRun(x);

spk2pos=match(spktp./10000,post);
spkcount = zeros(size(post));
for ii = 1:size(spk2pos,1)
    spkcount(spk2pos(ii)) = spkcount(spk2pos(ii))+1 ;
end
% Calculate the firing rate of forward run
spkcount_for = spkcount(for_ind);
x_for = posbin_ind(for_ind);
occ_for = zeros(1,max(posbin_ind));
spk_for = zeros(1,max(posbin_ind));
for ii = 1:size(x_for,2)
    
    occ_for(x_for(ii)) = occ_for(x_for(ii))+1;
    spk_for(x_for(ii)) = spk_for(x_for(ii))+spkcount_for(ii);

end
FR_for = spk_for./occ_for;
FR_for(isnan(FR_for)) = 0;
FR_for = FR_for*sampfreq;
sFR_for = conv(FR_for,kernel,'same');
% Calculate the firing rate of backward run
spkcount_bak = spkcount(bak_ind);
x_bak = posbin_ind(bak_ind);
occ_bak = zeros(1,max(posbin_ind));
spk_bak = zeros(1,max(posbin_ind));
for ii = 1:size(x_bak,2)
    
    occ_bak(x_bak(ii)) = occ_bak(x_bak(ii))+1;
    spk_bak(x_bak(ii)) = spk_bak(x_bak(ii))+spkcount_bak(ii);
    
end
FR_bak = spk_bak./occ_bak;
FR_bak(isnan(FR_bak)) = 0;
FR_bak = FR_bak*sampfreq;
sFR_bak = conv(FR_bak,kernel,'same');

%% Plot and save reuslts 
h = figure;
plot(posaxis,sFR_for); hold on
plot(posaxis,sFR_bak,'r'); hold off
set(h,'outerposition',[600 150 850 800])
axis square
title(['FiringRateOnLinearTrack Spike: ' spkID ' Trial: ' trialID])
filename = strcat(outdir,'\linearTrack_FR_',spkID,'_',trialID);
imageStore(h,'png',filename)

close(h)
end




