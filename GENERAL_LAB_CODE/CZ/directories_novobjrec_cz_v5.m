% % B is the obj change
% % C is the obj+loc change
% % A' is the loc change
%
% v5: treat each object as an ellipse, and fix the radius from the animal's
% location to the edge of the ellipse

clear
code_160222_alldata_directories

% savefile='20160330_behavior_discrimination_index_v5(explore_3min_10cm_vel_0_100).mat';
savefile='20160330_behavior_discrimination_index_v5(explore_3min_15cm_vel_0_100).mat';

% setting
radius_objectcenter = 15; % cm, the distance from the animal to the ellipse edge
% 6cm is the diameter of the headstage
radius_con = 10; % cm, not using for behavindex_cz_v3_quadrant
starttime = 0;
endtime = 3;
starttime_con = 0;
endtime_con = 10;
root_dir = 'C:\Novel Object';
vel_limit = [0,100];

% radius of the object, use the ellipse to limit the object
% because all object was put vertically, the ellipse function should be:
% (x-x0)^2/r_short^2 + (y-y0)^2/r_long^2 = 1
r_s_A = 3/2;
r_l_A = 6.5/2;
r_s_B = 3/2;
r_l_B = 6.5/2;
r_s_C = 3/2;
r_l_C = 6.5/2;
radius_ellipse = radius_objectcenter-r_l_A; % cm, the distance from the animal to the ellipse edge
% for rat 13,17, 31, I don't know if the Object was bigger that Object A,
% so only use r_l_A instead of r_l_C

% the number of days when the rats were running in each condition
npath_F_Rat13=1;
npath_F_Rat17=1;
npath_F_Rat31=3;
npath_F_Rat44=5;
npath_F_Rat45=3;
npath_F_Rat47=3;
npath_F_Rat68=1;
npath_F_Rat79=3;
npath_F_Rat80=5;
npath_F_Rat97=3;

npath_NOL_Rat13=3;
npath_NOL_Rat17=2;
npath_NOL_Rat31=4;
npath_NOL_Rat44=4;
npath_NOL_Rat45=2;
npath_NOL_Rat47=4;
npath_NOL_Rat68=2;
npath_NOL_Rat79=6;
npath_NOL_Rat80=2;
npath_NOL_Rat97=2;

npath_NL_Rat13=[];
npath_NL_Rat17=[];
npath_NL_Rat31=5;
npath_NL_Rat44=2;
npath_NL_Rat45=6;
npath_NL_Rat47=6;
npath_NL_Rat68=6;
npath_NL_Rat79=4;
npath_NL_Rat80=4;
npath_NL_Rat97=4;

npath_NO_Rat13=2;
npath_NO_Rat17=3;
npath_NO_Rat31=2;
npath_NO_Rat44=6;
npath_NO_Rat45=4;
npath_NO_Rat47=2;
npath_NO_Rat68=4;
npath_NO_Rat79=2;
npath_NO_Rat80=6;
npath_NO_Rat97=6;

controlF = [];
controlO = [];
controlL = [];
controlOL = [];
conF_mean = []; conL_mean = []; conO_mean = []; conOL_mean = [];
index_F_b2_A2A1 = [];
index_O_b2_B_A1 = [];
index_L_b2_A22A1 = [];
index_OL_b2_C_A1 = [];
time_F_b2_A2A1 = [];
time_O_b2_B_A1 = [];
time_L_b2_A22A1 = [];
time_OL_b2_C_A1 = [];


index_F_b1_A2A1 = [];
time_F_b1_A2A1 = [];
index_O_b1_A2A1 = [];
time_O_b1_A2A1 = [];
index_L_b1_A2A1 = [];
time_L_b1_A2A1 = [];
index_OL_b1_A2A1 = [];
time_OL_b1_A2A1 = [];



%% Rat 13
scale_x = scale_Rat13_x;
scale_y = scale_Rat13_y;
controlF_temp = [];
controlO_temp = [];
controlL_temp = [];
controlOL_temp = [];

loc_F_A1 = Loc_Rat13_A1(npath_F_Rat13,:);
loc_F_A2 = Loc_Rat13_A2(npath_F_Rat13,:);
loc_NO_A1 = Loc_Rat13_A1(npath_NO_Rat13,:);
loc_NO_A2 = Loc_Rat13_A2(npath_NO_Rat13,:);
loc_NO_B = Loc_Rat13_B;
loc_NOL_A1 = Loc_Rat13_A1(npath_NOL_Rat13,:);
loc_NOL_A2 = Loc_Rat13_A2(npath_NOL_Rat13,:);
loc_NOL_C = Loc_Rat13_C;

