function [pc, apcd, pcdi] =  ppc(phases)
%[pc, apcd, pcdi] =  ppc(phases)
%pc = pairwise phase consistency 
%apcd = average pairwise circular distance
%pcdi = pairwise circular distance index (i.e., normalized apcd).
%based on Vinck et al., NeuroImage 2010
%calls ReturnPairwise.c
%JRM 2/15/13

pp = ReturnPairwise(phases);%pairwise phases
ad = abs(circ_dist(pp(:,1), pp(:,2)));%absolute angular distances
apcd = mean(ad);
pcdi = (pi-2*apcd) / pi;
pc = mean(cos(ad));%pairwise phase consistency = mean cosine of angular distances
%FYI: pc is an unbiased estimator of mean resultant length ^ 2


end%end of function