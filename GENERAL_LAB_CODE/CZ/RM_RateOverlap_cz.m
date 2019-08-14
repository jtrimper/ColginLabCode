function RateOverlap = RM_RateOverlap_cz(column1,column2,repetitions,cutoff,nonzero) 

% Original function is 'Scramble_err'
% Input:
%       column1 and column2 are max rate of ratemaps in two sessions
%       repetitions is the number of repetitions in the shuffle data
% Output:struct RateOverlap
%       RateOverlap.RateRatio: ratio of the rate overlap between column1 and comlun2
%       RateOverlap.mean: mean of RateRatio
%       RateOverlap.sem: SEM of RateRatio
%       RateOverlap.n: length of RateRatio
%       RateOverlap.shuffle_mean: mean of RateRatio from permutated data
%       RateOverlap.shuffle_ratio: RateRatio from permutated data

% Parameters setting
% cutoff = 1; % cutoff by peak rate (peak rate >= 1Hz)
% nonzero = 0.2; % cutoff by firing rate (firing rate >= 0.2Hz)
% NaN firing rate in unvisited bins

% remove the NaN in the data
ind=find(~isnan(column1+column2)==1);
column1_nonnan=column1(ind);
column2_nonnan=column2(ind);

% calculate mean of the experimental data
[RateRatio_mean, RateRatio_sem, RateRatio_n, RateRatio] = CalculateRatio(column1_nonnan,column2_nonnan,cutoff,nonzero);


% calculate the mean of permutated data 
shuffleratio=zeros(repetitions,1);
for i = 1:repetitions
   irand = randperm(length(column2_nonnan));
   column2_shuffle = column2_nonnan(irand);
   shuffleratio(i) = CalculateRatio(column1_nonnan,column2_shuffle,cutoff,nonzero);
end
shuffle_mean = mean(shuffleratio);

% Output RateOverlap
RateOverlap = struct('RateRatio',RateRatio,'mean',RateRatio_mean,'n',RateRatio_n,'sem',RateRatio_sem,'shuffle_mean',shuffle_mean,'shuffle_ratio',shuffleratio);

% =========== SubFunction to calculate rate overlap ===============
function [ratio_mean, ratio_sem, ratio_n, ratio] = CalculateRatio(X,Y,cutoff,nonzero)

%eliminate rows without data
product = X .* Y;
iprod = find(product >= nonzero^2);  % rule out NaN
length(iprod);
X = X(iprod);
Y = Y(iprod);


max12 = max(X,Y);
index = find(max12 > cutoff);
length(index);
min12 = min(X,Y);
max12 = max12(index);
min12 = min12(index);

ratio = min12 ./ max12;

ratio_mean = mean(ratio);
ratio_n = length(ratio);

if (ratio_n > 1)
    ratio_sem = std(ratio)/sqrt(ratio_n);
else
    ratio_sem = 0;
end