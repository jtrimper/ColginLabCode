function [me, int] = fact_rm_anova(data)
% function [me, int] = fact_rm_anova(data)
%
% Function performs a factorial repeated measures m x n ANOVA on the inputted data and returns F and p values, along with 
% degrees of freedom for the main effects and the interaction. 
%
% INPUT: 
%   data = #subjects x #levelsOfFActor1 (e.g., subregion) x #levelsOfFactor2 (e.g., behavioral condition)
%
% OUTPUT: 
%     me = main effects structure, with subfields A & B, with subfields F, p, & df.
%            me.A = main effect for within-group factor 2 (e.g., behavioral condition)
%            me.B = main effect for within-group factor 1 (e.g., subregion)
%     int = interaction structure, with subfields F, p, & df. 
%
% J Trimper 1/16   



%% %TEST DATA - pulled from PPT 'FACTORIAL_WITHIN_SUBJECTS.ppt' by Andrew Ainsworth, downloaded and in folder (C:\Users\jtrimper\Documents\OTHER\STATS\Ainsworth_Slides)
% data(:,:,1) = [1 3 6; 1 4 8; 3 3 6; 5 5 7; 2 4 5]; 
% data(:,:,2) = [5 4 1; 8 8 4; 4 5 3; 3 2 0; 5 6 3]; 



%% GET DATA SIZES FOR DF CALCULATION

a = size(data,3); %a is # levels of within group factor 2 (i.e., subregion pairing)
b = size(data,2); %b is # levels of within group factor 1 (i.e., condn)
s = size(data,1); %s is # of subj



%% CALCULATE SUMS

%FOR EFFECT OF WITHIN GRP FACTOR 1/A (SUBREG COMBO)
sumXB = squeeze(sum(data,2)); %sum across within group factor 2 (i.e., condn)

sxbLevSums = sum(sumXB,1); %sum the sums across subreg pairing across subjects - returns one sum per condition

sxbSubjSums = sum(sumXB,2); %sum the sums across subreg pairings across levels (i.e., get a sum for each subject, across factors and levels)



%FOR EFFECT OF WITHIN GRP FACTOR 2/B (CONDN)
sumXA = sum(data,3); %sum across within group factor 1 (i.e., subreg combo)

sxaLevSums = sum(sumXA,1); %sum the sum across condns across subregion pairings

sxaSubjSums = sum(sumXA,2); %sum the sum across condns across subjects


%FOR INTXN
cellSums = sum(data,1); %sum within each cell (i.e., subreg-combo/condn combination)

subjSums = sum(sum(data,3),2); %sum levels and factors for each subj

%FOR ALL
gSum = sum(data(:)); %grand sum




%% CALCULATE SUMS OF SQUARES

%define repeatedly encountered terms
aTerm = sum(sxbLevSums .^ 2)/(b*s); %A
tTerm = gSum^2 / (a*b*s); %T
sTerm = sum(sxbSubjSums .^ 2) / (a*b); %S
asTerm = sum(sumXB(:) .^ 2) / b; %AS
bTerm = sum(sxaLevSums .^ 2) / (a*s); %B
bsTerm = sum(sumXA(:) .^ 2) / a; %BS
abTerm = sum(cellSums(:) .^ 2) / s; %AB
yTerm = sum(data(:) .^ 2); %Y


%calculate sums of squares from terms
ssA = aTerm - tTerm; 
ssS = sTerm - tTerm; 
ssAS = asTerm - aTerm - sTerm + tTerm; 
ssB = bTerm - tTerm; 
ssBS = bsTerm - bTerm - sTerm  + tTerm; %Subj at Each Level
ssAB = abTerm - aTerm - bTerm + tTerm; 
ssABS = yTerm - abTerm - asTerm - bsTerm + aTerm + bTerm + sTerm - tTerm; 
ssT = yTerm - tTerm; 





%% CALCULATE DEGREES OF FREEDOM

dfA = a - 1; 
dfB = b - 1; 
dfAB = (a-1)*(b-1);
dfS = s-1; 
dfAS = (a-1)*(s-1); 
dfBS = (b-1)*(s-1); 
dfABS = (a-1)*(b-1)*(s-1); 
dfT = a*b*s-1; 

%and store appropriately in output structures
me.A.df = [dfA dfAS]; %df for main effect of subreg combo (Fctr 1/A)
me.B.df = [dfB dfBS]; %df for main effect of condn (Fctr 2/B)
int.df = [dfAB dfABS]; %df for interaction



%% CALCULATE MEAN SQUARES

msA = ssA / dfA; 
msAS = ssAS / dfAS; 
msB = ssB / dfB; 
msBS = ssBS / dfBS; 
msAB = ssAB / dfAB; 
msABS = ssABS / dfABS; 
msS = ssS / dfS; 


%% CALCULATE F RATIO

me.A.F = msA / msAS; 
me.B.F = msB / msBS; 
int.F = msAB / msABS; 



%% GET P VALUES
 me.A.p = fcdf(me.A.F, dfA, dfAS, 'upper'); 
 me.B.p = fcdf(me.B.F, dfB, dfBS, 'upper'); 
 int.p = fcdf(int.F, dfAB, dfABS, 'upper'); 
 
 
end%function

