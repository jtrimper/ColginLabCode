function [stats,HSD] = rm_tukey(data)
% function [stats,HSD] = rm_tukey(data)
%
% PURPOSE: 
%   To run Tukey's HSD post-hoc test on the inputted repeated-measures data.
%
% INPUT:
%   data = subj x factor level (e.g., condition)
%
% OUTPUT: 
%   stats = #comparisons x 4 matrix where...
%           (:,1) = index for grp 1 in the comparison
%           (:,2) = index for grp 2 in the comparison
%           (:,3) = the difference in means between the groups
%           (:,4) = whether or not the difference passed the HSD threshold
%     HSD = the critical value of Q, or the HSD threshold, beyond which a 
%           difference in means is statistically significant
%
% JB Trimper
% 09/2018
% Colgin Lab
%
% *To the best of my knowledge, this is correct, but I have no way of verifying it
%  in a separate program. 


s = size(data,1); %number of subjects
a = size(data,2); %number of levels

sumXSubj = sum(data,1);%sum across subjects
sumXLevs = sum(data,2);%sum across factor levels
gSum = sum(data(:));%grand sum

aTerm = sum(sumXSubj .^ 2) / s; %A
tTerm = gSum^2 / (a*s); %T
sTerm = sum(sumXLevs .^ 2) / a; %S
yTerm = sum(data(:) .^ 2); %Y

ssAS = yTerm - aTerm - sTerm + tTerm; 
 
dfAS = (a - 1) * (s - 1); %df Error

msAS = ssAS / dfAS; %MS Error

qA = qdist(0.05,a,dfAS); %Q value, given sample size and alpha

SEM = sqrt(msAS/a); %Standard Error of the Mean

HSD = qA * SEM; %HSD

lvlMeans = mean(data,1); %Means for each level
lvlPairs = nchoosek(1:size(data,2),2); %Each combo of levels
numComps = size(lvlPairs,1); %Number of comparisons to be done

stats = zeros(numComps,4); 
for c = 1:numComps
    grp1 = lvlPairs(c,1); 
    grp2 = lvlPairs(c,2); 
   meanDif = abs(lvlMeans(grp1) - lvlMeans(grp2)); 
   if meanDif > HSD
       H = 1; 
   else
       H = 0; 
   end
   stats(c,:) = [grp1 grp2 meanDif H]; 
end


end %fnctn





