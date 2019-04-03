function [me, int] = mixed_anova(data)
% function [me, int] = mixed_anova(data);
%
% Function performs a mixed-effects m x n ANOVA on the inputted data and returns F and p values, along with
% degrees of freedom for the main effects and the interaction.
%
% INPUT:
%   data = #subjects x #withinGroupLevels x #betweenGroupLevels
%
% OUTPUT:
%     me = main effects structure, with subfields A & B, with subfields F, p, & df.
%            me.A = main effect for between-group factor
%            me.B = main effect for within-group factor
%     int = interaction structure, with subfields F, p, & df.
%
% JB Trimper
% 1/16
% Manns Lab




%% GET DATA SIZES FOR DF CALCULATION

a = size(data,3); %a is # levels of between group factor (i.e., groups)
b = size(data,2); %b is # # levels of within group factor (i.e., times, conditions)
s = size(data,1); %s is # of subj/grp



%% CALCULATE SUMS

xWiSums = squeeze(sum(data,2)); %AS: sum across within factor, for each subject, for each between factor
%                                 OP = #Subj x #BetweenLevels

grpSums = squeeze(sum(xWiSums)); %A: sum across within factor and subjects (group Sums)
%                                  OP = #Groups x 1

cellSums = squeeze(sum(data,1)); %AB: sum for each factorial cell (each combo of factor & level)
%                                  OP = #WithinLevels x #BetweenLevels

levSums = sum(cellSums,2); %B: sum across all subjects, across groups (between factor)
%                          OP = #WithinLevels x 1

grandSum = sum(data(:)); %T: grand average, across all subjects, levels, factors
%                          OP = 1x1



%% CALCULATE SUMS OF SQUARES

%define repeatedly encountered terms
cellTerm = sum(cellSums(:) .^ 2) / s;%AB
subjTerm = sum(xWiSums(:) .^ 2) / b; %AS
betTerm = sum(grpSums .^ 2) / (b*s); %A
wiTerm = sum(levSums .^ 2) / (a*s); %B
gSumTerm = grandSum^2 / (a*b*s); %T
allSqTerm = sum(data(:) .^ 2); %Y

%calculate sums of squares from terms
ssA =  betTerm - gSumTerm; %Between Groups
ssSA =  subjTerm - betTerm; %Error (Between)
ssB = wiTerm - gSumTerm; %Within
ssAB = cellTerm - betTerm - wiTerm + gSumTerm; %Interaction
ssBxSA = allSqTerm - cellTerm - subjTerm + betTerm; %Error (Interaction)
ssT = allSqTerm - gSumTerm; %Total




%% CALCULATE DEGREES OF FREEDOM

dfA = a-1;
dfSA = a*(s-1);
dfB = b-1;
dfAB = (a-1)*(b-1);
dfBxSA = a*(b-1)*(s-1);
dfT = a*b*s-1;

%and store appropriately in output structures
me.A.df = [dfA dfSA];
me.B.df = [dfB dfBxSA];
int.df = [dfAB dfBxSA];



%% CALCULATE MEAN SQUARES

msA = ssA / dfA;
msSA = ssSA / dfSA;
msB = ssB / dfB;
msAB = ssAB / dfAB;
msBxSA = ssBxSA / dfBxSA;



%% CALCULATE F RATIO

me.A.F = msA / msSA;
me.B.F = msB / msBxSA;
int.F = msAB / msBxSA;



%% GET P VALUES
me.A.p = fcdf(me.A.F, dfA, dfSA, 'upper');
me.B.p = fcdf(me.B.F, dfB, dfBxSA, 'upper');
int.p = fcdf(int.F, dfAB, dfBxSA, 'upper');


end%function

