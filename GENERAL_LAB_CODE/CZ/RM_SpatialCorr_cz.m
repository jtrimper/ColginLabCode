function [PFCorr,stack1_active,stack2_active] = RM_SpatialCorr_cz(stack1,stack2,repetitions,cutoff,nonzero)
% spatial correlation 
% Modified from function 'remapV3_morph'

% Input:
%       stack1 and stack2: nbin*nbin*ncell ratemap matrix from two sessions
%       repetitions is the number of repetitions in the shuffle data
% Output: struct PFCorr
%       PFCorr.PFCorrActive: PFCorr vecter for active cells
%       PFCorr.mean: mean of PFCorrActive
%       PFCorr.sem: SEM of PFCorrActive
%       PFCorr.n: length of PFCorrActive
%       PFCorr.shuffle_mean: mean of PFCorr from permutated data
%       PFCorr.shuffle_PFCorr: PFCorr from permutated data

nbin=size(stack1,1);  % number of grids (bins)
ncell=size(stack1,3);   % number of cells
% disp(ncell);

% Parameters setting
% cutoff = 1; % cutoff by peak rate (peak rate >= 1Hz)
% nonzero = 0.2; % cutoff by firing rate (firing rate >= 0.2Hz)
% NaN firing rate in unvisited bins

% Calculate the mean rate for each cell in each session
MeanRates1 = zeros(1,ncell);
MeanRates2 = MeanRates1;
for Z=1:1:ncell
    MeanRates1(Z)=mean(mean(stack1(:,:,Z)));
    MeanRates2(Z)=mean(mean(stack2(:,:,Z)));
end

% calculate PF correlations
[PFCorr_mean, PFCorr_sem, PFCorr_n, PFCorr_active,stack1_active,stack2_active] = CalculatePFCorr(stack1,stack2,cutoff,nonzero);


% calculate PF correlations for shuffled data
ncell_active=size(stack1_active,3);   % number of cells
shufflePFCorr=zeros(repetitions,1);
for i = 1:repetitions
   irand = randperm(ncell_active);
   stack2_shuffle = stack2_active(:,:,irand);
   shufflePFCorr(i) = CalculatePFCorr(stack1_active,stack2_shuffle,cutoff,nonzero);
end
shuffle_mean = mean(shufflePFCorr);

% Output PFCorr
PFCorr = struct('PFCorrActive',PFCorr_active,'mean',PFCorr_mean,'n',PFCorr_n,'sem',PFCorr_sem,'shuffle_mean',shuffle_mean,'shuffle_PFCorr',shufflePFCorr);

% =========== SubFunction to calculate PFCorr ===============
function [PFCorr_mean, PFCorr_sem, PFCorr_n, PFcorr_active,XX,YY] = CalculatePFCorr(X,Y,cutoff,nonzero)

% X=stack1, Y=stack2
ncell=size(X,3);
PFcorr = zeros(1,ncell);
peak = zeros(1,ncell);
sum_XY=X+Y;
for i = 1:ncell
    % remove the NaN matrix
    ind=find(~isnan(sum_XY(:,:,i))==1);
    if isempty(ind) % at least one stack is NaN matrix
        PFcorr(i) = NaN;
    else
        peak(i) = max(max(max((X(:,:,i)))),max(max((Y(:,:,i)))));
        if peak(i) >= cutoff
            [r,c] = find(~isnan(X(:,:,i))& ~isnan(Y(:,:,i))& (X(:,:,i) > nonzero | Y(:,:,i) > nonzero));
            % NaN firing rate in unvisited bins
            x=diag(X(r,c,i),0);  % x=X(r,c,i); returns matrix
            y=diag(Y(r,c,i),0);
            spatial_corr = corrcoef(x,y);
            PFcorr(i)= spatial_corr(1,2);
        else
            PFcorr(i) = NaN;
        end
    end
end
active_index = isnan(PFcorr)==0; % peak rate >=cutoff
PFcorr_active = PFcorr(active_index);
PFCorr_mean=mean(PFcorr_active);
PFCorr_n=length(PFcorr_active);
if (PFCorr_n > 1)
    PFCorr_sem = std(PFcorr_active)/sqrt(PFCorr_n);
else
    PFCorr_sem = 0;
end

XX = X(:,:,active_index);
YY = Y(:,:,active_index);