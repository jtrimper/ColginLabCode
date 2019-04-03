function [F, p, dfBet, dfWi] = one_way_bg_anova(group)
% function [F, p, dfBet, dfWi] = one_way_bg_anova(group)
%
% One way between subjects ANOVA
%
%INPUT:
% group = data structure
%         group(g).data = vector of scores
%         structure allows for different n's
%
%OUTPUT
% F, p, df between, and df within
%
% JB Trimper
% 2/16
% Colgin Lab


a = length(group); % # of levels of the independent variable (# groups)
n = arrayfun(@(group) length(group.data), group); % # of observations per group
N = sum(n); % total # of observations

grpMeans = arrayfun(@(group) mean(group.data), group);
grndMean = mean(grpMeans); %is this the right way to calculate the grand mean or should it just be the mean of means

SSbg = sum (n .* (grpMeans - grndMean) .^ 2); 

for g = 1:a
    SSwg(g) = sum((group(g).data - grpMeans(g)) .^ 2);
end
SSwg = sum(SSwg);

dfBet = a - 1; 
dfWi = N - a; 

MSbg = SSbg / dfBet; 
MSwg = SSwg / dfWi; 

F = MSbg / MSwg; 
p = fcdf(F,dfBet, dfWi, 'upper'); 

end

