function [A, S, pEta2] = one_way_rm_anova(data)
% function [A, S, pEta2] = one_way_rm_anova(data)
%
% PURPOSE
%   Perform a one-way within-group (repeated measures) ANOVA
%
% INPUT:
%   data = subj x factor level (e.g., condition)
%
% OUTPUT
%   A = main effect of factor
%   S = subject effect
%    * Both variables (A & S) have fields 'F', 'df', and 'p' *
%   pEta2 = partial eta squared
%
% JB Trimper
% 2/16
% Manns Lab


s = size(data,1); %number of subjects
a = size(data,2); %number of levels

sumXSubj = sum(data,1);%sum across subjects
sumXLevs = sum(data,2);%sum across factor levels
gSum = sum(data(:));%grand sum

aTerm = sum(sumXSubj .^ 2) / s; %A
tTerm = gSum^2 / (a*s); %T
sTerm = sum(sumXLevs .^ 2) / a; %S
yTerm = sum(data(:) .^ 2); %Y

ssA = aTerm - tTerm; 
ssS = sTerm - tTerm; 
ssAS = yTerm - aTerm - sTerm + tTerm; 
% ssT = yTerm - tTerm; 

dfA = a - 1; 
dfS = s - 1; 
dfAS = (a - 1) * (s - 1); %df Error
% dfT = numel(data) - 1; 

msA = ssA / dfA; 
msS = ssS / dfS; 
msAS = ssAS / dfAS; %MS Error

A.F = msA / msAS; 
A.df = [dfA dfAS]; 
A.p = fcdf(A.F, dfA, dfAS, 'upper'); 

S.F = msS / msAS; 
S.df = [dfS dfAS]; 
S.p = fcdf(S.F, dfS, dfAS, 'upper'); 

pEta2 = ssA / (ssA + ssAS);

end

