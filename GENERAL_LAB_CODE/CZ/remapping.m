% this code shows how to calculate the population vector correlation (PVC).
% the input variables 'stack1_active' and 'stack2_active' in RM_PVCorr_cz.m
% are the output of RM_SpatialCorr_cz.m
% input stack1 and stack2 are ratemap stacks of two different condition,
% e.g. stack1 is control ratemap stack of control, and stack2 is social
% ratemap stack. In each stack, cell1 ratemap in condition1 is shown in
% stack1(:,:,1), cell2 ratemap in condition1 is stack1(:,:,2), and so on.
% size(stack1,1) is the number of ybins
% size(stack1,2) is the number of xbins
% size(stack1,3) is the number of cells
% peak1 and peak2 are a N*1 arrays, N is the number of cells
% Note: the ratemaps in stack are already smoothed by using Guassian kernel 
% density estimator.



repetitions=100; % number of shuffle times
cutoff = 1; % cutoff by peak rate (use cells with peak rate >= 1Hz)
nonzero = 0.5; % cutoff by firing rate (use cells with firing rate >= 0.5 Hz)
RateOverlap = RM_RateOverlap_cz(peak1,peak2,repetitions,cutoff,nonzero);
[PFCorr,stack1_active,stack2_active] = RM_SpatialCorr_cz_v2(stack1,stack2,repetitions,cutoff,nonzero,RC);
PVCorr = RM_PVCorr_cz(stack1_active,stack2_active,repetitions,cutoff,nonzero);
PVCrossCorr = RM_PVCrossCorr_cz(stack1_active,stack2_active,cutoff,nonzero,1);

Stack = {Stack_B1,Stack_B2,Stack_B3};
RC = getactivebins(Stack,nonzero);