%no objects
% cd(strcat(root_dir,'\Rat13\2012-01-30-SS\begin2\'))
% controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlL_temp = [controlL_temp;[nan,nan]];
% controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
%no objects
cd(strcat(root_dir,'\Rat13\2012-01-31-SS\begin1\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;[nan,nan]];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat13\2012-01-31-SS\begin2\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;[nan,nan]];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% cd(strcat(root_dir,'\Rat13\2012-01-31-SS\begin3\'))
% controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlL_temp = [controlL_temp;[nan,nan]];
% controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];

% F
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat13\2012-02-01-F\begin2\'))
[indexF_b2_A2A1_temp,time_F_b2_A2_temp,time_F_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat13\2012-02-03-NO+NL\begin1\'))
[indexF_b1_A2A1_temp,time_F_b1_A2_temp,time_F_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NOL
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat13\2012-02-03-NO+NL\begin2\'))
[indexOL_b2_C_A1_temp,time_OL_b2_C_temp,time_OL_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat13\2012-02-03-NO+NL\begin1\'))
[indexOL_b1_A2A1_temp,time_OL_b1_A2_temp,time_OL_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_A2(1),loc_NOL_A2(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NO
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat13\2012-02-02-NO\begin2\'))
[indexO_b2_B_A1_temp,time_O_b2_B_temp,time_O_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat13\2012-02-02-NO\begin1\'))
[indexO_b1_A2A1_temp,time_O_b1_A2_temp,time_O_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_A2(1),loc_NO_A2(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NL
indexL_b2_A22A1_temp = [nan,nan];
time_L_b2_A22_temp = nan; time_L_b2_A1_temp = nan;
indexL_b1_A2A1_temp = [nan,nan];
time_L_b1_A2_temp = nan; time_L_b1_A1_temp = nan;

conF_mean = [conF_mean;mean(controlF_temp,1)];
conO_mean = [conO_mean;mean(controlO_temp,1)];
conL_mean = [conL_mean;mean(controlL_temp,1)];
conOL_mean = [conOL_mean;mean(controlOL_temp,1)];
index_F_b2_A2A1 = [index_F_b2_A2A1;indexF_b2_A2A1_temp];
time_F_b2_A2A1 = [time_F_b2_A2A1;[time_F_b2_A2_temp,time_F_b2_A1_temp]];
index_O_b2_B_A1 = [index_O_b2_B_A1;indexO_b2_B_A1_temp];
time_O_b2_B_A1 = [time_O_b2_B_A1;[time_O_b2_B_temp,time_O_b2_A1_temp]];
index_L_b2_A22A1 = [index_L_b2_A22A1;indexL_b2_A22A1_temp];
time_L_b2_A22A1 = [time_L_b2_A22A1;[time_L_b2_A22_temp,time_L_b2_A1_temp]];
index_OL_b2_C_A1 = [index_OL_b2_C_A1;indexOL_b2_C_A1_temp];
time_OL_b2_C_A1 = [time_OL_b2_C_A1;[time_OL_b2_C_temp,time_OL_b2_A1_temp]];
index_F_b1_A2A1 = [index_F_b1_A2A1;indexF_b1_A2A1_temp];
time_F_b1_A2A1 = [time_F_b1_A2A1;[time_F_b1_A2_temp,time_F_b1_A1_temp]];
index_O_b1_A2A1 = [index_O_b1_A2A1;indexO_b1_A2A1_temp];
time_O_b1_A2A1 = [time_O_b1_A2A1;[time_O_b1_A2_temp,time_O_b1_A1_temp]];
index_L_b1_A2A1 = [index_L_b1_A2A1;indexL_b1_A2A1_temp];
time_L_b1_A2A1 = [time_L_b1_A2A1;[time_L_b1_A2_temp,time_L_b1_A1_temp]];
index_OL_b1_A2A1 = [index_OL_b1_A2A1;indexOL_b1_A2A1_temp];
time_OL_b1_A2A1 = [time_OL_b1_A2A1;[time_OL_b1_A2_temp,time_OL_b1_A1_temp]];


%% Rat 17
scale_x = scale_Rat17_x;
scale_y = scale_Rat17_y;
controlF_temp = [];
controlO_temp = [];
controlL_temp = [];
controlOL_temp = [];

loc_F_A1 = Loc_Rat17_A1(npath_F_Rat17,:);
loc_F_A2 = Loc_Rat17_A2(npath_F_Rat17,:);
loc_NO_A1 = Loc_Rat17_A1(npath_NO_Rat17,:);
loc_NO_A2 = Loc_Rat17_A2(npath_NO_Rat17,:);
loc_NO_B = Loc_Rat17_B;
loc_NOL_A1 = Loc_Rat17_A1(npath_NOL_Rat17,:);
loc_NOL_A2 = Loc_Rat17_A2(npath_NOL_Rat17,:);
loc_NOL_C = Loc_Rat17_C;

%no objects
% cd(strcat(root_dir,'\Rat17\2012-06-15-SS\begin2\'))
% controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlL_temp = [controlL_temp;[nan,nan]];
% controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
%no objects
cd(strcat(root_dir,'\Rat17\2012-06-16-SS\begin2\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;[nan,nan]];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% F
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat17\2012-06-17-F\begin2\'))
[indexF_b2_A2A1_temp,time_F_b2_A2_temp,time_F_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat17\2012-06-17-F\begin1\'))
[indexF_b1_A2A1_temp,time_F_b1_A2_temp,time_F_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NOL
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat17\2012-06-18-NO+NL\begin2\'))
[indexOL_b2_C_A1_temp,time_OL_b2_C_temp,time_OL_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat17\2012-06-18-NO+NL\begin1\'))
[indexOL_b1_A2A1_temp,time_OL_b1_A2_temp,time_OL_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_A2(1),loc_NOL_A2(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NO
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat17\2012-06-19-NO\begin2\'))
[indexO_b2_B_A1_temp,time_O_b2_B_temp,time_O_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat17\2012-06-19-NO\begin1\'))
[indexO_b1_A2A1_temp,time_O_b1_A2_temp,time_O_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_A2(1),loc_NO_A2(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NL
indexL_b2_A22A1_temp = [nan,nan];
time_L_b2_A22_temp = nan; time_L_b2_A1_temp = nan;
indexL_b1_A2A1_temp = [nan,nan];
time_L_b1_A2_temp = nan; time_L_b1_A1_temp = nan;

conF_mean = [conF_mean;mean(controlF_temp,1)];
conO_mean = [conO_mean;mean(controlO_temp,1)];
conL_mean = [conL_mean;mean(controlL_temp,1)];
conOL_mean = [conOL_mean;mean(controlOL_temp,1)];
index_F_b2_A2A1 = [index_F_b2_A2A1;indexF_b2_A2A1_temp];
time_F_b2_A2A1 = [time_F_b2_A2A1;[time_F_b2_A2_temp,time_F_b2_A1_temp]];
index_O_b2_B_A1 = [index_O_b2_B_A1;indexO_b2_B_A1_temp];
time_O_b2_B_A1 = [time_O_b2_B_A1;[time_O_b2_B_temp,time_O_b2_A1_temp]];
index_L_b2_A22A1 = [index_L_b2_A22A1;indexL_b2_A22A1_temp];
time_L_b2_A22A1 = [time_L_b2_A22A1;[time_L_b2_A22_temp,time_L_b2_A1_temp]];
index_OL_b2_C_A1 = [index_OL_b2_C_A1;indexOL_b2_C_A1_temp];
time_OL_b2_C_A1 = [time_OL_b2_C_A1;[time_OL_b2_C_temp,time_OL_b2_A1_temp]];
index_F_b1_A2A1 = [index_F_b1_A2A1;indexF_b1_A2A1_temp];
time_F_b1_A2A1 = [time_F_b1_A2A1;[time_F_b1_A2_temp,time_F_b1_A1_temp]];
index_O_b1_A2A1 = [index_O_b1_A2A1;indexO_b1_A2A1_temp];
time_O_b1_A2A1 = [time_O_b1_A2A1;[time_O_b1_A2_temp,time_O_b1_A1_temp]];
index_L_b1_A2A1 = [index_L_b1_A2A1;indexL_b1_A2A1_temp];
time_L_b1_A2A1 = [time_L_b1_A2A1;[time_L_b1_A2_temp,time_L_b1_A1_temp]];
index_OL_b1_A2A1 = [index_OL_b1_A2A1;indexOL_b1_A2A1_temp];
time_OL_b1_A2A1 = [time_OL_b1_A2A1;[time_OL_b1_A2_temp,time_OL_b1_A1_temp]];


%% Rat 31
scale_x = scale_Rat31_x;
scale_y = scale_Rat31_y;
controlF_temp = [];
controlO_temp = [];
controlL_temp = [];
controlOL_temp = [];

loc_F_A1 = Loc_Rat31_A1(npath_F_Rat31,:);
loc_F_A2 = Loc_Rat31_A2(npath_F_Rat31,:);
loc_NO_A1 = Loc_Rat31_A1(npath_NO_Rat31,:);
loc_NO_A2 = Loc_Rat31_A2(npath_NO_Rat31,:);
loc_NO_B = Loc_Rat31_B;
loc_NL_A1 = Loc_Rat31_A1(npath_NL_Rat31,:);
loc_NL_A2 = Loc_Rat31_A2(npath_NL_Rat31,:);
loc_NL_A22 = Loc_Rat31_A22;
loc_NOL_A1 = Loc_Rat31_A1(npath_NOL_Rat31,:);
loc_NOL_A2 = Loc_Rat31_A2(npath_NOL_Rat31,:);
loc_NOL_C = Loc_Rat31_C;

%no objects
cd(strcat(root_dir,'\Rat31\2013-12-31-SS\begin1\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat31\2013-12-31-SS\begin2\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat31\2013-12-31-SS\begin3\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
%no objects
cd(strcat(root_dir,'\Rat31\2014-01-01-SS\begin1\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat31\2014-01-01-SS\begin2\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat31\2014-01-01-SS\begin3\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% F
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat31\2014-01-07-F\begin2\'))
[indexF_b2_A2A1_temp,time_F_b2_A2_temp,time_F_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat31\2014-01-07-F\begin1\'))
[indexF_b1_A2A1_temp,time_F_b1_A2_temp,time_F_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NOL
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat31\2014-01-08-NO+NL\begin2\'))
[indexOL_b2_C_A1_temp,time_OL_b2_C_temp,time_OL_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat31\2014-01-08-NO+NL\begin1\'))
[indexOL_b1_A2A1_temp,time_OL_b1_A2_temp,time_OL_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_A2(1),loc_NOL_A2(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NO
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat31\2014-01-05-NO\begin2\'))
[indexO_b2_B_A1_temp,time_O_b2_B_temp,time_O_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat31\2014-01-05-NO\begin1\'))
[indexO_b1_A2A1_temp,time_O_b1_A2_temp,time_O_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_A2(1),loc_NO_A2(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NL
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat31\2014-01-09-NL\begin2\'))
[indexL_b2_A22A1_temp,time_L_b2_A22_temp,time_L_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat31\2014-01-09-NL\begin1\'))
[indexL_b1_A2A1_temp,time_L_b1_A2_temp,time_L_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A2(1),loc_NL_A2(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);

conF_mean = [conF_mean;mean(controlF_temp,1)];
conO_mean = [conO_mean;mean(controlO_temp,1)];
conL_mean = [conL_mean;mean(controlL_temp,1)];
conOL_mean = [conOL_mean;mean(controlOL_temp,1)];
index_F_b2_A2A1 = [index_F_b2_A2A1;indexF_b2_A2A1_temp];
time_F_b2_A2A1 = [time_F_b2_A2A1;[time_F_b2_A2_temp,time_F_b2_A1_temp]];
index_O_b2_B_A1 = [index_O_b2_B_A1;indexO_b2_B_A1_temp];
time_O_b2_B_A1 = [time_O_b2_B_A1;[time_O_b2_B_temp,time_O_b2_A1_temp]];
index_L_b2_A22A1 = [index_L_b2_A22A1;indexL_b2_A22A1_temp];
time_L_b2_A22A1 = [time_L_b2_A22A1;[time_L_b2_A22_temp,time_L_b2_A1_temp]];
index_OL_b2_C_A1 = [index_OL_b2_C_A1;indexOL_b2_C_A1_temp];
time_OL_b2_C_A1 = [time_OL_b2_C_A1;[time_OL_b2_C_temp,time_OL_b2_A1_temp]];
index_F_b1_A2A1 = [index_F_b1_A2A1;indexF_b1_A2A1_temp];
time_F_b1_A2A1 = [time_F_b1_A2A1;[time_F_b1_A2_temp,time_F_b1_A1_temp]];
index_O_b1_A2A1 = [index_O_b1_A2A1;indexO_b1_A2A1_temp];
time_O_b1_A2A1 = [time_O_b1_A2A1;[time_O_b1_A2_temp,time_O_b1_A1_temp]];
index_L_b1_A2A1 = [index_L_b1_A2A1;indexL_b1_A2A1_temp];
time_L_b1_A2A1 = [time_L_b1_A2A1;[time_L_b1_A2_temp,time_L_b1_A1_temp]];
index_OL_b1_A2A1 = [index_OL_b1_A2A1;indexOL_b1_A2A1_temp];
time_OL_b1_A2A1 = [time_OL_b1_A2A1;[time_OL_b1_A2_temp,time_OL_b1_A1_temp]];

%% Rat 44
scale_x = scale_Rat44_x;
scale_y = scale_Rat44_y;
controlF_temp = [];
controlO_temp = [];
controlL_temp = [];
controlOL_temp = [];

loc_F_A1 = Loc_Rat44_A1(npath_F_Rat44,:);
loc_F_A2 = Loc_Rat44_A2(npath_F_Rat44,:);
loc_NO_A1 = Loc_Rat44_A1(npath_NO_Rat44,:);
loc_NO_A2 = Loc_Rat44_A2(npath_NO_Rat44,:);
loc_NO_B = Loc_Rat44_B;
loc_NL_A1 = Loc_Rat44_A1(npath_NL_Rat44,:);
loc_NL_A2 = Loc_Rat44_A2(npath_NL_Rat44,:);
loc_NL_A22 = Loc_Rat44_A22;
loc_NOL_A1 = Loc_Rat44_A1(npath_NOL_Rat44,:);
loc_NOL_A2 = Loc_Rat44_A2(npath_NOL_Rat44,:);
loc_NOL_C = Loc_Rat44_C;

%no objects
cd(strcat(root_dir,'\Rat44\2014-05-05-SS\begin1\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat44\2014-05-05-SS\begin2\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat44\2014-05-05-SS\begin3\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
%no objects
cd(strcat(root_dir,'\Rat44\2014-05-06-SS\begin1\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat44\2014-05-06-SS\begin2\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat44\2014-05-06-SS\begin3\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% F
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat44\2014-05-09-F\begin2\'))
[indexF_b2_A2A1_temp,time_F_b2_A2_temp,time_F_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat44\2014-05-09-F\begin1\'))
[indexF_b1_A2A1_temp,time_F_b1_A2_temp,time_F_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NOL
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat44\2014-05-10-NO+NL\begin2\'))
[indexOL_b2_C_A1_temp,time_OL_b2_C_temp,time_OL_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat44\2014-05-10-NO+NL\begin1\'))
[indexOL_b1_A2A1_temp,time_OL_b1_A2_temp,time_OL_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_A2(1),loc_NOL_A2(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NO
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat44\2014-05-12-NO\begin2\'))
[indexO_b2_B_A1_temp,time_O_b2_B_temp,time_O_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat44\2014-05-12-NO\begin1\'))
[indexO_b1_A2A1_temp,time_O_b1_A2_temp,time_O_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_A2(1),loc_NO_A2(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NL
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat44\2014-05-08-NL\begin2\'))
[indexL_b2_A22A1_temp,time_L_b2_A22_temp,time_L_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat44\2014-05-08-NL\begin1\'))
[indexL_b1_A2A1_temp,time_L_b1_A2_temp,time_L_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A2(1),loc_NL_A2(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);

conF_mean = [conF_mean;mean(controlF_temp,1)];
conO_mean = [conO_mean;mean(controlO_temp,1)];
conL_mean = [conL_mean;mean(controlL_temp,1)];
conOL_mean = [conOL_mean;mean(controlOL_temp,1)];
index_F_b2_A2A1 = [index_F_b2_A2A1;indexF_b2_A2A1_temp];
time_F_b2_A2A1 = [time_F_b2_A2A1;[time_F_b2_A2_temp,time_F_b2_A1_temp]];
index_O_b2_B_A1 = [index_O_b2_B_A1;indexO_b2_B_A1_temp];
time_O_b2_B_A1 = [time_O_b2_B_A1;[time_O_b2_B_temp,time_O_b2_A1_temp]];
index_L_b2_A22A1 = [index_L_b2_A22A1;indexL_b2_A22A1_temp];
time_L_b2_A22A1 = [time_L_b2_A22A1;[time_L_b2_A22_temp,time_L_b2_A1_temp]];
index_OL_b2_C_A1 = [index_OL_b2_C_A1;indexOL_b2_C_A1_temp];
time_OL_b2_C_A1 = [time_OL_b2_C_A1;[time_OL_b2_C_temp,time_OL_b2_A1_temp]];
index_F_b1_A2A1 = [index_F_b1_A2A1;indexF_b1_A2A1_temp];
time_F_b1_A2A1 = [time_F_b1_A2A1;[time_F_b1_A2_temp,time_F_b1_A1_temp]];
index_O_b1_A2A1 = [index_O_b1_A2A1;indexO_b1_A2A1_temp];
time_O_b1_A2A1 = [time_O_b1_A2A1;[time_O_b1_A2_temp,time_O_b1_A1_temp]];
index_L_b1_A2A1 = [index_L_b1_A2A1;indexL_b1_A2A1_temp];
time_L_b1_A2A1 = [time_L_b1_A2A1;[time_L_b1_A2_temp,time_L_b1_A1_temp]];
index_OL_b1_A2A1 = [index_OL_b1_A2A1;indexOL_b1_A2A1_temp];
time_OL_b1_A2A1 = [time_OL_b1_A2A1;[time_OL_b1_A2_temp,time_OL_b1_A1_temp]];

%% Rat 45
scale_x = scale_Rat45_x;
scale_y = scale_Rat45_y;
controlF_temp = [];
controlO_temp = [];
controlL_temp = [];
controlOL_temp = [];

loc_F_A1 = Loc_Rat45_A1(npath_F_Rat45,:);
loc_F_A2 = Loc_Rat45_A2(npath_F_Rat45,:);
loc_NO_A1 = Loc_Rat45_A1(npath_NO_Rat45,:);
loc_NO_A2 = Loc_Rat45_A2(npath_NO_Rat45,:);
loc_NO_B = Loc_Rat45_B;
loc_NL_A1 = Loc_Rat45_A1(npath_NL_Rat45,:);
loc_NL_A2 = Loc_Rat45_A2(npath_NL_Rat45,:);
loc_NL_A22 = Loc_Rat45_A22;
loc_NOL_A1 = Loc_Rat45_A1(npath_NOL_Rat45,:);
loc_NOL_A2 = Loc_Rat45_A2(npath_NOL_Rat45,:);
loc_NOL_C = Loc_Rat45_C;

%no objects
cd(strcat(root_dir,'\Rat45\2014-05-21-SS\begin1\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat45\2014-05-21-SS\begin2\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat45\2014-05-21-SS\begin3\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% %no objects
% cd(strcat(root_dir,'\Rat45\2014-05-22-SS\begin2\'))
% controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% F
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat45\2014-05-25-F\begin2\'))
[indexF_b2_A2A1_temp,time_F_b2_A2_temp,time_F_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat45\2014-05-25-F\begin1\'))
[indexF_b1_A2A1_temp,time_F_b1_A2_temp,time_F_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NOL
radius = [r_s_C,r_l_C;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat45\2014-05-24-NO+NL\begin2\'))
[indexOL_b2_C_A1_temp,time_OL_b2_C_temp,time_OL_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat45\2014-05-24-NO+NL\begin1\'))
[indexOL_b1_A2A1_temp,time_OL_b1_A2_temp,time_OL_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_A2(1),loc_NOL_A2(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NO
radius = [r_s_B,r_l_B;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat45\2014-05-26-NO\begin2\'))
[indexO_b2_B_A1_temp,time_O_b2_B_temp,time_O_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat45\2014-05-26-NO\begin1\'))
[indexO_b1_A2A1_temp,time_O_b1_A2_temp,time_O_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_A2(1),loc_NO_A2(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NL
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat45\2014-05-28-NL\begin2\'))
[indexL_b2_A22A1_temp,time_L_b2_A22_temp,time_L_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat45\2014-05-28-NL\begin1\'))
[indexL_b1_A2A1_temp,time_L_b1_A2_temp,time_L_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A2(1),loc_NL_A2(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);

conF_mean = [conF_mean;mean(controlF_temp,1)];
conO_mean = [conO_mean;mean(controlO_temp,1)];
conL_mean = [conL_mean;mean(controlL_temp,1)];
conOL_mean = [conOL_mean;mean(controlOL_temp,1)];
index_F_b2_A2A1 = [index_F_b2_A2A1;indexF_b2_A2A1_temp];
time_F_b2_A2A1 = [time_F_b2_A2A1;[time_F_b2_A2_temp,time_F_b2_A1_temp]];
index_O_b2_B_A1 = [index_O_b2_B_A1;indexO_b2_B_A1_temp];
time_O_b2_B_A1 = [time_O_b2_B_A1;[time_O_b2_B_temp,time_O_b2_A1_temp]];
index_L_b2_A22A1 = [index_L_b2_A22A1;indexL_b2_A22A1_temp];
time_L_b2_A22A1 = [time_L_b2_A22A1;[time_L_b2_A22_temp,time_L_b2_A1_temp]];
index_OL_b2_C_A1 = [index_OL_b2_C_A1;indexOL_b2_C_A1_temp];
time_OL_b2_C_A1 = [time_OL_b2_C_A1;[time_OL_b2_C_temp,time_OL_b2_A1_temp]];
index_F_b1_A2A1 = [index_F_b1_A2A1;indexF_b1_A2A1_temp];
time_F_b1_A2A1 = [time_F_b1_A2A1;[time_F_b1_A2_temp,time_F_b1_A1_temp]];
index_O_b1_A2A1 = [index_O_b1_A2A1;indexO_b1_A2A1_temp];
time_O_b1_A2A1 = [time_O_b1_A2A1;[time_O_b1_A2_temp,time_O_b1_A1_temp]];
index_L_b1_A2A1 = [index_L_b1_A2A1;indexL_b1_A2A1_temp];
time_L_b1_A2A1 = [time_L_b1_A2A1;[time_L_b1_A2_temp,time_L_b1_A1_temp]];
index_OL_b1_A2A1 = [index_OL_b1_A2A1;indexOL_b1_A2A1_temp];
time_OL_b1_A2A1 = [time_OL_b1_A2A1;[time_OL_b1_A2_temp,time_OL_b1_A1_temp]];


%% Rat 47
scale_x = scale_Rat47_x;
scale_y = scale_Rat47_y;
controlF_temp = [];
controlO_temp = [];
controlL_temp = [];
controlOL_temp = [];

loc_F_A1 = Loc_Rat47_A1(npath_F_Rat47,:);
loc_F_A2 = Loc_Rat47_A2(npath_F_Rat47,:);
loc_NO_A1 = Loc_Rat47_A1(npath_NO_Rat47,:);
loc_NO_A2 = Loc_Rat47_A2(npath_NO_Rat47,:);
loc_NO_B = Loc_Rat47_B;
loc_NL_A1 = Loc_Rat47_A1(npath_NL_Rat47,:);
loc_NL_A2 = Loc_Rat47_A2(npath_NL_Rat47,:);
loc_NL_A22 = Loc_Rat47_A22;
loc_NOL_A1 = Loc_Rat47_A1(npath_NOL_Rat47,:);
loc_NOL_A2 = Loc_Rat47_A2(npath_NOL_Rat47,:);
loc_NOL_C = Loc_Rat47_C;

%no objects
cd(strcat(root_dir,'\Rat47\2014-09-22-SS\begin1\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat47\2014-09-22-SS\begin2\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat47\2014-09-22-SS\begin3\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
%no objects
cd(strcat(root_dir,'\Rat47\2014-09-23-SS\begin1\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat47\2014-09-23-SS\begin2\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat47\2014-09-23-SS\begin3\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% F
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat47\2014-09-26-F\begin2\'))
[indexF_b2_A2A1_temp,time_F_b2_A2_temp,time_F_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat47\2014-09-26-F\begin1\'))
[indexF_b1_A2A1_temp,time_F_b1_A2_temp,time_F_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NOL
radius = [r_s_C,r_l_C;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat47\2014-09-27-NO+NL\begin2\'))
[indexOL_b2_C_A1_temp,time_OL_b2_C_temp,time_OL_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat47\2014-09-27-NO+NL\begin1\'))
[indexOL_b1_A2A1_temp,time_OL_b1_A2_temp,time_OL_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_A2(1),loc_NOL_A2(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NO
radius = [r_s_B,r_l_B;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat47\2014-09-25-NO\begin2\'))
[indexO_b2_B_A1_temp,time_O_b2_B_temp,time_O_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat47\2014-09-25-NO\begin1\'))
[indexO_b1_A2A1_temp,time_O_b1_A2_temp,time_O_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_A2(1),loc_NO_A2(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NL
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat47\2014-09-29-NL\begin2\'))
[indexL_b2_A22A1_temp,time_L_b2_A22_temp,time_L_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat47\2014-09-29-NL\begin1\'))
[indexL_b1_A2A1_temp,time_L_b1_A2_temp,time_L_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A2(1),loc_NL_A2(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);

conF_mean = [conF_mean;mean(controlF_temp,1)];
conO_mean = [conO_mean;mean(controlO_temp,1)];
conL_mean = [conL_mean;mean(controlL_temp,1)];
conOL_mean = [conOL_mean;mean(controlOL_temp,1)];
index_F_b2_A2A1 = [index_F_b2_A2A1;indexF_b2_A2A1_temp];
time_F_b2_A2A1 = [time_F_b2_A2A1;[time_F_b2_A2_temp,time_F_b2_A1_temp]];
index_O_b2_B_A1 = [index_O_b2_B_A1;indexO_b2_B_A1_temp];
time_O_b2_B_A1 = [time_O_b2_B_A1;[time_O_b2_B_temp,time_O_b2_A1_temp]];
index_L_b2_A22A1 = [index_L_b2_A22A1;indexL_b2_A22A1_temp];
time_L_b2_A22A1 = [time_L_b2_A22A1;[time_L_b2_A22_temp,time_L_b2_A1_temp]];
index_OL_b2_C_A1 = [index_OL_b2_C_A1;indexOL_b2_C_A1_temp];
time_OL_b2_C_A1 = [time_OL_b2_C_A1;[time_OL_b2_C_temp,time_OL_b2_A1_temp]];
index_F_b1_A2A1 = [index_F_b1_A2A1;indexF_b1_A2A1_temp];
time_F_b1_A2A1 = [time_F_b1_A2A1;[time_F_b1_A2_temp,time_F_b1_A1_temp]];
index_O_b1_A2A1 = [index_O_b1_A2A1;indexO_b1_A2A1_temp];
time_O_b1_A2A1 = [time_O_b1_A2A1;[time_O_b1_A2_temp,time_O_b1_A1_temp]];
index_L_b1_A2A1 = [index_L_b1_A2A1;indexL_b1_A2A1_temp];
time_L_b1_A2A1 = [time_L_b1_A2A1;[time_L_b1_A2_temp,time_L_b1_A1_temp]];
index_OL_b1_A2A1 = [index_OL_b1_A2A1;indexOL_b1_A2A1_temp];
time_OL_b1_A2A1 = [time_OL_b1_A2A1;[time_OL_b1_A2_temp,time_OL_b1_A1_temp]];


%% Rat 68
scale_x = scale_Rat68_x;
scale_y = scale_Rat68_y;
controlF_temp = [];
controlO_temp = [];
controlL_temp = [];
controlOL_temp = [];

loc_F_A1 = Loc_Rat68_A1(npath_F_Rat68,:);
loc_F_A2 = Loc_Rat68_A2(npath_F_Rat68,:);
loc_NO_A1 = Loc_Rat68_A1(npath_NO_Rat68,:);
loc_NO_A2 = Loc_Rat68_A2(npath_NO_Rat68,:);
loc_NO_B = Loc_Rat68_B;
loc_NL_A1 = Loc_Rat68_A1(npath_NL_Rat68,:);
loc_NL_A2 = Loc_Rat68_A2(npath_NL_Rat68,:);
loc_NL_A22 = Loc_Rat68_A22;
loc_NOL_A1 = Loc_Rat68_A1(npath_NOL_Rat68,:);
loc_NOL_A2 = Loc_Rat68_A2(npath_NOL_Rat68,:);
loc_NOL_C = Loc_Rat68_C;

%no objects
% cd(strcat(root_dir,'\Rat68\2015-03-17-SS\begin1\'))
% controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat68\2015-03-17-SS\begin2\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% cd(strcat(root_dir,'\Rat68\2015-03-17-SS\begin3\'))
% controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% F
% cd(strcat(root_dir,'\Rat68\2015-03-21-F\begin2\'))
% [indexF_b2_A2A1_temp,time_F_b2_A2_temp,time_F_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% cd(strcat(root_dir,'\Rat68\2015-03-21-F\begin1\'))
% [indexF_b1_A2A1_temp,time_F_b1_A2_temp,time_F_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat68\2015-03-19-F\begin2\'))
[indexF_b2_A2A1_temp,time_F_b2_A2_temp,time_F_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat68\2015-03-19-F\begin1\'))
[indexF_b1_A2A1_temp,time_F_b1_A2_temp,time_F_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NOL
radius = [r_s_C,r_l_C;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat68\2015-03-20-NO+NL\begin2\'))
[indexOL_b2_C_A1_temp,time_OL_b2_C_temp,time_OL_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat68\2015-03-20-NO+NL\begin1\'))
[indexOL_b1_A2A1_temp,time_OL_b1_A2_temp,time_OL_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_A2(1),loc_NOL_A2(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NO
radius = [r_s_B,r_l_B;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat68\2015-03-22-NO\begin2\'))
[indexO_b2_B_A1_temp,time_O_b2_B_temp,time_O_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat68\2015-03-22-NO\begin1\'))
[indexO_b1_A2A1_temp,time_O_b1_A2_temp,time_O_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_A2(1),loc_NO_A2(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NL
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat68\2015-03-24-NL\begin2\'))
[indexL_b2_A22A1_temp,time_L_b2_A22_temp,time_L_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat68\2015-03-24-NL\begin1\'))
[indexL_b1_A2A1_temp,time_L_b1_A2_temp,time_L_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A2(1),loc_NL_A2(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);

conF_mean = [conF_mean;mean(controlF_temp,1)];
conO_mean = [conO_mean;mean(controlO_temp,1)];
conL_mean = [conL_mean;mean(controlL_temp,1)];
conOL_mean = [conOL_mean;mean(controlOL_temp,1)];
index_F_b2_A2A1 = [index_F_b2_A2A1;indexF_b2_A2A1_temp];
time_F_b2_A2A1 = [time_F_b2_A2A1;[time_F_b2_A2_temp,time_F_b2_A1_temp]];
index_O_b2_B_A1 = [index_O_b2_B_A1;indexO_b2_B_A1_temp];
time_O_b2_B_A1 = [time_O_b2_B_A1;[time_O_b2_B_temp,time_O_b2_A1_temp]];
index_L_b2_A22A1 = [index_L_b2_A22A1;indexL_b2_A22A1_temp];
time_L_b2_A22A1 = [time_L_b2_A22A1;[time_L_b2_A22_temp,time_L_b2_A1_temp]];
index_OL_b2_C_A1 = [index_OL_b2_C_A1;indexOL_b2_C_A1_temp];
time_OL_b2_C_A1 = [time_OL_b2_C_A1;[time_OL_b2_C_temp,time_OL_b2_A1_temp]];
index_F_b1_A2A1 = [index_F_b1_A2A1;indexF_b1_A2A1_temp];
time_F_b1_A2A1 = [time_F_b1_A2A1;[time_F_b1_A2_temp,time_F_b1_A1_temp]];
index_O_b1_A2A1 = [index_O_b1_A2A1;indexO_b1_A2A1_temp];
time_O_b1_A2A1 = [time_O_b1_A2A1;[time_O_b1_A2_temp,time_O_b1_A1_temp]];
index_L_b1_A2A1 = [index_L_b1_A2A1;indexL_b1_A2A1_temp];
time_L_b1_A2A1 = [time_L_b1_A2A1;[time_L_b1_A2_temp,time_L_b1_A1_temp]];
index_OL_b1_A2A1 = [index_OL_b1_A2A1;indexOL_b1_A2A1_temp];
time_OL_b1_A2A1 = [time_OL_b1_A2A1;[time_OL_b1_A2_temp,time_OL_b1_A1_temp]];


%% Rat 79
scale_x = scale_Rat79_x;
scale_y = scale_Rat79_y;
controlF_temp = [];
controlO_temp = [];
controlL_temp = [];
controlOL_temp = [];

loc_F_A1 = Loc_Rat79_A1(npath_F_Rat79,:);
loc_F_A2 = Loc_Rat79_A2(npath_F_Rat79,:);
loc_NO_A1 = Loc_Rat79_A1(npath_NO_Rat79,:);
loc_NO_A2 = Loc_Rat79_A2(npath_NO_Rat79,:);
loc_NO_B = Loc_Rat79_B;
loc_NL_A1 = Loc_Rat79_A1(npath_NL_Rat79,:);
loc_NL_A2 = Loc_Rat79_A2(npath_NL_Rat79,:);
loc_NL_A22 = Loc_Rat79_A22;
loc_NOL_A1 = Loc_Rat79_A1(npath_NOL_Rat79,:);
loc_NOL_A2 = Loc_Rat79_A2(npath_NOL_Rat79,:);
loc_NOL_C = Loc_Rat79_C;

%no objects
cd(strcat(root_dir,'\Rat79\2015-09-14-SS\begin1\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat79\2015-09-14-SS\begin2\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat79\2015-09-14-SS\begin3\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
%no objects
cd(strcat(root_dir,'\Rat79\2015-09-15-SS\begin1\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat79\2015-09-15-SS\begin2\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat79\2015-09-15-SS\begin3\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% F
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat79\2015-09-19-F\begin2\'))
[indexF_b2_A2A1_temp,time_F_b2_A2_temp,time_F_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat79\2015-09-19-F\begin1\'))
[indexF_b1_A2A1_temp,time_F_b1_A2_temp,time_F_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NOL
radius = [r_s_C,r_l_C;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat79\2015-09-22-NO+NL\begin2\'))
[indexOL_b2_C_A1_temp,time_OL_b2_C_temp,time_OL_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat79\2015-09-22-NO+NL\begin1\'))
[indexOL_b1_A2A1_temp,time_OL_b1_A2_temp,time_OL_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_A2(1),loc_NOL_A2(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NO
radius = [r_s_B,r_l_B;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat79\2015-09-18-NO\begin2\'))
[indexO_b2_B_A1_temp,time_O_b2_B_temp,time_O_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat79\2015-09-18-NO\begin1\'))
[indexO_b1_A2A1_temp,time_O_b1_A2_temp,time_O_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_A2(1),loc_NO_A2(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NL
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat79\2015-09-20-NL\begin2\'))
[indexL_b2_A22A1_temp,time_L_b2_A22_temp,time_L_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat79\2015-09-20-NL\begin1\'))
[indexL_b1_A2A1_temp,time_L_b1_A2_temp,time_L_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A2(1),loc_NL_A2(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);

conF_mean = [conF_mean;mean(controlF_temp,1)];
conO_mean = [conO_mean;mean(controlO_temp,1)];
conL_mean = [conL_mean;mean(controlL_temp,1)];
conOL_mean = [conOL_mean;mean(controlOL_temp,1)];
index_F_b2_A2A1 = [index_F_b2_A2A1;indexF_b2_A2A1_temp];
time_F_b2_A2A1 = [time_F_b2_A2A1;[time_F_b2_A2_temp,time_F_b2_A1_temp]];
index_O_b2_B_A1 = [index_O_b2_B_A1;indexO_b2_B_A1_temp];
time_O_b2_B_A1 = [time_O_b2_B_A1;[time_O_b2_B_temp,time_O_b2_A1_temp]];
index_L_b2_A22A1 = [index_L_b2_A22A1;indexL_b2_A22A1_temp];
time_L_b2_A22A1 = [time_L_b2_A22A1;[time_L_b2_A22_temp,time_L_b2_A1_temp]];
index_OL_b2_C_A1 = [index_OL_b2_C_A1;indexOL_b2_C_A1_temp];
time_OL_b2_C_A1 = [time_OL_b2_C_A1;[time_OL_b2_C_temp,time_OL_b2_A1_temp]];
index_F_b1_A2A1 = [index_F_b1_A2A1;indexF_b1_A2A1_temp];
time_F_b1_A2A1 = [time_F_b1_A2A1;[time_F_b1_A2_temp,time_F_b1_A1_temp]];
index_O_b1_A2A1 = [index_O_b1_A2A1;indexO_b1_A2A1_temp];
time_O_b1_A2A1 = [time_O_b1_A2A1;[time_O_b1_A2_temp,time_O_b1_A1_temp]];
index_L_b1_A2A1 = [index_L_b1_A2A1;indexL_b1_A2A1_temp];
time_L_b1_A2A1 = [time_L_b1_A2A1;[time_L_b1_A2_temp,time_L_b1_A1_temp]];
index_OL_b1_A2A1 = [index_OL_b1_A2A1;indexOL_b1_A2A1_temp];
time_OL_b1_A2A1 = [time_OL_b1_A2A1;[time_OL_b1_A2_temp,time_OL_b1_A1_temp]];


%% Rat 80
scale_x = scale_Rat80_x;
scale_y = scale_Rat80_y;
controlF_temp = [];
controlO_temp = [];
controlL_temp = [];
controlOL_temp = [];

loc_F_A1 = Loc_Rat80_A1(npath_F_Rat80,:);
loc_F_A2 = Loc_Rat80_A2(npath_F_Rat80,:);
loc_NO_A1 = Loc_Rat80_A1(npath_NO_Rat80,:);
loc_NO_A2 = Loc_Rat80_A2(npath_NO_Rat80,:);
loc_NO_B = Loc_Rat80_B;
loc_NL_A1 = Loc_Rat80_A1(npath_NL_Rat80,:);
loc_NL_A2 = Loc_Rat80_A2(npath_NL_Rat80,:);
loc_NL_A22 = Loc_Rat80_A22;
loc_NOL_A1 = Loc_Rat80_A1(npath_NOL_Rat80,:);
loc_NOL_A2 = Loc_Rat80_A2(npath_NOL_Rat80,:);
loc_NOL_C = Loc_Rat80_C;

%no objects
cd(strcat(root_dir,'\Rat80\2015-08-08-SS\begin1\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat80\2015-08-08-SS\begin2\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat80\2015-08-08-SS\begin3\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
%no objects
% cd(strcat(root_dir,'\Rat80\2015-08-09-SS\begin1\'))
% controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% cd(strcat(root_dir,'\Rat80\2015-08-09-SS\begin2\'))
% controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% cd(strcat(root_dir,'\Rat80\2015-08-09-SS\begin3\'))
% controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
% F
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat80\2015-08-14-F\begin2\'))
[indexF_b2_A2A1_temp,time_F_b2_A2_temp,time_F_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat80\2015-08-14-F\begin1\'))
[indexF_b1_A2A1_temp,time_F_b1_A2_temp,time_F_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NOL
radius = [r_s_C,r_l_C;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat80\2015-08-11-NO+NL\begin2\'))
[indexOL_b2_C_A1_temp,time_OL_b2_C_temp,time_OL_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat80\2015-08-11-NO+NL\begin1\'))
[indexOL_b1_A2A1_temp,time_OL_b1_A2_temp,time_OL_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_A2(1),loc_NOL_A2(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NO
radius = [r_s_B,r_l_B;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat80\2015-08-15-NO\begin2\'))
[indexO_b2_B_A1_temp,time_O_b2_B_temp,time_O_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat80\2015-08-15-NO\begin1\'))
[indexO_b1_A2A1_temp,time_O_b1_A2_temp,time_O_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_A2(1),loc_NO_A2(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NL
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat80\2015-08-13-NL\begin2\'))
[indexL_b2_A22A1_temp,time_L_b2_A22_temp,time_L_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat80\2015-08-13-NL\begin1\'))
[indexL_b1_A2A1_temp,time_L_b1_A2_temp,time_L_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A2(1),loc_NL_A2(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);

conF_mean = [conF_mean;mean(controlF_temp,1)];
conO_mean = [conO_mean;mean(controlO_temp,1)];
conL_mean = [conL_mean;mean(controlL_temp,1)];
conOL_mean = [conOL_mean;mean(controlOL_temp,1)];
index_F_b2_A2A1 = [index_F_b2_A2A1;indexF_b2_A2A1_temp];
time_F_b2_A2A1 = [time_F_b2_A2A1;[time_F_b2_A2_temp,time_F_b2_A1_temp]];
index_O_b2_B_A1 = [index_O_b2_B_A1;indexO_b2_B_A1_temp];
time_O_b2_B_A1 = [time_O_b2_B_A1;[time_O_b2_B_temp,time_O_b2_A1_temp]];
index_L_b2_A22A1 = [index_L_b2_A22A1;indexL_b2_A22A1_temp];
time_L_b2_A22A1 = [time_L_b2_A22A1;[time_L_b2_A22_temp,time_L_b2_A1_temp]];
index_OL_b2_C_A1 = [index_OL_b2_C_A1;indexOL_b2_C_A1_temp];
time_OL_b2_C_A1 = [time_OL_b2_C_A1;[time_OL_b2_C_temp,time_OL_b2_A1_temp]];
index_F_b1_A2A1 = [index_F_b1_A2A1;indexF_b1_A2A1_temp];
time_F_b1_A2A1 = [time_F_b1_A2A1;[time_F_b1_A2_temp,time_F_b1_A1_temp]];
index_O_b1_A2A1 = [index_O_b1_A2A1;indexO_b1_A2A1_temp];
time_O_b1_A2A1 = [time_O_b1_A2A1;[time_O_b1_A2_temp,time_O_b1_A1_temp]];
index_L_b1_A2A1 = [index_L_b1_A2A1;indexL_b1_A2A1_temp];
time_L_b1_A2A1 = [time_L_b1_A2A1;[time_L_b1_A2_temp,time_L_b1_A1_temp]];
index_OL_b1_A2A1 = [index_OL_b1_A2A1;indexOL_b1_A2A1_temp];
time_OL_b1_A2A1 = [time_OL_b1_A2A1;[time_OL_b1_A2_temp,time_OL_b1_A1_temp]];


%% Rat 97
scale_x = scale_Rat97_x;
scale_y = scale_Rat97_y;
controlF_temp = [];
controlO_temp = [];
controlL_temp = [];
controlOL_temp = [];

loc_F_A1 = Loc_Rat97_A1(npath_F_Rat97,:);
loc_F_A2 = Loc_Rat97_A2(npath_F_Rat97,:);
loc_NO_A1 = Loc_Rat97_A1(npath_NO_Rat97,:);
loc_NO_A2 = Loc_Rat97_A2(npath_NO_Rat97,:);
loc_NO_B = Loc_Rat97_B;
loc_NL_A1 = Loc_Rat97_A1(npath_NL_Rat97,:);
loc_NL_A2 = Loc_Rat97_A2(npath_NL_Rat97,:);
loc_NL_A22 = Loc_Rat97_A22;
loc_NOL_A1 = Loc_Rat97_A1(npath_NOL_Rat97,:);
loc_NOL_A2 = Loc_Rat97_A2(npath_NOL_Rat97,:);
loc_NOL_C = Loc_Rat97_C;

%no objects
cd(strcat(root_dir,'\Rat97\2016-03-16-SS\begin1\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat97\2016-03-16-SS\begin2\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat97\2016-03-16-SS\begin3\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
%no objects
cd(strcat(root_dir,'\Rat97\2016-03-17-SS\begin1\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat97\2016-03-17-SS\begin2\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
cd(strcat(root_dir,'\Rat97\2016-03-17-SS\begin3\'))
controlF_temp = [controlF_temp;behavindex_cz_v3_quadrant(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlO_temp = [controlO_temp;behavindex_cz_v3_quadrant(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlL_temp = [controlL_temp;behavindex_cz_v3_quadrant(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];
controlOL_temp = [controlOL_temp;behavindex_cz_v3_quadrant(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit)];

% F
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat97\2016-03-22-F\begin2\'))
[indexF_b2_A2A1_temp,time_F_b2_A2_temp,time_F_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat97\2016-03-22-F\begin1\'))
[indexF_b1_A2A1_temp,time_F_b1_A2_temp,time_F_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NOL
radius = [r_s_C,r_l_C;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat97\2016-03-21-NO+NL\begin2\'))
[indexOL_b2_C_A1_temp,time_OL_b2_C_temp,time_OL_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat97\2016-03-21-NO+NL\begin1\'))
[indexOL_b1_A2A1_temp,time_OL_b1_A2_temp,time_OL_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_A2(1),loc_NOL_A2(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NO
radius = [r_s_B,r_l_B;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat97\2016-03-25-NO\begin2\'))
[indexO_b2_B_A1_temp,time_O_b2_B_temp,time_O_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat97\2016-03-25-NO\begin1\'))
[indexO_b1_A2A1_temp,time_O_b1_A2_temp,time_O_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_A2(1),loc_NO_A2(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NL
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat97\2016-03-23-NL\begin2\'))
[indexL_b2_A22A1_temp,time_L_b2_A22_temp,time_L_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Rat97\2016-03-23-NL\begin1\'))
[indexL_b1_A2A1_temp,time_L_b1_A2_temp,time_L_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A2(1),loc_NL_A2(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);

conF_mean = [conF_mean;mean(controlF_temp,1)];
conO_mean = [conO_mean;mean(controlO_temp,1)];
conL_mean = [conL_mean;mean(controlL_temp,1)];
conOL_mean = [conOL_mean;mean(controlOL_temp,1)];
index_F_b2_A2A1 = [index_F_b2_A2A1;indexF_b2_A2A1_temp];
time_F_b2_A2A1 = [time_F_b2_A2A1;[time_F_b2_A2_temp,time_F_b2_A1_temp]];
index_O_b2_B_A1 = [index_O_b2_B_A1;indexO_b2_B_A1_temp];
time_O_b2_B_A1 = [time_O_b2_B_A1;[time_O_b2_B_temp,time_O_b2_A1_temp]];
index_L_b2_A22A1 = [index_L_b2_A22A1;indexL_b2_A22A1_temp];
time_L_b2_A22A1 = [time_L_b2_A22A1;[time_L_b2_A22_temp,time_L_b2_A1_temp]];
index_OL_b2_C_A1 = [index_OL_b2_C_A1;indexOL_b2_C_A1_temp];
time_OL_b2_C_A1 = [time_OL_b2_C_A1;[time_OL_b2_C_temp,time_OL_b2_A1_temp]];
index_F_b1_A2A1 = [index_F_b1_A2A1;indexF_b1_A2A1_temp];
time_F_b1_A2A1 = [time_F_b1_A2A1;[time_F_b1_A2_temp,time_F_b1_A1_temp]];
index_O_b1_A2A1 = [index_O_b1_A2A1;indexO_b1_A2A1_temp];
time_O_b1_A2A1 = [time_O_b1_A2A1;[time_O_b1_A2_temp,time_O_b1_A1_temp]];
index_L_b1_A2A1 = [index_L_b1_A2A1;indexL_b1_A2A1_temp];
time_L_b1_A2A1 = [time_L_b1_A2A1;[time_L_b1_A2_temp,time_L_b1_A1_temp]];
index_OL_b1_A2A1 = [index_OL_b1_A2A1;indexOL_b1_A2A1_temp];
time_OL_b1_A2A1 = [time_OL_b1_A2A1;[time_OL_b1_A2_temp,time_OL_b1_A1_temp]];

%% save data

cd 'C:\Users\ColginLab\Documents\MATLAB\MainFunctions\Code & Data Novel Object';
save(savefile);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stats and plotting stuff
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% savefile='20160330_behavior_discrimination_index_v5(explore_3min_10cm_vel_0_100).mat';
savefile='20160330_behavior_discrimination_index_v5(explore_3min_15cm_vel_0_100).mat';

load(savefile)

% GROUP WISE
ind = 1; % 1=index_total, 2=index_bin

meanF_b2 = mean(index_F_b2_A2A1(:,ind));
SEMF_b2 = std(index_F_b2_A2A1(:,ind))/sqrt(length(index_F_b2_A2A1(:,ind)));
meanF_b1 = mean(index_F_b1_A2A1(:,ind));
SEMF_b1 = std(index_F_b1_A2A1(:,ind))/sqrt(length(index_F_b1_A2A1(:,ind)));
meanF_con = mean(conF_mean(:,ind));
SEMF_con = std(conF_mean(:,ind))/sqrt(length(conF_mean(:,ind)));

meanO_b2 = mean(index_O_b2_B_A1(:,ind));
SEMO_b2 = std(index_O_b2_B_A1(:,ind))/sqrt(length(index_O_b2_B_A1(:,ind)));
meanO_b1 = mean(index_O_b1_A2A1(:,ind));
SEMO_b1 = std(index_O_b1_A2A1(:,ind))/sqrt(length(index_O_b1_A2A1(:,ind)));
meanO_con = mean(conO_mean(:,ind));
SEMO_con = std(conO_mean(:,ind))/sqrt(length(conO_mean(:,ind)));

meanOL_b2 = mean(index_OL_b2_C_A1(:,ind));
SEMOL_b2 = std(index_OL_b2_C_A1(:,ind))/sqrt(length(index_OL_b2_C_A1(:,ind)));
meanOL_b1 = mean(index_OL_b1_A2A1(:,ind));
SEMOL_b1 = std(index_OL_b1_A2A1(:,ind))/sqrt(length(index_OL_b1_A2A1(:,ind)));
meanOL_con = mean(conOL_mean(:,ind));
SEMOL_con = std(conOL_mean(:,ind))/sqrt(length(conOL_mean(:,ind)));

meanL_b2 = nanmean(index_L_b2_A22A1(:,ind));
SEML_b2 = nanstd(index_L_b2_A22A1(:,ind))/sqrt(sum(~isnan(index_L_b2_A22A1(:,ind))));
meanL_b1 = nanmean(index_L_b1_A2A1(:,ind));
SEML_b1 = nanstd(index_L_b1_A2A1(:,ind))/sqrt(sum(~isnan(index_L_b1_A2A1(:,ind))));
meanL_con = nanmean(conL_mean(:,ind));
SEML_con = nanstd(conL_mean(:,ind))/sqrt(sum(~isnan(conL_mean(:,ind))));


ffa = figure('Units','normalized','Position',[0 0.1 0.5 0.5]);
hold on
y = [[meanF_b2;meanOL_b2;meanL_b2;meanO_b2],[meanF_con;meanOL_con;meanL_con;meanO_con]];
errY = zeros(4,2,2);
errY(:,:,1) = [[SEMF_b2;SEMOL_b2;SEML_b2;SEMO_b2],[SEMF_con;SEMOL_con;SEML_con;SEMO_con]];
errY(:,:,2) = [[SEMF_b2;SEMOL_b2;SEML_b2;SEMO_b2],[SEMF_con;SEMOL_con;SEML_con;SEMO_con]];
[b1,b2,x0] = barwitherr(errY, y);    % Plot with errorbars
set(b1(1),'FaceColor',[180,100,180]./255);
set(b1(2),'FaceColor',[80,120,0]./255);
set(b2(1),'linewidth',2);
set(b2(2),'linewidth',2);
line([0.5,4.5],[0.5,0.5],'linewidth',1,'Color',[150,150,150]./255,'LineStyle','--');
set(gca, 'FontSize',24);
hold off
xlim([0.5,4.5])
ylim([0.3,0.8])
set(gca, 'XTick',[1,2,3,4]);
set(gca, 'XTickLabel',{'F','NO+NL','NL','NO'});
set(gca, 'YTick',0.3:0.1:0.8);
ylabel('Discrimination Index','HorizontalAlignment','center');
legend({'Objects','No objects'},'Location','northeast')
box off
legend boxoff

ffa = figure('Units','normalized','Position',[0 0.1 0.5 0.5]);
y = [[meanF_b2;meanOL_b2;meanL_b2;meanO_b2],[meanF_b1;meanOL_b1;meanL_b1;meanO_b1],[meanF_con;meanOL_con;meanL_con;meanO_con]];
errY = zeros(4,3,2);
errY(:,:,1) = [[SEMF_b2;SEMOL_b2;SEML_b2;SEMO_b2],[SEMF_b1;SEMOL_b1;SEML_b1;SEMO_b1],[SEMF_con;SEMOL_con;SEML_con;SEMO_con]];
errY(:,:,2) = [[SEMF_b2;SEMOL_b2;SEML_b2;SEMO_b2],[SEMF_b1;SEMOL_b1;SEML_b1;SEMO_b1],[SEMF_con;SEMOL_con;SEML_con;SEMO_con]];
[b1,b2,x0] = barwitherr(errY, y);    % Plot with errorbars
set(b1(1),'FaceColor',[180,100,180]./255);
set(b1(2),'FaceColor',[40,100,160]./255);
set(b1(3),'FaceColor',[80,120,0]./255);
set(b2(1),'linewidth',1);
set(b2(2),'linewidth',1);
set(b2(3),'linewidth',1);
set(gca, 'FontSize',24);         
line([0.5,4.5],[0.5,0.5],'linewidth',1,'Color',[150,150,150]./255,'LineStyle','--');
xlim([0.5,4.5])
ylim([0.3,0.8])
set(gca, 'XTick',[1,2,3,4]);
set(gca, 'XTickLabel',{'F','NO+NL','NL','NO'});
set(gca, 'YTick',0.3:0.1:0.8);
ylabel('Discrimination Index','HorizontalAlignment','center');
% legend({'Novel and familiar objects','No objects'},'Location','northoutside')
legend({'Session2','Session1','No objects'},'Location','northeast')
box off
legend boxoff


% group exploration time, and then plot
meantime_F_b2_A2A1 = nanmean(time_F_b2_A2A1);
SEMtime_F_b2_A2A1 = nanstd(time_F_b2_A2A1)/sqrt(sum(~isnan(time_F_b2_A2A1(:,1))));
meantime_O_b2_B_A1 = nanmean(time_O_b2_B_A1);
SEMtime_O_b2_B_A1 = nanstd(time_O_b2_B_A1)/sqrt(sum(~isnan(time_O_b2_B_A1(:,1))));
meantime_L_b2_A22A1 = nanmean(time_L_b2_A22A1);
SEMtime_L_b2_A22A1 = nanstd(time_L_b2_A22A1)/sqrt(sum(~isnan(time_L_b2_A22A1(:,1))));
meantime_OL_b2_C_A1 = nanmean(time_OL_b2_C_A1);
SEMtime_OL_b2_C_A1 = nanstd(time_OL_b2_C_A1)/sqrt(sum(~isnan(time_OL_b2_C_A1(:,1))));

ffb = figure('Units','normalized','Position',[0 0.1 0.3 0.5]);
y = [[meantime_F_b2_A2A1(1);meantime_OL_b2_C_A1(1);meantime_L_b2_A22A1(1);meantime_O_b2_B_A1(1)],...
    [meantime_F_b2_A2A1(2);meantime_OL_b2_C_A1(2);meantime_L_b2_A22A1(2);meantime_O_b2_B_A1(2)]];
errY = zeros(4,2,2);
errY(:,:,1) = [[SEMtime_F_b2_A2A1(1);SEMtime_OL_b2_C_A1(1);SEMtime_L_b2_A22A1(1);SEMtime_O_b2_B_A1(1)],...
    [SEMtime_F_b2_A2A1(2);SEMtime_OL_b2_C_A1(2);SEMtime_L_b2_A22A1(2);SEMtime_O_b2_B_A1(2)]];
errY(:,:,2) = [[SEMtime_F_b2_A2A1(1);SEMtime_OL_b2_C_A1(1);SEMtime_L_b2_A22A1(1);SEMtime_O_b2_B_A1(1)],...
    [SEMtime_F_b2_A2A1(2);SEMtime_OL_b2_C_A1(2);SEMtime_L_b2_A22A1(2);SEMtime_O_b2_B_A1(2)]];
[b1,b2,x0] = barwitherr(errY, y);    % Plot with errorbars
set(b1(1),'FaceColor',[20,120,200]./255);
set(b1(2),'FaceColor',[100,180,220]./255);
set(b2(1),'linewidth',2);
set(b2(2),'linewidth',2);
set(gca, 'FontSize',24);         
xlim([0.5,4.5])
ylim([0,70])
set(gca, 'XTick',[1,2,3,4]);
set(gca, 'XTickLabel',{'F','NO+NL','NL','NO'});
% set(gca, 'YTick',[0.3,0.5,1]);
ylabel('Exploration time (s)');
% legend({'Novel and familiar objects','No objects'},'Location','northoutside')
legend({'Novel','Familiar'},'Location','northeast')
box off
legend boxoff


%% group DI data for Stats in SPSS
% savefile='20160330_behavior_discrimination_index_v5(explore_3min_10cm_vel_0_100).mat';
savefile='20160330_behavior_discrimination_index_v5(explore_3min_15cm_vel_0_100).mat';

load(savefile)
ind = 1; % 1=index_total, 2=index_bin
rat_id = [13,17,31,44,45,47,68,79,80,97]';
id_NOL = 1; id_NL = 2; id_NO = 3; id_F = 4;
id_b2 = 1; id_b1 = 2; id_con = 3;

index_OL_b2 = index_OL_b2_C_A1(:,ind);
index_OL_b1 = index_OL_b1_A2A1(:,ind);
index_OL_con = conOL_mean(:,ind);
nrat_OL = length(index_OL_b2);
data_NOL = [[rat_id,ones(nrat_OL,1)*id_NOL,ones(nrat_OL,1)*id_b2,index_OL_b2];...
    [rat_id,ones(nrat_OL,1)*id_NOL,ones(nrat_OL,1)*id_b1,index_OL_b1];...
    [rat_id,ones(nrat_OL,1)*id_NOL,ones(nrat_OL,1)*id_con,index_OL_con]];

index_L_b2 = index_L_b2_A22A1(:,ind);
index_L_b1 = index_L_b1_A2A1(:,ind);
index_L_con = conL_mean(:,ind);
nrat_L = length(index_L_b2);
data_NL = [[rat_id,ones(nrat_L,1)*id_NL,ones(nrat_L,1)*id_b2,index_L_b2];...
    [rat_id,ones(nrat_L,1)*id_NL,ones(nrat_L,1)*id_b1,index_L_b1];...
    [rat_id,ones(nrat_L,1)*id_NL,ones(nrat_L,1)*id_con,index_L_con]];

index_O_b2 = index_O_b2_B_A1(:,ind);
index_O_b1 = index_O_b1_A2A1(:,ind);
index_O_con = conO_mean(:,ind);
nrat_O = length(index_O_b2);
data_NO = [[rat_id,ones(nrat_O,1)*id_NO,ones(nrat_O,1)*id_b2,index_O_b2];...
    [rat_id,ones(nrat_O,1)*id_NO,ones(nrat_O,1)*id_b1,index_O_b1];...
    [rat_id,ones(nrat_O,1)*id_NO,ones(nrat_O,1)*id_con,index_O_con]];

index_F_b2 = index_F_b2_A2A1(:,ind);
index_F_b1 = index_F_b1_A2A1(:,ind);
index_F_con = conF_mean(:,ind);
nrat_F = length(index_F_b2);
data_F = [[rat_id,ones(nrat_F,1)*id_F,ones(nrat_F,1)*id_b2,index_F_b2];...
    [rat_id,ones(nrat_F,1)*id_F,ones(nrat_F,1)*id_b1,index_F_b1];...
    [rat_id,ones(nrat_F,1)*id_F,ones(nrat_F,1)*id_con,index_F_con]];

% data for overall mixed models
data = [data_NOL;data_NL;data_NO;data_F];
ind = find(isnan(data(:,end)));
data(ind,:) = [];

% data for 1-way repeated measure for each novel condition
data_F_1repeat = [index_F_b2,index_F_b1,index_F_con];
data_NOL_1repeat = [index_OL_b2,index_OL_b1,index_OL_con];
data_NL_1repeat = [index_L_b2,index_L_b1,index_L_con];
data_NO_1repeat = [index_O_b2,index_O_b1,index_O_con];

% data for 1-way repeated measure for each session type
% (session2/session1/control)
data_session2 = [index_F_b2,index_OL_b2,index_L_b2,index_O_b2];
data_session1 = [index_F_b1,index_OL_b1,index_L_b1,index_O_b1];
data_con = [index_F_con,index_OL_con,index_L_con,index_O_con];


%% group the exploration time data for Stats in SPSS
id_Obj1 = 1; id_Obj2 = 2;
nrat_OL = size(time_OL_b2_C_A1,1);
data_NOL_b2 = [[rat_id,ones(nrat_OL,1)*id_NOL,ones(nrat_OL,1)*id_Obj1,time_OL_b2_C_A1(:,2)];...
    [rat_id,ones(nrat_OL,1)*id_NOL,ones(nrat_OL,1)*id_Obj2,time_OL_b2_C_A1(:,1)]];
nrat_L = size(time_L_b2_A22A1,1);
data_NL_b2 = [[rat_id,ones(nrat_L,1)*id_NL,ones(nrat_L,1)*id_Obj1,time_L_b2_A22A1(:,2)];...
    [rat_id,ones(nrat_L,1)*id_NL,ones(nrat_L,1)*id_Obj2,time_L_b2_A22A1(:,1)]];
nrat_O = size(time_O_b2_B_A1,1);
data_NO_b2 = [[rat_id,ones(nrat_O,1)*id_NO,ones(nrat_O,1)*id_Obj1,time_O_b2_B_A1(:,2)];...
    [rat_id,ones(nrat_O,1)*id_NO,ones(nrat_O,1)*id_Obj2,time_O_b2_B_A1(:,1)]];
nrat_F = size(time_F_b2_A2A1,1);
data_F_b2 = [[rat_id,ones(nrat_F,1)*id_F,ones(nrat_F,1)*id_Obj1,time_F_b2_A2A1(:,2)];...
    [rat_id,ones(nrat_F,1)*id_F,ones(nrat_F,1)*id_Obj2,time_F_b2_A2A1(:,1)]];

nrat_OL = size(time_OL_b1_A2A1,1);
data_b1 = [sum(time_F_b1_A2A1(:,2),2),...
    sum(time_OL_b1_A2A1(:,2),2),...
    sum(time_L_b1_A2A1(:,2),2),...
    sum(time_O_b1_A2A1(:,2),2)];
meantime_F_b1_A2A1 = nanmean(data_b1(:,1));
SEMtime_F_b1_A2A1 = nanstd(data_b1(:,1))/sqrt(sum(~isnan(data_b1(:,1))));
meantime_OL_b1_A2A1 = nanmean(data_b1(:,2));
SEMtime_OL_b1_A2A1 = nanstd(data_b1(:,2))/sqrt(sum(~isnan(data_b1(:,2))));
meantime_L_b1_A2A1 = nanmean(data_b1(:,3));
SEMtime_L_b1_A2A1 = nanstd(data_b1(:,3))/sqrt(sum(~isnan(data_b1(:,3))));
meantime_O_b1_A2A1 = nanmean(data_b1(:,4));
SEMtime_O_b1_A2A1 = nanstd(data_b1(:,4))/sqrt(sum(~isnan(data_b1(:,4))));

ffb = figure('Units','normalized','Position',[0 0.1 0.2 0.5]);
y = [meantime_F_b1_A2A1(1);meantime_OL_b1_A2A1(1);meantime_L_b1_A2A1(1);meantime_O_b1_A2A1(1)];
errY = zeros(4,1,2);
errY(:,:,1) = [SEMtime_F_b1_A2A1(1);SEMtime_OL_b1_A2A1(1);SEMtime_L_b1_A2A1(1);SEMtime_O_b1_A2A1(1)];
errY(:,:,2) = [SEMtime_F_b1_A2A1(1);SEMtime_OL_b1_A2A1(1);SEMtime_L_b1_A2A1(1);SEMtime_O_b1_A2A1(1)];
[b1,b2,x0] = barwitherr(errY, y);    % Plot with errorbars
set(b1(1),'FaceColor',[100,180,220]./255);
set(b2(1),'linewidth',2);
set(gca, 'FontSize',24);         
xlim([0.5,4.5])
ylim([0,60])
set(gca, 'XTick',[1,2,3,4]);
set(gca, 'XTickLabel',{'F','NO+NL','NL','NO'});
% set(gca, 'YTick',[0.3,0.5,1]);
ylabel('Exploration time (s)');
box off