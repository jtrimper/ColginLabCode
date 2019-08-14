function PVCorr = RM_PVCorr_cz(stack1_active,stack2_active,repetitions,cutoff,nonzero)

% compute the correlations between corresponding columns of stack1 and stack2
% this gives the correlations between corresponding spatial population vectors

% Compute PV correlations
% Modified from function 'remapV3_morph'

% Input:
%       stack1_active and stack2_active: nbin*nbin*ncell ratemap matrix from two sessions
%       (active: especially the peak rate of each cell in either session is larger
%       than cutoff (1Hz))
%       repetitions is the number of repetitions in the shuffle data
% Output: struct PVCorr
%       PVCorr.PVCorr_matrix: PVCorr matrix for nbin*nbin grid
%       PVCorr.mean: mean of PVCorr_matrix
%       PVCorr.sem: SEM of PVCorr_matrix
%       PVCorr.n: length of nonNaN PVCorr_matrix
%       PVCorr.shuffle_mean: mean of PVCorr from permutated data
%       PVCorr.shuffle_PVCorr: PVCorr from permutated data

nbin = size(stack1_active,1);
ncell=size(stack1_active,3);   % number of cells

% Parameters setting
% cutoff = 1; % cutoff by peak rate (peak rate >= 1Hz)
% nonzero = 0.3; % cutoff by firing rate (firing rate >= 0.2Hz)
% NaN firing rate in unvisited bins

% calculate Population vecter correlations
[PVCorr_mean, PVCorr_sem, PVCorr_n, PVCorr_matrix] = CalculatePVCorr(stack1_active,stack2_active,cutoff,nonzero);

% calculate PV correlations for shuffled data
shufflePVCorr=zeros(repetitions,1);
for i = 1:repetitions
   irand = randperm(ncell);
   stack2_shuffle = stack2_active(:,:,irand);
   shufflePVCorr(i) = CalculatePVCorr(stack1_active,stack2_shuffle,cutoff,nonzero);
end
shuffle_mean = mean(shufflePVCorr);

% Output PVCorr
PVCorr = struct('PVCorr_matrix',PVCorr_matrix,'mean',PVCorr_mean,'n',PVCorr_n,'sem',PVCorr_sem,'shuffle_mean',shuffle_mean,'shuffle_PVCorr',shufflePVCorr);


% =========== SubFunction to calculate PVCorr ===============
function [PVCorr_mean, PVCorr_sem, PVCorr_n, PVcorr] = CalculatePVCorr(X,Y,cutoff,nonzero)

% X=stack1, Y=stack2
nbin = size(X,1);
ncell=size(X,3);
PVcorr = zeros(nbin);

% remove the NaN matrix
sum_XY=X+Y;
X_nonnan=[];
Y_nonnan=[];
N=0;
for nc=1:ncell
    ind=find(~isnan(sum_XY(:,:,nc))==1);
    if ~isempty(ind) % both matrix are non-nan
        N=N+1;
        X_nonnan(:,:,N)=X(:,:,nc);
        Y_nonnan(:,:,N)=Y(:,:,nc);
    end
end

for i = 1:nbin
    for j = 1:nbin
        X0= reshape(X_nonnan(i,j,:),N,1);
        Y0= reshape(Y_nonnan(i,j,:),N,1);
        if N > 1
            index = find(~isnan(X0)& ~isnan(Y0)& (X0 > nonzero | Y0 > nonzero));
            if length(index)>1
                cor = corrcoef(X0(index), Y0(index));
                PVcorr(i,j)=cor(1,2);
            else
                PVcorr(i,j)=NaN;
            end
        else
            PVcorr(i,j) = 0;
        end
    end
end
PVcorr0 = reshape(PVcorr,nbin.^2,1);
PVCorr_mean = nanmean(PVcorr0);
PVCorr_n = sum(isnan(PVcorr0)==0);
if (PVCorr_n > 1)
    PVCorr_sem = nanstd(PVcorr0)/sqrt(PVCorr_n);
else
    PVCorr_sem = 0;
end