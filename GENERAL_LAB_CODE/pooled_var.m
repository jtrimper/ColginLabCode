function [pSem, pStd, pVar] = pooled_var(group)
% function [pSem, pStd, pVar] = pooled_var(group)
%
% PURPOSE:
%  Function to calculate the pooled variance/standard deviation for groups that may be different sizes.
%
% INPUT:
%  group = structure of length n with field 'data' for each group that contains a vector of data points
%
% OUTPUT:
%  pSem = pooled standard error
%  pStd = pooled standard deviation
%  pVar = pooled variance (pStd squared)
%
% JB Trimper
% 1/2018
% Colgin Lab

wSem = zeros(1,length(group));
wVar = zeros(1,length(group));
N = zeros(1,length(group));
for g = 1:length(group)
    groupAvg = nanmean(group(g).data);
    wVar(g) = nansum((group(g).data - groupAvg) .^ 2); %not averaged
    tmpSem = nan_semfunct(group(g).data);
    N(g) = sum(~isnan(group(g).data))-1;
    wSem(g) = tmpSem .* N(g);
end

pSem = sum(wSem) / sum(N);
pVar = sum(wVar) / sum(N);
pStd = sqrt(pVar);

end %fnctn