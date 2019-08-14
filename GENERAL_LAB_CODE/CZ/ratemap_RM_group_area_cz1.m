function [RateMap,RateMap_mat,PeakRate]=ratemap_RM_group_area_cz(path,infile,TTlist,plot_scale,rotate_para,Path_savefig,assemble_note,session_sequence)
% cd('C:\CZ\DATA\Rat28\2013-08-29-RM-ABBA');
% TTlist='TTList_dCA1_pyr.txt';
% plot_scale=0.8;

scale=[0.27, 0.27]; % scalex, scaley, need to change for different recording room!!!!!!!!!
sLength = 100; % Side length in cm,  need to change for different boxes !!!!!!!!!
bins = 50; % Number of bins, need to change for different experiments!!!!!!!!!
session_period = 10*60;% unit:s.  need to change for different experiments!!!!!!!!!

cd(path);
[RateMap,timeMaps,PeakRate,mapAxis,sessions,F,pathCoord,timeStamps] ...
    = equalPlot_RM_step1_rotate_cz(infile,session_period,rotate_para,scale,sLength,bins);

n_cell=size(RateMap,2);
n_session=size(RateMap,1);
RateMap_mat=cell(1,n_session);
for nc=1:n_cell
    for ns=1:n_session
        ratemap_eachcell=RateMap(ns,nc);
        RateMap_mat{ns}(:,:,nc)=ratemap_eachcell{1};
    end
end
equalPlot_RM_step2_cz(plot_scale,RateMap,timeMaps,PeakRate,mapAxis,sessions,F,pathCoord,timeStamps,sLength,bins);
AssembleEqual_s5_v2(TTlist,'placeFieldImages',plot_scale,Path_savefig,assemble_note,session_sequence);
% AssembleEqual_s5_v2(TTlist,strcat('placeFieldImages',num2str(plot_scale)),Path_savefig,assemble_note);

% close all