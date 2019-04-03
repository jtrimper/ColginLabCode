function cohD = calc_cohensD_indepGrps(group1Data,group2Data)
% function cohD = calc_cohens_d(group1Data,group2Data)
%
% FUNCTION:
%  To calculate Cohen's D for two independent groups. 
%  Variability estimate is the pooled standard deviation. 
%
% INPUT: 
%  group1Data = vector of samples for group 1
%  group2Data = vector of samples for group 2
%
% OUTPUT: 
%  cohD = Cohen's D
%
% JBT 11/2017
% Colgin Lab


SDpooled = sqrt((std(group1Data)^2 + std(group2Data)^2)/2);
cohD = abs(mean(group1Data) - mean(group2Data)) / SDpooled;

end %fnctn