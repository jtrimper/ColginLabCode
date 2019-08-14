function [RateMap,RateMap_mat,PeakRate]=ratemap_RM_group_area_cz(path,infile,TTlist,plot_scale,rotate_para,Path_savefig,assemble_note,session_sequence)
% cd('C:\CZ\DATA\Rat28\2013-08-29-RM-ABBA');
% TTlist='TTList_dCA1_pyr.txt';
% plot_scale=0.8;

scale=[0.32 0.35]; % scalex, scaley, need to change for different recording room!!!!!!!!!
% radius = 50; % Side length in cm,  need to change for different boxes, or radius for linearized track !!!!!!!!!
% sLength = radius*(2*pi); % only need in for when linearizing circular track
sLength = 100;
bins = 25; % Number of bins, need to change for different experiments!!!!!!!!!
session_period = 20*60;% unit:s.  need to change for different experiments!!!!!!!!!
h=5;


cd(path);
[RateMap,timeMaps,PeakRate,mapAxis,sessions,F,pathCoord,timeStamps] ...
    = equalPlot_RM_step1_rotate_cz_v2(infile,session_period,rotate_para,scale,sLength,bins,h);
% [RateMap,timeMaps,PeakRate,mapAxis,sessions,F,pathCoord,timeStamps,spk_phase,phase] ...
%     = equalPlot_RM_step1_rotate_cz_linear(infile,session_period,rotate_para,scale,sLength,bins);

n_cell=size(RateMap,2);
n_session=size(RateMap,1);
RateMap_mat=cell(1,n_session);
for nc=1:n_cell
    for ns=1:n_session
        ratemap_eachcell=RateMap(ns,nc);
        RateMap_mat{ns}(:,:,nc)=ratemap_eachcell{1};
    end
end
equalPlot_RM_step2_cz(plot_scale,RateMap,timeMaps,PeakRate,mapAxis,sessions,F,pathCoord,timeStamps,sLength,bins); %plots and saves the ratemaps
% equalPlot_RM_step2_linear(plot_scale,RateMap,timeMaps,PeakRate,mapAxis,sessions,F,pathCoord,timeStamps,sLength,bins,spk_phase,phase); %plots and saves the linear ratemaps
AssembleEqual_s5_v2(TTlist,'placeFieldImages',plot_scale,Path_savefig,assemble_note,session_sequence);
% AssembleEqual_s5_v2(TTlist,strcat('placeFieldImages',num2str(plot_scale)),Path_savefig,assemble_note);
map = RateMap;
% close all