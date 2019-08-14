% % B is the obj change
% % C is the obj+loc change
% % A' is the loc change
%
% v5: treat each object as an ellipse, and fix the radius from the animal's
% location to the edge of the ellipse

clear
code_160420_alldata_directories

% savefile='20160330_behavior_discrimination_index_v5(explore_3min_10cm_vel_0_100).mat';
savefile='20160708_behavior_discrimination_index_v5(explore_3min_10cm_vel_0_100).mat';

% setting
radius_objectcenter = 15; % cm, the distance from the animal to the ellipse edge
% 6cm is the diameter of the headstage
radius_con = 10; % cm, not using for behavindex_cz_v3_quadrant
starttime = 0;
endtime = 3;
starttime_con = 0;
endtime_con = 10;
root_dir = 'C:\DATA\Novel object';
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
npath_F_Mouse30=1;
npath_F_Mouse52=1;
npath_F_Mouse55=1;
npath_F_Mouse56=1;
npath_F_Mouse65=1;
npath_F_Mouse71=1;


npath_NOL_Mouse30=3;
npath_NOL_Mouse52=3;
npath_NOL_Mouse55=3;
npath_NOL_Mouse56=3;
npath_NOL_Mouse65=3;
npath_NOL_Mouse71=3;

npath_NL_Mouse30=4;
npath_NL_Mouse52=4;
npath_NL_Mouse55=4;
npath_NL_Mouse56=4;
npath_NL_Mouse65=4;
npath_NL_Mouse71=4;

npath_NO_Mouse30=2;
npath_NO_Mouse52=2;
npath_NO_Mouse55=2;
npath_NO_Mouse56=2;
npath_NO_Mouse65=2;
npath_NO_Mouse71=2;

npath_H_Mouse30=5;
npath_H_Mouse52=5;
npath_H_Mouse55=5;
npath_H_Mouse56=5;
npath_H_Mouse65=5;
npath_H_Mouse71=5;


time_H_b1_A1234=[];
time_H_b2_A1234=[];
time_H_b3_A1234=[];

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



%% Mouse30

loc_F_A1 = Loc_Mouse30_A1(npath_F_Mouse30,:);
loc_F_A2 = Loc_Mouse30_A2(npath_F_Mouse30,:);
loc_NO_A1 = Loc_Mouse30_A1(npath_NO_Mouse30,:);
loc_NO_A2 = Loc_Mouse30_A2(npath_NO_Mouse30,:);
loc_NO_B = Loc_Mouse30_B;
loc_NL_A1 = Loc_Mouse30_A1(npath_NL_Mouse30,:);
loc_NL_A2 = Loc_Mouse30_A2(npath_NL_Mouse30,:);
loc_NL_A22 = Loc_Mouse30_A22;
loc_NOL_A1 = Loc_Mouse30_A1(npath_NOL_Mouse30,:);
loc_NOL_A2 = Loc_Mouse30_A2(npath_NOL_Mouse30,:);
loc_NOL_C = Loc_Mouse30_C;
loc_H_A1 = Loc_Mouse30_A1(npath_H_Mouse30,:);
loc_H_A2 = Loc_Mouse30_A2(npath_H_Mouse30,:);
loc_H_A3 = Loc_Mouse30_A3;
loc_H_A4 = Loc_Mouse30_A4;


