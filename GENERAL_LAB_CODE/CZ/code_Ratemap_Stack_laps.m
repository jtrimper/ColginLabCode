% ==========  cells stacks in dCA2 A-B-B-A  ==========
clear
TTlist='test.txt';
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
subdir='C:\DATA\Ratemap stacks_laps';
subdir_ratemap=strcat(subdir,'\All Ratemaps_CA1_1.5_laps');

savefile=strcat(subdir,'\160211_Mouse65_laps.mat');

% this is the root directory of your data
DATAdir='C:\DATA\Mouse 65\';

%%
% 
areaname='CA1';
Mouse='Mouse65';
Session='Begin1Begin2Begin3';

i_Rat28_dCA2=0;

path=strcat(DATAdir,'\2016-02-11\');
session_sequence=[1,2,3];  % which Begin do you want to include?
rotate_para=0;  % if you don't need to rotate the ratemap, set 0
i_Rat28_dCA2=i_Rat28_dCA2+1;
path_LT_Rat28_dCA2{i_Rat28_dCA2}=path;
ndirs_Rat28_dCA2(i_Rat28_dCA2)=3;  % how many Begins totally?
assemble_note=strcat(areaname,'_',Mouse,'_',Session,'_20160211'); % just add some notes as part of figure name
[ratemap0,ratemap0_mat1,ratemap0_mat2,ratemap0_mat3,peakrate0,peakrate_mat1,peakrate_mat2,peakrate_mat3,numLaps]...
    =ratemap_RM_group_area_laps(path,infile,TTlist,plot_scale,rotate_para,subdir_ratemap,assemble_note,session_sequence);


% keep doing this for all recording folders!

save(savefile);

