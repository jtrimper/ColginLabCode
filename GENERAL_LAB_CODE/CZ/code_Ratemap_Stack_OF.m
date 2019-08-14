% ==========  cells stacks in dCA2 A-B-B-A  ==========
clear
TTlist='CellList.txt';
% TTlist is a txt file in each recording folder
% TT1_1.t
% TT1_2.t
% TT1_3.t
% TT1_4.t
% and so on ...
infile='InFile2.txt';
% TTList_dCA2_pyr.txt
% Begin 1
% Begin 2
% Begin 3
% Begin 4
% and so on ...

plot_scale=0;
% set subdir as your own Matlab remapping folder
subdir='C:\DATA\openfield';
subdir_ratemap=strcat(subdir,'\All OpenField Ratemaps');

Stack_B1=[];
Stack_B2=[];
% Stack_B3=[];
% Stack_A2=[];
PeakRate_B1=[];
PeakRate_B2=[];
% PeakRate_B3=[];
% PeakRate_A2=[];

savefile=strcat(subdir,'\mouse56');

% this is the root directory of your data
DATAdir='C:\DATA\Mouse 56';

%% Mouse30 :TT2
% 
areaname='CA1';
Mouse='Mouse56';
Session='begin1begin2';

i_Rat28_dCA2=0;

path=strcat(DATAdir,'\openfield');
session_sequence=[1,2];  % which Begin do you want to include?
rotate_para=0;  % if you don't need to rotate the ratemap, set 0
i_Rat28_dCA2=i_Rat28_dCA2+1;
path_LT_Rat28_dCA2{i_Rat28_dCA2}=path;
ndirs_Rat28_dCA2(i_Rat28_dCA2)=2;  % how many Begins totally?
assemble_note=strcat(areaname,'_',Mouse,'_',Session,'_Openfield'); % just add some notes as part of figure name
[ratemap0,ratemap0_mat,peakrate0]=ratemap_RM_group_area_cz(path,infile,TTlist,plot_scale,rotate_para,subdir_ratemap,assemble_note,session_sequence);
Stack_B1=cat(3,Stack_B1,ratemap0_mat{1});
Stack_B2=cat(3,Stack_B2,ratemap0_mat{2});
% Stack_B3=cat(3,Stack_B3,ratemap0_mat{3});
% Stack_A2=cat(3,Stack_A2,ratemap0_mat{4});
PeakRate_B1=[PeakRate_B1;peakrate0(1,:)'];
PeakRate_B2=[PeakRate_B2;peakrate0(2,:)'];
% PeakRate_B3=[PeakRate_B3;peakrate0(3,:)'];
% PeakRate_A2=[PeakRate_A2;peakrate0(4,:)'];

% keep doing this for all recording folders!

save(savefile);

