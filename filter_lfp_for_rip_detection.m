function lfpStruct = filter_lfp_for_rip_detection(lfpStruct)
% function lfpStruct = filter_lfp_for_rip_detection(lfpStruct)
%
% PURPOSE:
%    Function filter LFP in three frequency ranges (ripple, delta, & theta)
%    because you need all three to do ripple detection.
%
% INPUT:
%    lfpStruct = lfp data structure outputted by 'read_in_lfp'
%
% OUTPUT:
%   lfpStruct = same input data structure with three subfields added:
%         1) lfpStruct.deltaFiltLfp = lfp filtered in delta range (2-4 Hz):
%         2) lfpStruct.thetaFiltLfp = lfp filtered in theta range (6-12 Hz):
%         3) lfpStruct.ripFiltLfp = lfp filtered in ripple range (150-300 Hz):
%
% JB Trimper
% 10/16
% Colgin Lab

fprintf('\nFiltering in delta range (2-4 Hz)...')
lfpStruct.deltaFiltLfp = filter_lfp(lfpStruct, 2, 5); %DELTA

fprintf('\nFiltering in theta range (6-12 Hz)...')
lfpStruct.thetaFiltLfp = filter_lfp(lfpStruct, 6, 10); %THETA

fprintf('\nFiltering in ripple range (150-300 Hz)...\n')
lfpStruct.ripFiltLfp = filter_lfp(lfpStruct, 150, 300); %RIPPLE
