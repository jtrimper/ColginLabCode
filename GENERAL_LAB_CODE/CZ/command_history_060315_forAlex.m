code_Ratemap_Stack;
axis on;
repetitions=100; % number of shuffle times
cutoff = 1; % cutoff by peak rate (use cells with peak rate >= 1Hz)
nonzero = 0.5; % cutoff by firing rate (use cells with firing rate >= 0.5 Hz)
RateOverlap_B1_B2 = RM_RateOverlap_cz(PeakRate_B1,PeakRate_B2,repetitions,cutoff,nonzero);
RateOverlap_B1_B3 = RM_RateOverlap_cz(PeakRate_B1,PeakRate_B3,repetitions,cutoff,nonzero);
RateOverlap_B2_B3 = RM_RateOverlap_cz(PeakRate_B2,PeakRate_B3,repetitions,cutoff,nonzero);
[PFCorr_B1B2,stack1_active_B1B2,stack2_active_B1B2] = RM_SpatialCorr_cz(Stack_B1,Stack_B2,repetitions,cutoff,nonzero);
[PFCorr_B1B3,stack1_active_B1B3,stack2_active_B1B3] = RM_SpatialCorr_cz(Stack_B1,Stack_B3,repetitions,cutoff,nonzero);
[PFCorr_B2B3,stack1_active_B2B3,stack2_active_B2B3] = RM_SpatialCorr_cz(Stack_B2,Stack_B3,repetitions,cutoff,nonzero);
errorbar([RateOverlap_B1_B2.mean,RateOverlap_B1_B3.mean,RateOverlap_B2_B3.mean],[RateOverlap_B1_B2.sem,RateOverlap_B1_B3.sem,RateOverlap_B2_B3.sem],'*');
ylim([0 1]);
hold on;
plot([RateOverlap_B1_B2.shuffle_mean,RateOverlap_B1_B3.shuffle_mean,RateOverlap_B2_B3.shuffle_mean],'o');
figure;
errorbar([PFCorr_B1B2.mean,PFCorr_B1B3.mean,PFCorr_B2B3.mean],[PFCorr_B1B2.sem,PFCorr_B1B3.sem,PFCorr_B2B3.sem],'*');
ylim([0 1]);
axis square