scale_x= .38;
scale_y= .385;
cd(strcat(root_dir,'\Mouse30\2014-12-19-H\begin1\'))
[indexH_b1_A1A2_temp,time_H_b1_A1_temp,time_H_b1_A2_temp] = behavindex_cz_v3_quadrant(loc_H_A1(1),loc_H_A1(2),loc_H_A2(1),loc_H_A2(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
[indexH_b1_A3A4_temp,time_H_b1_A3_temp,time_H_b1_A4_temp] = behavindex_cz_v3_quadrant(loc_H_A3(1),loc_H_A3(2),loc_H_A4(1),loc_H_A4(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
cd(strcat(root_dir,'\Mouse30\2014-12-19-H\begin2'))
[indexH_b2_A1A2_temp,time_H_b2_A1_temp,time_H_b2_A2_temp] = behavindex_cz_v3_quadrant(loc_H_A1(1),loc_H_A1(2),loc_H_A2(1),loc_H_A2(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
[indexH_b2_A3A4_temp,time_H_b2_A3_temp,time_H_b2_A4_temp] = behavindex_cz_v3_quadrant(loc_H_A3(1),loc_H_A3(2),loc_H_A4(1),loc_H_A4(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
cd(strcat(root_dir,'\Mouse30\2014-12-19-H\begin3'))
[indexH_b3_A1A2_temp,time_H_b3_A1_temp,time_H_b3_A2_temp] = behavindex_cz_v3_quadrant(loc_H_A1(1),loc_H_A1(2),loc_H_A2(1),loc_H_A2(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
[indexH_b3_A3A4_temp,time_H_b3_A3_temp,time_H_b3_A4_temp] = behavindex_cz_v3_quadrant(loc_H_A3(1),loc_H_A3(2),loc_H_A4(1),loc_H_A4(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);

% F
scale_x= .38;
scale_y= .385;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse30\2014-12-20-F\begin2\'))
[indexF_b2_A2A1_temp,time_F_b2_A2_temp,time_F_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse30\2014-12-20-F\begin1\'))
[indexF_b1_A2A1_temp,time_F_b1_A2_temp,time_F_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NOL
scale_x= .354;
scale_y= .382;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse30\2014-12-25_NO+NL\begin2\'))
[indexOL_b2_C_A1_temp,time_OL_b2_C_temp,time_OL_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse30\2014-12-25_NO+NL\begin1\'))
[indexOL_b1_A2A1_temp,time_OL_b1_A2_temp,time_OL_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_A2(1),loc_NOL_A2(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NO
scale_x= .353;
scale_y= .391;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse30\2014-12-23-NO\begin2\'))
[indexO_b2_B_A1_temp,time_O_b2_B_temp,time_O_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse30\2014-12-23-NO\begin1\'))
[indexO_b1_A2A1_temp,time_O_b1_A2_temp,time_O_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_A2(1),loc_NO_A2(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NL
scale_x= .358;
scale_y= .391;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse30\2014-12-21-NL\begin2\'))
[indexL_b2_A22A1_temp,time_L_b2_A22_temp,time_L_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse30\2014-12-21-NL\begin1\'))
[indexL_b1_A2A1_temp,time_L_b1_A2_temp,time_L_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A2(1),loc_NL_A2(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);


time_H_b1_A1234=[time_H_b1_A1234;time_H_b1_A1_temp time_H_b1_A2_temp time_H_b1_A3_temp time_H_b1_A4_temp];
time_H_b2_A1234=[time_H_b2_A1234;time_H_b2_A1_temp time_H_b2_A2_temp time_H_b2_A3_temp time_H_b2_A4_temp];
time_H_b3_A1234=[time_H_b3_A1234;time_H_b3_A1_temp time_H_b3_A2_temp time_H_b3_A3_temp time_H_b3_A4_temp];

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


%% Mouse52


loc_F_A1 = Loc_Mouse52_A1(npath_F_Mouse52,:);
loc_F_A2 = Loc_Mouse52_A2(npath_F_Mouse52,:);
loc_NO_A1 = Loc_Mouse52_A1(npath_NO_Mouse52,:);
loc_NO_A2 = Loc_Mouse52_A2(npath_NO_Mouse52,:);
loc_NO_B = Loc_Mouse52_B;
loc_NL_A1 = Loc_Mouse52_A1(npath_NL_Mouse52,:);
loc_NL_A2 = Loc_Mouse52_A2(npath_NL_Mouse52,:);
loc_NL_A22 = Loc_Mouse52_A22;
loc_NOL_A1 = Loc_Mouse52_A1(npath_NOL_Mouse52,:);
loc_NOL_A2 = Loc_Mouse52_A2(npath_NOL_Mouse52,:);
loc_NOL_C = Loc_Mouse52_C;
loc_H_A1 = Loc_Mouse52_A1(npath_H_Mouse52,:);
loc_H_A2 = Loc_Mouse52_A2(npath_H_Mouse52,:);
loc_H_A3 = Loc_Mouse52_A3;
loc_H_A4 = Loc_Mouse52_A4;


%No objects
scale_x= .38;
scale_y= .385;
cd(strcat(root_dir,'\Mouse52\2015-08-13-H\begin1\'))
[indexH_b1_A1A2_temp,time_H_b1_A1_temp,time_H_b1_A2_temp] = behavindex_cz_v3_quadrant(loc_H_A1(1),loc_H_A1(2),loc_H_A2(1),loc_H_A2(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
[indexH_b1_A3A4_temp,time_H_b1_A3_temp,time_H_b1_A4_temp] = behavindex_cz_v3_quadrant(loc_H_A3(1),loc_H_A3(2),loc_H_A4(1),loc_H_A4(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
cd(strcat(root_dir,'\Mouse52\2015-08-13-H\begin2'))
[indexH_b2_A1A2_temp,time_H_b2_A1_temp,time_H_b2_A2_temp] = behavindex_cz_v3_quadrant(loc_H_A1(1),loc_H_A1(2),loc_H_A2(1),loc_H_A2(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
[indexH_b2_A3A4_temp,time_H_b2_A3_temp,time_H_b2_A4_temp] = behavindex_cz_v3_quadrant(loc_H_A3(1),loc_H_A3(2),loc_H_A4(1),loc_H_A4(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
cd(strcat(root_dir,'\Mouse52\2015-08-13-H\begin3'))
[indexH_b3_A1A2_temp,time_H_b3_A1_temp,time_H_b3_A2_temp] = behavindex_cz_v3_quadrant(loc_H_A1(1),loc_H_A1(2),loc_H_A2(1),loc_H_A2(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
[indexH_b3_A3A4_temp,time_H_b3_A3_temp,time_H_b3_A4_temp] = behavindex_cz_v3_quadrant(loc_H_A3(1),loc_H_A3(2),loc_H_A4(1),loc_H_A4(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);

% F
scale_x= .35;
scale_y= .38;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse52\2015-08-15-F\begin2\'))
[indexF_b2_A2A1_temp,time_F_b2_A2_temp,time_F_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse52\2015-08-15-F\begin1\'))
[indexF_b1_A2A1_temp,time_F_b1_A2_temp,time_F_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NOL
scale_x= .335;
scale_y= .365;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse52\2015-08-14-NO+NL\begin2\'))
[indexOL_b2_C_A1_temp,time_OL_b2_C_temp,time_OL_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse52\2015-08-14-NO+NL\begin1\'))
[indexOL_b1_A2A1_temp,time_OL_b1_A2_temp,time_OL_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_A2(1),loc_NOL_A2(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NO
scale_x= .34;
scale_y= .385;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse52\2015-08-18-NO\begin2\'))
[indexO_b2_B_A1_temp,time_O_b2_B_temp,time_O_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse52\2015-08-18-NO\begin1\'))
[indexO_b1_A2A1_temp,time_O_b1_A2_temp,time_O_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_A2(1),loc_NO_A2(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NL
scale_x= .4;
scale_y= .385;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse52\2015-08-16-NL\begin2\'))
[indexL_b2_A22A1_temp,time_L_b2_A22_temp,time_L_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse52\2015-08-16-NL\begin1\'))
[indexL_b1_A2A1_temp,time_L_b1_A2_temp,time_L_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A2(1),loc_NL_A2(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);


time_H_b1_A1234=[time_H_b1_A1234;time_H_b1_A1_temp time_H_b1_A2_temp time_H_b1_A3_temp time_H_b1_A4_temp];
time_H_b2_A1234=[time_H_b2_A1234;time_H_b2_A1_temp time_H_b2_A2_temp time_H_b2_A3_temp time_H_b2_A4_temp];
time_H_b3_A1234=[time_H_b3_A1234;time_H_b3_A1_temp time_H_b3_A2_temp time_H_b3_A3_temp time_H_b3_A4_temp];

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


%% Mouse 55

loc_F_A1 = Loc_Mouse55_A1(npath_F_Mouse55,:);
loc_F_A2 = Loc_Mouse55_A2(npath_F_Mouse55,:);
loc_NO_A1 = Loc_Mouse55_A1(npath_NO_Mouse55,:);
loc_NO_A2 = Loc_Mouse55_A2(npath_NO_Mouse55,:);
loc_NO_B = Loc_Mouse55_B;
loc_NL_A1 = Loc_Mouse55_A1(npath_NL_Mouse55,:);
loc_NL_A2 = Loc_Mouse55_A2(npath_NL_Mouse55,:);
loc_NL_A22 = Loc_Mouse55_A22;
loc_NOL_A1 = Loc_Mouse55_A1(npath_NOL_Mouse55,:);
loc_NOL_A2 = Loc_Mouse55_A2(npath_NOL_Mouse55,:);
loc_NOL_C = Loc_Mouse55_C;
loc_H_A1 = Loc_Mouse52_A1(npath_H_Mouse52,:);
loc_H_A2 = Loc_Mouse52_A2(npath_H_Mouse52,:);
loc_H_A3 = Loc_Mouse52_A3;
loc_H_A4 = Loc_Mouse52_A4;

%no objects
scale_x= .357;
scale_y= .375;
cd(strcat(root_dir,'\Mouse55\2015-08-24-H\begin1\'))
[indexH_b1_A1A2_temp,time_H_b1_A1_temp,time_H_b1_A2_temp] = behavindex_cz_v3_quadrant(loc_H_A1(1),loc_H_A1(2),loc_H_A2(1),loc_H_A2(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
[indexH_b1_A3A4_temp,time_H_b1_A3_temp,time_H_b1_A4_temp] = behavindex_cz_v3_quadrant(loc_H_A3(1),loc_H_A3(2),loc_H_A4(1),loc_H_A4(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
cd(strcat(root_dir,'\Mouse55\2015-08-24-H\begin2'))
[indexH_b2_A1A2_temp,time_H_b2_A1_temp,time_H_b2_A2_temp] = behavindex_cz_v3_quadrant(loc_H_A1(1),loc_H_A1(2),loc_H_A2(1),loc_H_A2(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
[indexH_b2_A3A4_temp,time_H_b2_A3_temp,time_H_b2_A4_temp] = behavindex_cz_v3_quadrant(loc_H_A3(1),loc_H_A3(2),loc_H_A4(1),loc_H_A4(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
cd(strcat(root_dir,'\Mouse55\2015-08-24-H\begin3'))
[indexH_b3_A1A2_temp,time_H_b3_A1_temp,time_H_b3_A2_temp] = behavindex_cz_v3_quadrant(loc_H_A1(1),loc_H_A1(2),loc_H_A2(1),loc_H_A2(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
[indexH_b3_A3A4_temp,time_H_b3_A3_temp,time_H_b3_A4_temp] = behavindex_cz_v3_quadrant(loc_H_A3(1),loc_H_A3(2),loc_H_A4(1),loc_H_A4(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);

% F
scale_x= .358;
scale_y= .387;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse55\2015-08-29-F\begin2\'))
[indexF_b2_A2A1_temp,time_F_b2_A2_temp,time_F_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse55\2015-08-29-F\begin1\'))
[indexF_b1_A2A1_temp,time_F_b1_A2_temp,time_F_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NOL
scale_x= .363;
scale_y= .391;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse55\2015-08-26-NO+NL\begin2\'))
[indexOL_b2_C_A1_temp,time_OL_b2_C_temp,time_OL_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse55\2015-08-26-NO+NL\begin1\'))
[indexOL_b1_A2A1_temp,time_OL_b1_A2_temp,time_OL_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_A2(1),loc_NOL_A2(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NO
scale_x= .51;
scale_y= .38;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse55\2015-08-28-NO\begin2\'))
[indexO_b2_B_A1_temp,time_O_b2_B_temp,time_O_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse55\2015-08-28-NO\begin1\'))
[indexO_b1_A2A1_temp,time_O_b1_A2_temp,time_O_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_A2(1),loc_NO_A2(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NL
scale_x= .347;
scale_y= .368;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse55\2015-08-30-NL\begin2\'))
[indexL_b2_A22A1_temp,time_L_b2_A22_temp,time_L_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse55\2015-08-30-NL\begin1\'))
[indexL_b1_A2A1_temp,time_L_b1_A2_temp,time_L_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A2(1),loc_NL_A2(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);

time_H_b1_A1234=[time_H_b1_A1234;time_H_b1_A1_temp time_H_b1_A2_temp time_H_b1_A3_temp time_H_b1_A4_temp];
time_H_b2_A1234=[time_H_b2_A1234;time_H_b2_A1_temp time_H_b2_A2_temp time_H_b2_A3_temp time_H_b2_A4_temp];
time_H_b3_A1234=[time_H_b3_A1234;time_H_b3_A1_temp time_H_b3_A2_temp time_H_b3_A3_temp time_H_b3_A4_temp];

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

%% Mouse 56

loc_F_A1 = Loc_Mouse56_A1(npath_F_Mouse56,:);
loc_F_A2 = Loc_Mouse56_A2(npath_F_Mouse56,:);
loc_NO_A1 = Loc_Mouse56_A1(npath_NO_Mouse56,:);
loc_NO_A2 = Loc_Mouse56_A2(npath_NO_Mouse56,:);
loc_NO_B = Loc_Mouse56_B;
loc_NL_A1 = Loc_Mouse56_A1(npath_NL_Mouse56,:);
loc_NL_A2 = Loc_Mouse56_A2(npath_NL_Mouse56,:);
loc_NL_A22 = Loc_Mouse56_A22;
loc_NOL_A1 = Loc_Mouse56_A1(npath_NOL_Mouse56,:);
loc_NOL_A2 = Loc_Mouse56_A2(npath_NOL_Mouse56,:);
loc_NOL_C = Loc_Mouse56_C;
loc_H_A1 = Loc_Mouse56_A1(npath_H_Mouse56,:);
loc_H_A2 = Loc_Mouse56_A2(npath_H_Mouse56,:);
loc_H_A3 = Loc_Mouse56_A3;
loc_H_A4 = Loc_Mouse56_A4;


%no objects
scale_x= .33;
scale_y= .365;
cd(strcat(root_dir,'\Mouse56\2015-09-25-H\begin1\'))
[indexH_b1_A1A2_temp,time_H_b1_A1_temp,time_H_b1_A2_temp] = behavindex_cz_v3_quadrant(loc_H_A1(1),loc_H_A1(2),loc_H_A2(1),loc_H_A2(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
[indexH_b1_A3A4_temp,time_H_b1_A3_temp,time_H_b1_A4_temp] = behavindex_cz_v3_quadrant(loc_H_A3(1),loc_H_A3(2),loc_H_A4(1),loc_H_A4(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
cd(strcat(root_dir,'\Mouse56\2015-09-25-H\begin2'))
[indexH_b2_A1A2_temp,time_H_b2_A1_temp,time_H_b2_A2_temp] = behavindex_cz_v3_quadrant(loc_H_A1(1),loc_H_A1(2),loc_H_A2(1),loc_H_A2(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
[indexH_b2_A3A4_temp,time_H_b2_A3_temp,time_H_b2_A4_temp] = behavindex_cz_v3_quadrant(loc_H_A3(1),loc_H_A3(2),loc_H_A4(1),loc_H_A4(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
cd(strcat(root_dir,'\Mouse56\2015-09-25-H\begin3'))
[indexH_b3_A1A2_temp,time_H_b3_A1_temp,time_H_b3_A2_temp] = behavindex_cz_v3_quadrant(loc_H_A1(1),loc_H_A1(2),loc_H_A2(1),loc_H_A2(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
[indexH_b3_A3A4_temp,time_H_b3_A3_temp,time_H_b3_A4_temp] = behavindex_cz_v3_quadrant(loc_H_A3(1),loc_H_A3(2),loc_H_A4(1),loc_H_A4(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);

% F
scale_x= .338;
scale_y= .38;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse56\2015-09-26-F\begin2\'))
[indexF_b2_A2A1_temp,time_F_b2_A2_temp,time_F_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse56\2015-09-26-F\begin1\'))
[indexF_b1_A2A1_temp,time_F_b1_A2_temp,time_F_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NOL
scale_x= .355;
scale_y= .393;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse56\2015-09-27-NO+NL\begin2\'))
[indexOL_b2_C_A1_temp,time_OL_b2_C_temp,time_OL_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse56\2015-09-27-NO+NL\begin1\'))
[indexOL_b1_A2A1_temp,time_OL_b1_A2_temp,time_OL_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_A2(1),loc_NOL_A2(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NO
scale_x= .343;
scale_y= .404;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse56\2015-09-29-NO\begin2\'))
[indexO_b2_B_A1_temp,time_O_b2_B_temp,time_O_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse56\2015-09-29-NO\begin1\'))
[indexO_b1_A2A1_temp,time_O_b1_A2_temp,time_O_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_A2(1),loc_NO_A2(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NL
scale_x= .38;
scale_y= .411;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse56\2015-10-01-NL\begin2\'))
[indexL_b2_A22A1_temp,time_L_b2_A22_temp,time_L_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse56\2015-10-01-NL\begin1\'))
[indexL_b1_A2A1_temp,time_L_b1_A2_temp,time_L_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A2(1),loc_NL_A2(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);

time_H_b1_A1234=[time_H_b1_A1234;time_H_b1_A1_temp time_H_b1_A2_temp time_H_b1_A3_temp time_H_b1_A4_temp];
time_H_b2_A1234=[time_H_b2_A1234;time_H_b2_A1_temp time_H_b2_A2_temp time_H_b2_A3_temp time_H_b2_A4_temp];
time_H_b3_A1234=[time_H_b3_A1234;time_H_b3_A1_temp time_H_b3_A2_temp time_H_b3_A3_temp time_H_b3_A4_temp];

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

%% Mouse 65

loc_F_A1 = Loc_Mouse65_A1(npath_F_Mouse65,:);
loc_F_A2 = Loc_Mouse65_A2(npath_F_Mouse65,:);
loc_NO_A1 = Loc_Mouse65_A1(npath_NO_Mouse65,:);
loc_NO_A2 = Loc_Mouse65_A2(npath_NO_Mouse65,:);
loc_NO_B = Loc_Mouse65_B;
loc_NL_A1 = Loc_Mouse65_A1(npath_NL_Mouse65,:);
loc_NL_A2 = Loc_Mouse65_A2(npath_NL_Mouse65,:);
loc_NL_A22 = Loc_Mouse65_A22;
loc_NOL_A1 = Loc_Mouse65_A1(npath_NOL_Mouse65,:);
loc_NOL_A2 = Loc_Mouse65_A2(npath_NOL_Mouse65,:);
loc_NOL_C = Loc_Mouse65_C;
loc_H_A1 = Loc_Mouse65_A1(npath_H_Mouse65,:);
loc_H_A2 = Loc_Mouse65_A2(npath_H_Mouse65,:);
loc_H_A3 = Loc_Mouse65_A3;
loc_H_A4 = Loc_Mouse65_A4;


%no objects
scale_x= .357;
scale_y= .386;
cd(strcat(root_dir,'\Mouse65\2016-02-13-H\begin1\'))
[indexH_b1_A1A2_temp,time_H_b1_A1_temp,time_H_b1_A2_temp] = behavindex_cz_v3_quadrant(loc_H_A1(1),loc_H_A1(2),loc_H_A2(1),loc_H_A2(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
[indexH_b1_A3A4_temp,time_H_b1_A3_temp,time_H_b1_A4_temp] = behavindex_cz_v3_quadrant(loc_H_A3(1),loc_H_A3(2),loc_H_A4(1),loc_H_A4(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
cd(strcat(root_dir,'\Mouse65\2016-02-13-H\begin2'))
[indexH_b2_A1A2_temp,time_H_b2_A1_temp,time_H_b2_A2_temp] = behavindex_cz_v3_quadrant(loc_H_A1(1),loc_H_A1(2),loc_H_A2(1),loc_H_A2(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
[indexH_b2_A3A4_temp,time_H_b2_A3_temp,time_H_b2_A4_temp] = behavindex_cz_v3_quadrant(loc_H_A3(1),loc_H_A3(2),loc_H_A4(1),loc_H_A4(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
cd(strcat(root_dir,'\Mouse65\2016-02-13-H\begin3'))
[indexH_b3_A1A2_temp,time_H_b3_A1_temp,time_H_b3_A2_temp] = behavindex_cz_v3_quadrant(loc_H_A1(1),loc_H_A1(2),loc_H_A2(1),loc_H_A2(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
[indexH_b3_A3A4_temp,time_H_b3_A3_temp,time_H_b3_A4_temp] = behavindex_cz_v3_quadrant(loc_H_A3(1),loc_H_A3(2),loc_H_A4(1),loc_H_A4(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);

% F
scale_x= .336;
scale_y= .359;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse65\2016-02-16-F\begin2\'))
[indexF_b2_A2A1_temp,time_F_b2_A2_temp,time_F_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse65\2016-02-16-F\begin1\'))
[indexF_b1_A2A1_temp,time_F_b1_A2_temp,time_F_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NOL
scale_x= .3365;
scale_y= .3645;
radius = [r_s_C,r_l_C;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse65\2016-02-15-NO+NL\begin2\'))
[indexOL_b2_C_A1_temp,time_OL_b2_C_temp,time_OL_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse65\2016-02-15-NO+NL\begin1\'))
[indexOL_b1_A2A1_temp,time_OL_b1_A2_temp,time_OL_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_A2(1),loc_NOL_A2(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NO
scale_x= .342;
scale_y= .38;
radius = [r_s_B,r_l_B;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse65\2016-02-19-NO\begin2\'))
[indexO_b2_B_A1_temp,time_O_b2_B_temp,time_O_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse65\2016-02-19-NO\begin1\'))
[indexO_b1_A2A1_temp,time_O_b1_A2_temp,time_O_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_A2(1),loc_NO_A2(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NL
scale_x= .332;
scale_y= .373;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse65\2016-02-17-NL\begin2\'))
[indexL_b2_A22A1_temp,time_L_b2_A22_temp,time_L_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse65\2016-02-17-NL\begin1\'))
[indexL_b1_A2A1_temp,time_L_b1_A2_temp,time_L_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A2(1),loc_NL_A2(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);

time_H_b1_A1234=[time_H_b1_A1234;time_H_b1_A1_temp time_H_b1_A2_temp time_H_b1_A3_temp time_H_b1_A4_temp];
time_H_b2_A1234=[time_H_b2_A1234;time_H_b2_A1_temp time_H_b2_A2_temp time_H_b2_A3_temp time_H_b2_A4_temp];
time_H_b3_A1234=[time_H_b3_A1234;time_H_b3_A1_temp time_H_b3_A2_temp time_H_b3_A3_temp time_H_b3_A4_temp];

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


%% Mouse 71

loc_F_A1 = Loc_Mouse71_A1(npath_F_Mouse71,:);
loc_F_A2 = Loc_Mouse71_A2(npath_F_Mouse71,:);
loc_NO_A1 = Loc_Mouse71_A1(npath_NO_Mouse71,:);
loc_NO_A2 = Loc_Mouse71_A2(npath_NO_Mouse71,:);
loc_NO_B = Loc_Mouse71_B;
loc_NL_A1 = Loc_Mouse71_A1(npath_NL_Mouse71,:);
loc_NL_A2 = Loc_Mouse71_A2(npath_NL_Mouse71,:);
loc_NL_A22 = Loc_Mouse71_A22;
loc_NOL_A1 = Loc_Mouse71_A1(npath_NOL_Mouse71,:);
loc_NOL_A2 = Loc_Mouse71_A2(npath_NOL_Mouse71,:);
loc_NOL_C = Loc_Mouse71_C;
loc_H_A1 = Loc_Mouse71_A1(npath_H_Mouse71,:);
loc_H_A2 = Loc_Mouse71_A2(npath_H_Mouse71,:);
loc_H_A3 = Loc_Mouse71_A3;
loc_H_A4 = Loc_Mouse71_A4;


%no objects
scale_x= .357;
scale_y= .386;
cd(strcat(root_dir,'\Mouse71\2016-03-12-H\begin1\'))
[indexH_b1_A1A2_temp,time_H_b1_A1_temp,time_H_b1_A2_temp] = behavindex_cz_v3_quadrant(loc_H_A1(1),loc_H_A1(2),loc_H_A2(1),loc_H_A2(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
[indexH_b1_A3A4_temp,time_H_b1_A3_temp,time_H_b1_A4_temp] = behavindex_cz_v3_quadrant(loc_H_A3(1),loc_H_A3(2),loc_H_A4(1),loc_H_A4(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
cd(strcat(root_dir,'\Mouse71\2016-03-12-H\begin2'))
[indexH_b2_A1A2_temp,time_H_b2_A1_temp,time_H_b2_A2_temp] = behavindex_cz_v3_quadrant(loc_H_A1(1),loc_H_A1(2),loc_H_A2(1),loc_H_A2(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
[indexH_b2_A3A4_temp,time_H_b2_A3_temp,time_H_b2_A4_temp] = behavindex_cz_v3_quadrant(loc_H_A3(1),loc_H_A3(2),loc_H_A4(1),loc_H_A4(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
cd(strcat(root_dir,'\Mouse71\2016-03-12-H\begin3'))
[indexH_b3_A1A2_temp,time_H_b3_A1_temp,time_H_b3_A2_temp] = behavindex_cz_v3_quadrant(loc_H_A1(1),loc_H_A1(2),loc_H_A2(1),loc_H_A2(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);
[indexH_b3_A3A4_temp,time_H_b3_A3_temp,time_H_b3_A4_temp] = behavindex_cz_v3_quadrant(loc_H_A3(1),loc_H_A3(2),loc_H_A4(1),loc_H_A4(2),radius_con,starttime_con,endtime_con,scale_x,scale_y,vel_limit);

% F
scale_x= .332;
scale_y= .37;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse71\2016-03-17-F\begin2\'))
[indexF_b2_A2A1_temp,time_F_b2_A2_temp,time_F_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse71\2016-03-17-F\begin1\'))
[indexF_b1_A2A1_temp,time_F_b1_A2_temp,time_F_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_F_A2(1),loc_F_A2(2),loc_F_A1(1),loc_F_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NOL
scale_x= .355;
scale_y= .362;
radius = [r_s_C,r_l_C;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse71\2016-03-14-NO+NL\begin2\'))
[indexOL_b2_C_A1_temp,time_OL_b2_C_temp,time_OL_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_C(1),loc_NOL_C(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse71\2016-03-14-NO+NL\begin1\'))
[indexOL_b1_A2A1_temp,time_OL_b1_A2_temp,time_OL_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NOL_A2(1),loc_NOL_A2(2),loc_NOL_A1(1),loc_NOL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NO
scale_x= .327;
scale_y= .375;
radius = [r_s_B,r_l_B;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse71\2016-03-16-NO\begin2\'))
[indexO_b2_B_A1_temp,time_O_b2_B_temp,time_O_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_B(1),loc_NO_B(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse71\2016-03-16-NO\begin1\'))
[indexO_b1_A2A1_temp,time_O_b1_A2_temp,time_O_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NO_A2(1),loc_NO_A2(2),loc_NO_A1(1),loc_NO_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
% NL
scale_x= .336;
scale_y= .369;
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse71\2016-03-18-NL\begin2\'))
[indexL_b2_A22A1_temp,time_L_b2_A22_temp,time_L_b2_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A22(1),loc_NL_A22(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);
radius = [r_s_A,r_l_A;r_s_A,r_l_A]+radius_ellipse;
cd(strcat(root_dir,'\Mouse71\2016-03-18-NL\begin1\'))
[indexL_b1_A2A1_temp,time_L_b1_A2_temp,time_L_b1_A1_temp] = behavindex_cz_v4_ellipse(loc_NL_A2(1),loc_NL_A2(2),loc_NL_A1(1),loc_NL_A1(2),radius,starttime,endtime,scale_x,scale_y,vel_limit);

time_H_b1_A1234=[time_H_b1_A1234;time_H_b1_A1_temp time_H_b1_A2_temp time_H_b1_A3_temp time_H_b1_A4_temp];
time_H_b2_A1234=[time_H_b2_A1234;time_H_b2_A1_temp time_H_b2_A2_temp time_H_b2_A3_temp time_H_b2_A4_temp];
time_H_b3_A1234=[time_H_b3_A1234;time_H_b3_A1_temp time_H_b3_A2_temp time_H_b3_A3_temp time_H_b3_A4_temp];

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

cd 'C:\DATA\Novel object\Data+code';
save(savefile);


%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stats and plotting stuff
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% savefile='20160330_behavior_discrimination_index_v5(explore_3min_10cm_vel_0_100).mat';
savefile='20160421_behavior_discrimination_index_v5(explore_3min_10cm_vel_0_100).mat';

load(savefile)

% GROUP WISE
ind = 1; % 1=index_total, 2=index_bin

meanF_b2 = mean(index_F_b2_A2A1(:,ind));
SEMF_b2 = std(index_F_b2_A2A1(:,ind))/sqrt(length(index_F_b2_A2A1(:,ind)));
meanF_b1 = mean(index_F_b1_A2A1(:,ind));
SEMF_b1 = std(index_F_b1_A2A1(:,ind))/sqrt(length(index_F_b1_A2A1(:,ind)));
% meanF_con = mean(conF_mean(:,ind));
% SEMF_con = std(conF_mean(:,ind))/sqrt(length(conF_mean(:,ind)));

meanO_b2 = mean(index_O_b2_B_A1(:,ind));
SEMO_b2 = std(index_O_b2_B_A1(:,ind))/sqrt(length(index_O_b2_B_A1(:,ind)));
meanO_b1 = mean(index_O_b1_A2A1(:,ind));
SEMO_b1 = std(index_O_b1_A2A1(:,ind))/sqrt(length(index_O_b1_A2A1(:,ind)));
% meanO_con = mean(conO_mean(:,ind));
% SEMO_con = std(conO_mean(:,ind))/sqrt(length(conO_mean(:,ind)));

meanOL_b2 = mean(index_OL_b2_C_A1(:,ind));
SEMOL_b2 = std(index_OL_b2_C_A1(:,ind))/sqrt(length(index_OL_b2_C_A1(:,ind)));
meanOL_b1 = mean(index_OL_b1_A2A1(:,ind));
SEMOL_b1 = std(index_OL_b1_A2A1(:,ind))/sqrt(length(index_OL_b1_A2A1(:,ind)));
% meanOL_con = mean(conOL_mean(:,ind));
% SEMOL_con = std(conOL_mean(:,ind))/sqrt(length(conOL_mean(:,ind)));

meanL_b2 = nanmean(index_L_b2_A22A1(:,ind));
SEML_b2 = nanstd(index_L_b2_A22A1(:,ind))/sqrt(sum(~isnan(index_L_b2_A22A1(:,ind))));
meanL_b1 = nanmean(index_L_b1_A2A1(:,ind));
SEML_b1 = nanstd(index_L_b1_A2A1(:,ind))/sqrt(sum(~isnan(index_L_b1_A2A1(:,ind))));
% meanL_con = nanmean(conL_mean(:,ind));
% SEML_con = nanstd(conL_mean(:,ind))/sqrt(sum(~isnan(conL_mean(:,ind))));


% ffa = figure('Units','normalized','Position',[0 0.1 0.5 0.5]);
% hold on
% y = [[meanF_b2;meanOL_b2;meanL_b2;meanO_b2],[meanF_con;meanOL_con;meanL_con;meanO_con]];
% errY = zeros(4,2,2);
% errY(:,:,1) = [[SEMF_b2;SEMOL_b2;SEML_b2;SEMO_b2],[SEMF_con;SEMOL_con;SEML_con;SEMO_con]];
% errY(:,:,2) = [[SEMF_b2;SEMOL_b2;SEML_b2;SEMO_b2],[SEMF_con;SEMOL_con;SEML_con;SEMO_con]];
% [b1,b2,x0] = barwitherr(errY, y);    % Plot with errorbars
% set(b1(1),'FaceColor',[180,100,180]./255);
% set(b1(2),'FaceColor',[80,120,0]./255);
% set(b2(1),'linewidth',2);
% set(b2(2),'linewidth',2);
% line([0.5,4.5],[0.5,0.5],'linewidth',1,'Color',[150,150,150]./255,'LineStyle','--');
% set(gca, 'FontSize',24);
% hold off
% xlim([0.5,4.5])
% ylim([0.3,0.8])
% set(gca, 'XTick',[1,2,3,4]);
% set(gca, 'XTickLabel',{'F','NO+NL','NL','NO'});
% set(gca, 'YTick',0.3:0.1:0.8);
% ylabel('Discrimination Index','HorizontalAlignment','center');
% legend({'Objects','No objects'},'Location','northeast')
% box off
% legend boxoff

ffa = figure('Units','normalized','Position',[0 0.1 0.5 0.5]);
y = [[meanF_b2;meanOL_b2;meanL_b2;meanO_b2],[meanF_b1;meanOL_b1;meanL_b1;meanO_b1]];
errY = zeros(4,3,2);
errY(:,:,1) = [[SEMF_b2;SEMOL_b2;SEML_b2;SEMO_b2],[SEMF_b1;SEMOL_b1;SEML_b1;SEMO_b1]];
errY(:,:,2) = [[SEMF_b2;SEMOL_b2;SEML_b2;SEMO_b2],[SEMF_b1;SEMOL_b1;SEML_b1;SEMO_b1]];
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
savefile='20160421_behavior_discrimination_index_v5(explore_3min_10cm_vel_0_100).mat';

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