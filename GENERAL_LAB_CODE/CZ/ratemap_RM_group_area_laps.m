function [RateMap,RateMap_mat1,RateMap_mat2,RateMap_mat3,PeakRate,PeakRate_mat1,PeakRate_mat2,PeakRate_mat3,numLaps]=ratemap_RM_group_area_laps(path,infile,TTlist,plot_scale,rotate_para,Path_savefig,assemble_note,session_sequence)
% cd('C:\CZ\DATA\Rat28\2013-08-29-RM-ABBA');
% TTlist='TTList_dCA1_pyr.txt';
% plot_scale=0.8;

% scale=[0.27, 0.285]; % scalex, scaley, need to change for different recording room!!!!!!!!!
% radius = 50; % Side length in cm,  need to change for different boxes, or radius for linearized track !!!!!!!!!
% sLength = radius*(2*pi); % only need in for when linearizing circular track
% sLength = 100;
D=100;
bins = 125; % Number of bins, need to change for different experiments!!!!!!!!!
session_period = 10*60;% unit:s.  need to change for different experiments!!!!!!!!!



cd(path);
% [RateMap,timeMaps,PeakRate,mapAxis,sessions,F,pathCoord,timeStamps] ...
%     = equalPlot_RM_step1_rotate_cz_v2(infile,session_period,rotate_para,scale,sLength,bins,h);
[RateMap,timeMaps,PeakRate,mapAxis,sessions,F,pathCoord,timeStamps,spk_phase,phase,numLaps]= equalPlot_RM_step1_rotate_laps_v2(infile,session_period,rotate_para,bins,D);


n_cell=size(RateMap,2);
n_laps1=numLaps{1,1};
n_laps2=numLaps{1,2};
n_laps3=numLaps{1,3};
RateMap_mat1=cell(1,n_cell);
RateMap_mat2=cell(1,n_cell);
RateMap_mat3=cell(1,n_cell);

for nc=1:n_cell
    for nl=1:n_laps1
        ratemap_eachcell=RateMap{1,nc}(:,nl);
        RateMap_mat1{nc}(:,:,nl)=ratemap_eachcell;
        peak_eachcell=PeakRate{1,nc}(nl);
        PeakRate_mat1(nc,nl)=peak_eachcell;
    end
    for nl=1:n_laps2
        ratemap_eachcell=RateMap{2,nc}(:,nl);
        RateMap_mat2{nc}(:,:,nl)=ratemap_eachcell;
        peak_eachcell=PeakRate{2,nc}(nl);
        PeakRate_mat2(nc,nl)=peak_eachcell;
    end
    for nl=1:n_laps3
        ratemap_eachcell=RateMap{3,nc}(:,nl);
        RateMap_mat3{nc}(:,:,nl)=ratemap_eachcell;
        peak_eachcell=PeakRate{3,nc}(nl);
        PeakRate_mat3(nc,nl)=peak_eachcell;
    end
end


% equalPlot_RM_step2_cz(plot_scale,RateMap,timeMaps,PeakRate,mapAxis,sessions,F,pathCoord,timeStamps,sLength,bins); %plots and saves the ratemaps
% % equalPlot_RM_step2_linear(plot_scale,RateMap,timeMaps,PeakRate,mapAxis,sessions,F,pathCoord,timeStamps,sLength,bins,spk_phase,phase); %plots and saves the linear ratemaps
% AssembleEqual_s5_v2(TTlist,'placeFieldImages',plot_scale,Path_savefig,assemble_note,session_sequence);
% % AssembleEqual_s5_v2(TTlist,strcat('placeFieldImages',num2str(plot_scale)),Path_savefig,assemble_note);
% map = RateMap;
% close all
% end