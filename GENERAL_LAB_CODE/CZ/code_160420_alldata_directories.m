% B is the obj change
% C is the obj+loc change
% A' is the loc change

radius = 10;
starttime = 0;%minutes
endtime = 1;%minutes
time1 = 0;%seconds
time2 = 6;%seconds

%% Mouse30


i_Mouse30=0;

i_Mouse30=i_Mouse30+1;path_Mouse30{i_Mouse30}='C:\Data\Novel Object\Mouse30\2014-12-20-F';
scale_x= .38;
scale_y= .385;
ndirs_Mouse30(i_Mouse30)=3; % number of sessions
% csclist_Mouse30_CA1{i_Mouse30}=[1,3,4,5,6]; % only tetrodes used for power estimation
% csclist_Mouse30_CA1_neighbor{i_Mouse30}=[3,4,3,6,5]; % neighbor tetrodes
% csclist_alltt_Mouse30_CA1{i_Mouse30}=[1,3,4,5,6]; % all tetrode including tt and CSC
% csclist_alltt_Mouse30_CA1_neighbor{i_Mouse30}=[3,4,3,6,5]; % neighbor tetrodes
% csclist_Mouse30_CA3{i_Mouse30}=[9];
% csclist_Mouse30_CA3_neighbor{i_Mouse30}=[9];
% csclist_alltt_Mouse30_CA3{i_Mouse30}=[9];
% csclist_alltt_Mouse30_CA3_neighbor{i_Mouse30}=[9];
% n_CA1pyr_Rat13(i_Mouse30,1)=4; n_CA1int_Rat13(i_Mouse30,1)=0; % number of cells
% n_CA3pyr_Rat13(i_Mouse30,1)=2; n_CA3int_Rat13(i_Mouse30,1)=0;
Loc_Mouse30_A1(i_Mouse30,:)=[[168.2256,74.0425]]; Loc_Mouse30_A2(i_Mouse30,:)=[[168.2256 93.4332]];

i_Mouse30=i_Mouse30+1;path_Mouse30{i_Mouse30}='C:\Novel Object\Mouse30\2014-12-23-NO';
scale_x= .353;
scale_y= .391;
ndirs_Mouse30(i_Mouse30)=3;
% csclist_Mouse30_CA1{i_Mouse30}=[1,3,4,5,6];
% csclist_Mouse30_CA1_neighbor{i_Mouse30}=[3,4,3,6,5]; % neighbor tetrodes
% csclist_alltt_Mouse30_CA1{i_Mouse30}=[1,3,4,5,6];
% csclist_alltt_Mouse30_CA1_neighbor{i_Mouse30}=[3,4,3,6,5]; % neighbor tetrodes
% csclist_Mouse30_CA3{i_Mouse30}=[9];
% csclist_Mouse30_CA3_neighbor{i_Mouse30}=[9];
% csclist_alltt_Mouse30_CA3{i_Mouse30}=[9];
% csclist_alltt_Mouse30_CA3_neighbor{i_Mouse30}=[9];
% n_CA1pyr_Rat13(i_Mouse30,1)=5; n_CA1int_Rat13(i_Mouse30,1)=1;
% n_CA3pyr_Rat13(i_Mouse30,1)=3; n_CA3int_Rat13(i_Mouse30,1)=0;
Loc_Mouse30_A2(i_Mouse30,:)=[168.4330,76.0713]; Loc_Mouse30_A1(i_Mouse30,:)=[168.4330,95.8966];
Loc_Mouse30_B=[168.4330,76.0713];

i_Mouse30=i_Mouse30+1;path_Mouse30{i_Mouse30}='C:\Novel Object\Mouse30\2014-12-25-NO+NL';
scale_x= .354;
scale_y= .382;
ndirs_Mouse30(i_Mouse30)=3;
% csclist_Mouse30_CA1{i_Mouse30}=[1,4,5,6];
% csclist_Mouse30_CA1_neighbor{i_Mouse30}=[3,3,6,5]; % neighbor tetrodes
% csclist_alltt_Mouse30_CA1{i_Mouse30}=[1,3,4,5,6];
% csclist_alltt_Mouse30_CA1_neighbor{i_Mouse30}=[3,4,3,6,5]; % neighbor tetrodes
% csclist_Mouse30_CA3{i_Mouse30}=[9];
% csclist_Mouse30_CA3_neighbor{i_Mouse30}=[9];
% csclist_alltt_Mouse30_CA3{i_Mouse30}=[9];
% csclist_alltt_Mouse30_CA3_neighbor{i_Mouse30}=[9];
% n_CA1pyr_Rat13(i_Mouse30,1)=8; n_CA1int_Rat13(i_Mouse30,1)=0;
% n_CA3pyr_Rat13(i_Mouse30,1)=2; n_CA3int_Rat13(i_Mouse30,1)=0;
Loc_Mouse30_A1(i_Mouse30,:)=[166.8692,74.2287]; Loc_Mouse30_A2(i_Mouse30,:)=[166.8692,94.0389];
Loc_Mouse30_C=[147.0591,94.0389];

i_Mouse30=i_Mouse30+1;path_Mouse30{i_Mouse30}='C:\Novel Object\Mouse30\2014-12-21-NL';
scale_x= .358;
scale_y= .391;
ndirs_Mouse52(i_Mouse30)=3;
% csclist_Rat31_CA1{i_Rat31}=[2,3,5];
% csclist_Rat31_CA1_neighbor{i_Rat31}=[3,2,3];
% csclist_alltt_Rat31_CA1{i_Rat31}=[2,3,5];
% csclist_alltt_Rat31_CA1_neighbor{i_Rat31}=[3,2,3];
% csclist_Rat31_CA3{i_Rat31}=[7,10];
% csclist_Rat31_CA3_neighbor{i_Rat31}=[10,7];
% csclist_alltt_Rat31_CA3{i_Rat31}=[7,10];
% csclist_alltt_Rat31_CA3_neighbor{i_Rat31}=[10,7];
% n_CA1pyr_Rat31(i_Rat31,1)=10; n_CA1int_Rat31(i_Rat31,1)=1;
% n_CA3pyr_Rat31(i_Rat31,1)=2; n_CA3int_Rat31(i_Rat31,1)=0;
Loc_Mouse30_A1(i_Mouse30,:)=[167.6515,75.5989]; Loc_Mouse30_A2(i_Mouse30,:)=[167.6515,95.1588];
Loc_Mouse30_A22=[148.0916,75.5989];

i_Mouse30=i_Mouse30+1;path_Mouse30{i_Mouse30}='C:\DATA\Novel object\Mouse30\2014-12-19-H';
scale_x= .386;
scale_y= .4;
ndirs_Mouse30(i_Mouse30)=3;
Loc_Mouse30_A1(i_Mouse30,:)=[163.8708,79.9654]; Loc_Mouse30_A2(i_Mouse30,:)=[163.8708,100.0099];
Loc_Mouse30_A3=[183.9513,100.0099]; Loc_Mouse30_A4=[183.9513,79.9654];

%% Mouse52

i_Mouse52=0;

i_Mouse52=i_Mouse52+1;path_Mouse52{i_Mouse52}='C:\Novel Object\Mouse52\2015-08-15-F';
scale_x= .35;
scale_y= .38;
ndirs_Mouse52(i_Mouse52)=3;
% csclist_Mouse52_CA1{i_Mouse52}=[2,3,4,5];
% csclist_Mouse52_CA1_neighbor{i_Mouse52}=[3,2,5,4];
% csclist_alltt_Mouse52_CA1{i_Mouse52}=[2,3,4,5];
% csclist_alltt_Mouse52_CA1_neighbor{i_Mouse52}=[3,2,5,4];
% csclist_Mouse52_CA3{i_Mouse52}=[7,9];
% csclist_Mouse52_CA3_neighbor{i_Mouse52}=[9,7];
% csclist_alltt_Mouse52_CA3{i_Mouse52}=[7,9,11];
% csclist_alltt_Mouse52_CA3_neighbor{i_Mouse52}=[9,7,9];
% n_CA1pyr_Mouse52(i_Mouse52,1)=11; n_CA1int_Mouse52(i_Mouse52,1)=3;
% n_CA3pyr_Mouse52(i_Mouse52,1)=2; n_CA3int_Mouse52(i_Mouse52,1)=1;
Loc_Mouse52_A1(i_Mouse52,:)=[149.2003,79.8430]; Loc_Mouse52_A2(i_Mouse52,:)=[149.2003,99.2284];

i_Mouse52=i_Mouse52+1;path_Mouse52{i_Mouse52}='C:\Novel Object\Mouse52\2015-08-18-NO';
scale_x= .34;
scale_y= .385;
ndirs_Mouse52(i_Mouse52)=3;
% csclist_Mouse52_CA1{i_Mouse52}=[2,3,4,5];
% csclist_Mouse52_CA1_neighbor{i_Mouse52}=[3,2,5,4];
% csclist_alltt_Mouse52_CA1{i_Mouse52}=[2,3,4,5];
% csclist_alltt_Mouse52_CA1_neighbor{i_Mouse52}=[3,2,5,4];
% csclist_Mouse52_CA3{i_Mouse52}=[7,9];
% csclist_Mouse52_CA3_neighbor{i_Mouse52}=[9,7];
% csclist_alltt_Mouse52_CA3{i_Mouse52}=[7,9,10,11,12];
% csclist_alltt_Mouse52_CA3_neighbor{i_Mouse52}=[9,7,11,12,11];
% n_CA1pyr_Mouse52(i_Mouse52,1)=11; n_CA1int_Mouse52(i_Mouse52,1)=2;
% n_CA3pyr_Mouse52(i_Mouse52,1)=4; n_CA3int_Mouse52(i_Mouse52,1)=2;
Loc_Mouse52_A2(i_Mouse52,:)=[144.8489,78.9064]; Loc_Mouse52_A1(i_Mouse52,:)=[144.8489,97.9999];
Loc_Mouse52_B=[144.8489,78.9064];

i_Mouse52=i_Mouse52+1;path_Mouse52{i_Mouse52}='C:\Novel Object\Mouse52\2015-08-14-NO+NL';
scale_x= .335;
scale_y= .365;
ndirs_Mouse52(i_Mouse52)=3;
% csclist_Mouse52_CA1{i_Mouse52}=[2,3,4,5];
% csclist_Mouse52_CA1_neighbor{i_Mouse52}=[3,2,5,4];
% csclist_alltt_Mouse52_CA1{i_Mouse52}=[2,3,4,5];
% csclist_alltt_Mouse52_CA1_neighbor{i_Mouse52}=[3,2,5,4];
% csclist_Mouse52_CA3{i_Mouse52}=[7,9];
% csclist_Mouse52_CA3_neighbor{i_Mouse52}=[9,7];
% csclist_alltt_Mouse52_CA3{i_Mouse52}=[7,9,11,12];
% csclist_alltt_Mouse52_CA3_neighbor{i_Mouse52}=[9,7,12,11];
% n_CA1pyr_Mouse52(i_Mouse52,1)=12; n_CA1int_Mouse52(i_Mouse52,1)=1;
% n_CA3pyr_Mouse52(i_Mouse52,1)=3; n_CA3int_Mouse52(i_Mouse52,1)=4;
Loc_Mouse52_A1(i_Mouse52,:)=[142.6852,75.0859]; Loc_Mouse52_A2(i_Mouse52,:)=[142.6852,95.3337];
Loc_Mouse52_C=[162.9330,75.0859];


i_Mouse52=i_Mouse52+1;path_Mouse52{i_Mouse52}='C:\Novel Object\Mouse52\2015-08-16-NL';
scale_x= .4;
scale_y= .385;
ndirs_Mouse52(i_Mouse52)=3;
% csclist_Mouse52_CA1{i_Mouse52}=[2,3,5];
% csclist_Mouse52_CA1_neighbor{i_Mouse52}=[3,2,3];
% csclist_alltt_mouse52_CA1{i_Mouse52}=[2,3,5];
% csclist_alltt_Mouse52_CA1_neighbor{i_Mouse52}=[3,2,3];
% csclist_Mouse52_CA3{i_Mouse52}=[7,10];
% csclist_Mouse52_CA3_neighbor{i_Mouse52}=[10,7];
% csclist_alltt_Mouse52_CA3{i_Mouse52}=[7,10];
% csclist_alltt_Mouse52_CA3_neighbor{i_Mouse52}=[10,7];
% n_CA1pyr_Mouse52(i_Mouse52,1)=10; n_CA1int_Mouse52(i_Mouse52,1)=1;
% n_CA3pyr_Mouse52(i_Mouse52,1)=2; n_CA3int_Mouse52(i_Mouse52,1)=0;
Loc_Mouse52_A1(i_Mouse52,:)=[175.3141,81.5739]; Loc_Mouse52_A2(i_Mouse52,:)=[175.3141,100.7330];
Loc_Mouse52_A22=[194.4732,100.7330];

i_Mouse52=i_Mouse52+1;path_Mouse52{i_Mouse52}='C:\DATA\Novel object\Mouse52\2015-08-13-H';
scale_x= .359;
scale_y= .404;
ndirs_Mouse52(i_Mouse52)=3;
Loc_Mouse52_A1(i_Mouse52,:)=[152.9172,85.9643]; Loc_Mouse52_A2(i_Mouse52,:)=[152.9172,106.0010];
Loc_Mouse52_A3=[172.9539,106.0010]; Loc_Mouse52_A4=[172.9539,85.9643];


%% Mouse55


i_Mouse55=0;

i_Mouse55=i_Mouse55+1;path_Mouse55{i_Mouse55}='C:\Novel Object\Mouse55\2015-08-29-F';
scale_x= .358;
scale_y= .387;
ndirs_Mouse55(i_Mouse55)=3;
% csclist_Mouse55_CA1{i_Mouse55}=[2,3,5];
% csclist_Mouse55_CA1_neighbor{i_Mouse55}=[3,2,3];
% csclist_alltt_mouse55_CA1{i_Mouse55}=[2,3,5];
% csclist_alltt_Mouse55_CA1_neighbor{i_Mouse55}=[3,2,3];
% csclist_Mouse55_CA3{i_Mouse55}=[7,10];
% csclist_Mouse55_CA3_neighbor{i_Mouse55}=[10,7];
% csclist_alltt_Mouse55_CA3{i_Mouse55}=[7,10];
% csclist_alltt_Mouse55_CA3_neighbor{i_Mouse55}=[10,7];
% n_CA1pyr_Mouse55(i_Mouse55,1)=11; n_CA1int_Mouse55(i_Mouse55,1)=0;
% n_CA3pyr_Mouse55(i_Mouse55,1)=0; n_CA3int_Mouse55(i_Mouse55,1)=1;
Loc_Mouse55_A1(i_Mouse55,:)=[152.8730,100.4196]; Loc_Mouse55_A2(i_Mouse55,:)=[172.8500,100.4196];

i_Mouse55=i_Mouse55+1;path_Mouse55{i_Mouse55}='C:\Novel Object\Mouse55\2015-08-28-NO';
scale_x= .51;
scale_y= .38;
ndirs_Mouse55(i_Mouse55)=3;
% csclist_Mouse55_CA1{i_Mouse55}=[2,3,5];
% csclist_Mouse55_CA1_neighbor{i_Mouse55}=[3,2,3];
% csclist_alltt_mouse55_CA1{i_Mouse55}=[2,3,5];
% csclist_alltt_Mouse55_CA1_neighbor{i_Mouse55}=[3,2,3];
% csclist_Mouse55_CA3{i_Mouse55}=[7,10];
% csclist_Mouse55_CA3_neighbor{i_Mouse55}=[10,7];
% csclist_alltt_Mouse55_CA3{i_Mouse55}=[7,10];
% csclist_alltt_Mouse55_CA3_neighbor{i_Mouse55}=[10,7];
% n_CA1pyr_Mouse55(i_Mouse55,1)=13; n_CA1int_Mouse55(i_Mouse55,1)=0;
% n_CA3pyr_Mouse55(i_Mouse55,1)=0; n_CA3int_Mouse55(i_Mouse55,1)=1;
Loc_Mouse55_A2(i_Mouse55,:)=[230.7467,95.1616]; Loc_Mouse55_A1(i_Mouse55,:)=[250.4440,95.1616];
Loc_Mouse55_B=[230.7467,95.1616];


i_Mouse55=i_Mouse55+1;path_Mouse55{i_Mouse55}='C:\Novel Object\Mouse55\2015-08-26-NO+NL';
scale_x= .363;
scale_y= .391;
ndirs_Mouse55(i_Mouse55)=3;
% csclist_Mouse55_CA1{i_Mouse55}=[2,3,5];
% csclist_Mouse55_CA1_neighbor{i_Mouse55}=[3,2,3];
% csclist_alltt_mouse55_CA1{i_Mouse55}=[2,3,5];
% csclist_alltt_Mouse55_CA1_neighbor{i_Mouse55}=[3,2,3];
% csclist_Mouse55_CA3{i_Mouse55}=[7,10];
% csclist_Mouse55_CA3_neighbor{i_Mouse55}=[10,7];
% csclist_alltt_Mouse55_CA3{i_Mouse55}=[7,10];
% csclist_alltt_Mouse55_CA3_neighbor{i_Mouse55}=[10,7];
% n_CA1pyr_Mouse55(i_Mouse55,1)=15; n_CA1int_Mouse55(i_Mouse55,1)=1;
% n_CA3pyr_Mouse55(i_Mouse55,1)=1; n_CA3int_Mouse55(i_Mouse55,1)=0;
Loc_Mouse55_A1(i_Mouse55,:)=[154.4677,102.6185]; Loc_Mouse55_A2(i_Mouse55,:)=[174.4950,102.6185];
Loc_Mouse55_C=[154.4677,82.5911];

i_Mouse55=i_Mouse55+1;path_Mouse55{i_Mouse55}='C:\Novel Object\Mouse55\2015-08-30-NL';
scale_x= .347;
scale_y= .368;
ndirs_Mouse55(i_Mouse55)=3;
% csclist_Mouse55_CA1{i_Mouse55}=[2,3,5];
% csclist_Mouse55_CA1_neighbor{i_Mouse55}=[3,2,3];
% csclist_alltt_mouse55_CA1{i_Mouse55}=[2,3,5];
% csclist_alltt_Mouse55_CA1_neighbor{i_Mouse55}=[3,2,3];
% csclist_Mouse55_CA3{i_Mouse55}=[7,10];
% csclist_Mouse55_CA3_neighbor{i_Mouse55}=[10,7];
% csclist_alltt_Mouse55_CA3{i_Mouse55}=[7,10];
% csclist_alltt_Mouse55_CA3_neighbor{i_Mouse55}=[10,7];
% n_CA1pyr_Mouse55(i_Mouse55,1)=10; n_CA1int_Mouse55(i_Mouse55,1)=1;
% n_CA3pyr_Mouse55(i_Mouse55,1)=2; n_CA3int_Mouse55(i_Mouse55,1)=0;
Loc_Mouse55_A1(i_Mouse55,:)=[148.4445,96.5049]; Loc_Mouse55_A2(i_Mouse55,:)=[168.4472,96.5049];
Loc_Mouse55_A22=[168.4472,76.5022];

i_Mouse55=i_Mouse55+1;path_Mouse55{i_Mouse55}='C:\DATA\Novel object\Mouse55\2015-08-24-H';
scale_x= .357;
scale_y= .375;
ndirs_Mouse55(i_Mouse55)=3;
Loc_Mouse55_A1(i_Mouse55,:)=[152.1987,79.1361]; Loc_Mouse55_A2(i_Mouse55,:)=[152.1987,99.1768];
Loc_Mouse55_A3=[172.2394,99.1768]; Loc_Mouse55_A4=[172.2394,79.1361];

%% Mouse56

i_Mouse56=0;

i_Mouse56=i_Mouse56+1;path_Mouse56{i_Mouse56}='C:\Novel Object\Mouse56\2015-09-26-F';
scale_x= .338;
scale_y= .38;
ndirs_Mouse56(i_Mouse56)=3;
% % csclist_Rat44_CA1{i_Rat44}=[5];
% % csclist_Rat44_CA1_neighbor{i_Rat44}=[6];
% csclist_mouse56_CA1{i_Mouse56}=[6];
% csclist_Mouse56_CA1_neighbor{i_Mouse56}=[5];
% csclist_alltt_Mouse56_CA1{i_Mouse56}=[5];
% csclist_alltt_Mouse56_CA1_neighbor{i_Mouse56}=[6];
% % csclist_Rat44_CA3{i_Rat44}=[1,4,7,9];
% % csclist_Rat44_CA3_neighbor{i_Rat44}=[4,1,9,7];
% csclist_Mouse56_CA3{i_Mouse56}=[1];
% csclist_Mouse56_CA3_neighbor{i_Mouse56}=[4];
% csclist_alltt_Mouse56_CA3{i_Mouse56}=[1,4,7,9];
% csclist_alltt_Mouse56_CA3_neighbor{i_Mouse56}=[4,1,9,7];
% n_CA1pyr_Mouse56(i_Mouse56,1)=3; n_CA1int_Mouse56(i_Mouse56,1)=0;
% n_CA3pyr_Mouse56(i_Mouse56,1)=6; n_CA3int_Mouse56(i_Mouse56,1)=0;
Loc_Mouse56_A1(i_Mouse56,:)=[163.5639,78.4030]; Loc_Mouse56_A2(i_Mouse56,:)=[143.5579,78.4030];

i_Mouse56=i_Mouse56+1;path_Mouse56{i_Mouse56}='C:\Novel Object\Mouse56\2015-09-29-NO';
scale_x= .343;
scale_y= .404;
ndirs_Mouse56(i_Mouse56)=3;
% % csclist_Rat44_CA1{i_Rat44}=[5,6];
% % csclist_Rat44_CA1_neighbor{i_Rat44}=[6,5];
% csclist_mouse56_CA1{i_Mouse56}=[6];
% csclist_Mouse56_CA1_neighbor{i_Mouse56}=[5];
% csclist_alltt_Mouse56_CA1{i_Mouse56}=[5,6];
% csclist_alltt_Mouse56_CA1_neighbor{i_Mouse56}=[6,5];
% % csclist_Rat44_CA3{i_Rat44}=[1,4,7,9];
% % csclist_Rat44_CA3_neighbor{i_Rat44}=[4,1,9,7];
% csclist_Mouse56_CA3{i_Mouse56}=[1];
% csclist_Mouse56_CA3_neighbor{i_Mouse56}=[4];
% csclist_alltt_Mouse56_CA3{i_Mouse56}=[1,4,7,9];
% csclist_alltt_Mouse56_CA3_neighbor{i_Mouse56}=[4,1,9,7];
% n_CA1pyr_Mouse56(i_Mouse56,1)=4; n_CA1int_Mouse56(i_Mouse56,1)=1;
% n_CA3pyr_Mouse56(i_Mouse56,1)=8; n_CA3int_Mouse56(i_Mouse56,1)=0;
Loc_Mouse56_A1(i_Mouse56,:)=[167.0000,82.7565]; Loc_Mouse56_A2(i_Mouse56,:)=[146.9761,82.7565];
Loc_Mouse56_B=[146.9761,82.7565];

i_Mouse56=i_Mouse56+1;path_Mouse56{i_Mouse56}='C:\Novel Object\Mouse56\2015-09-27-NO+NL';
scale_x= .355;
scale_y= .393;
ndirs_Mouse56(i_Mouse56)=3;
% % csclist_Rat44_CA1{i_Rat44}=[5,6];
% % csclist_Rat44_CA1_neighbor{i_Rat44}=[6,5];
% csclist_mouse56_CA1{i_Mouse56}=[6];
% csclist_Mouse56_CA1_neighbor{i_Mouse56}=[5];
% csclist_alltt_Mouse56_CA1{i_Mouse56}=[5,6];
% csclist_alltt_Mouse56_CA1_neighbor{i_Mouse56}=[6,5];
% % csclist_Rat44_CA3{i_Rat44}=[1,4,7,9];
% % csclist_Rat44_CA3_neighbor{i_Rat44}=[4,1,9,7];
% csclist_Mouse56_CA3{i_Mouse56}=[1];
% csclist_Mouse56_CA3_neighbor{i_Mouse56}=[4];
% csclist_alltt_Mouse56_CA3{i_Mouse56}=[1,4,7,9];
% csclist_alltt_Mouse56_CA3_neighbor{i_Mouse56}=[4,1,9,7];
% n_CA1pyr_Mouse56(i_Mouse56,1)=6; n_CA1int_Mouse56(i_Mouse56,1)=1;
% n_CA3pyr_Mouse56(i_Mouse56,1)=7; n_CA3int_Mouse56(i_Mouse56,1)=0;
Loc_Mouse56_A1(i_Mouse56,:)=[172.1448,81.5173]; Loc_Mouse56_A2(i_Mouse56,:)=[152.1132,81.5173];
Loc_Mouse56_C=[152.1132,101.5488];

i_Mouse56=i_Mouse56+1;path_Mouse56{i_Mouse56}='C:\Novel Object\Mouse56\2015-10-01-NL';
scale_x= .38;
scale_y= .411;
ndirs_Mouse56(i_Mouse56)=3;
% % csclist_Rat44_CA1{i_Rat44}=[5,6];
% % csclist_Rat44_CA1_neighbor{i_Rat44}=[6,5];
% csclist_mouse56_CA1{i_Mouse56}=[6];
% csclist_Mouse56_CA1_neighbor{i_Mouse56}=[5];
% csclist_alltt_Mouse56_CA1{i_Mouse56}=[5,6];
% csclist_alltt_Mouse56_CA1_neighbor{i_Mouse56}=[6,5];
% % csclist_Rat44_CA3{i_Rat44}=[1,4,7,9];
% % csclist_Rat44_CA3_neighbor{i_Rat44}=[4,1,9,7];
% csclist_Mouse56_CA3{i_Mouse56}=[1];
% csclist_Mouse56_CA3_neighbor{i_Mouse56}=[4];
% csclist_alltt_Mouse56_CA3{i_Mouse56}=[1,4,7,9];
% csclist_alltt_Mouse56_CA3_neighbor{i_Mouse56}=[4,1,9,7];
% n_CA1pyr_Mouse56(i_Mouse56,1)=4; n_CA1int_Mouse56(i_Mouse56,1)=0;
% n_CA3pyr_Mouse56(i_Mouse56,1)=8; n_CA3int_Mouse56(i_Mouse56,1)=1;
Loc_Mouse56_A1(i_Mouse56,:)=[181.9696,84.8682]; Loc_Mouse56_A2(i_Mouse56,:)=[161.9517,84.8682];
Loc_Mouse56_A22=[181.9696,104.8862];

i_Mouse56=i_Mouse56+1;path_Mouse56{i_Mouse56}='C:\DATA\Novel object\Mouse56\2015-09-25-H';
scale_x= .33;
scale_y= .365;
ndirs_Mouse56(i_Mouse56)=3;
Loc_Mouse56_A1(i_Mouse56,:)=[139.6615,73.9982]; Loc_Mouse56_A2(i_Mouse56,:)=[139.6615,94.0238];
Loc_Mouse56_A3=[159.6871,94.0238]; Loc_Mouse56_A4=[159.6871,73.9982];

%% Mouse65

i_Mouse65=0;

i_Mouse65=i_Mouse65+1;path_Mouse65{i_Mouse65}='C:\Novel Object\Mouse65\2016-02-16-F';
scale_x= .336;
scale_y= .359;
ndirs_Mouse65(i_Mouse65)=3;
% csclist_Mouse65_CA1{i_Mouse65}=[1,2];
% csclist_Mouse65_CA1_neighbor{i_Mouse65}=[2,1];
% csclist_alltt_Mouse65_CA1{i_Mouse65}=[1,2];
% csclist_alltt_Mouse65_CA1_neighbor{i_Mouse65}=[2,1];
% csclist_Mouse65_CA3{i_Mouse65}=[7,11,12];
% csclist_Mouse65_CA3_neighbor{i_Mouse65}=[6,12,11];
% csclist_alltt_Mouse65_CA3{i_Mouse65}=[7,11,12];
% csclist_alltt_Mouse65_CA3_neighbor{i_Mouse65}=[6,12,11];
% n_CA1pyr_Mouse65(i_Mouse65,1)=1; n_CA1int_Mouse65(i_Mouse65,1)=1;
% n_CA3pyr_Mouse65(i_Mouse65,1)=8; n_CA3int_Mouse65(i_Mouse65,1)=1;
Loc_Mouse65_A1(i_Mouse65,:)=[162.0842,75.3556]; Loc_Mouse65_A2(i_Mouse65,:)=[162.0842,95.3868];

i_Mouse65=i_Mouse65+1;path_Mouse65{i_Mouse65}='C:\Novel Object\Mouse65\2016-02-19-NO';
scale_x= .342;
scale_y= .38;
ndirs_Mouse65(i_Mouse65)=3;
% csclist_Mouse65_CA1{i_Mouse65}=[1,2];
% csclist_Mouse65_CA1_neighbor{i_Mouse65}=[2,1];
% csclist_alltt_Mouse65_CA1{i_Mouse65}=[1,2];
% csclist_alltt_Mouse65_CA1_neighbor{i_Mouse65}=[2,1];
% csclist_Mouse65_CA3{i_Mouse65}=[6,7,11,12];
% csclist_Mouse65_CA3_neighbor{i_Mouse65}=[7,6,12,11];
% csclist_alltt_Mouse65_CA3{i_Mouse65}=[6,7,11,12];
% csclist_alltt_Mouse65_CA3_neighbor{i_Mouse65}=[7,6,12,11];
% n_CA1pyr_Mouse65(i_Mouse65,1)=1; n_CA1int_Mouse65(i_Mouse65,1)=1;
% n_CA3pyr_Mouse65(i_Mouse65,1)=10; n_CA3int_Mouse65(i_Mouse65,1)=0;
Loc_Mouse65_A1(i_Mouse65,:)=[164.1212,80.6009]; Loc_Mouse65_A2(i_Mouse65,:)=[164.1212,100.6438];
Loc_Mouse65_B=[164.1212,100.6438];

i_Mouse65=i_Mouse65+1;path_Mouse65{i_Mouse65}='C:\Novel Object\Mouse65\2016-02-15-NO+NL';
scale_x= .3365;
scale_y= .3645;
ndirs_Mouse65(i_Mouse65)=3;
% csclist_Mouse65_CA1{i_Mouse65}=[1,2];
% csclist_Mouse65_CA1_neighbor{i_Mouse65}=[2,1];
% csclist_alltt_Mouse65_CA1{i_Mouse65}=[1,2];
% csclist_alltt_Mouse65_CA1_neighbor{i_Mouse65}=[2,1];
% csclist_Mouse65_CA3{i_Mouse65}=[6,7,11,12];
% csclist_Mouse65_CA3_neighbor{i_Mouse65}=[7,6,12,11];
% csclist_alltt_Mouse65_CA3{i_Mouse65}=[6,7,11,12];
% csclist_alltt_Mouse65_CA3_neighbor{i_Mouse65}=[7,6,12,11];
% n_CA1pyr_Mouse65(i_Mouse65,1)=3; n_CA1int_Mouse65(i_Mouse65,1)=1;
% n_CA3pyr_Mouse65(i_Mouse65,1)=9; n_CA3int_Mouse65(i_Mouse65,1)=1;
Loc_Mouse65_A1(i_Mouse65,:)=[161.7465,75.9827]; Loc_Mouse65_A2(i_Mouse65,:)=[161.7465,96.0117];
Loc_Mouse65_C=[141.7176,75.9827];

i_Mouse65=i_Mouse65+1;path_Mouse65{i_Mouse65}='C:\Novel Object\Mouse65\2016-02-17-NL';
scale_x= .332;
scale_y= .373;
ndirs_Mouse65(i_Mouse65)=3;
% csclist_Mouse65_CA1{i_Mouse65}=[1,2];
% csclist_Mouse65_CA1_neighbor{i_Mouse65}=[2,1];
% csclist_alltt_Mouse65_CA1{i_Mouse65}=[1,2];
% csclist_alltt_Mouse65_CA1_neighbor{i_Mouse65}=[2,1];
% csclist_Mouse65_CA3{i_Mouse65}=[6,7,11,12];
% csclist_Mouse65_CA3_neighbor{i_Mouse65}=[7,6,12,11];
% csclist_alltt_Mouse65_CA3{i_Mouse65}=[6,7,11,12];
% csclist_alltt_Mouse65_CA3_neighbor{i_Mouse65}=[7,6,12,11];
% n_CA1pyr_Mouse65(i_Mouse65,1)=1; n_CA1int_Mouse65(i_Mouse65,1)=1;
% n_CA3pyr_Mouse65(i_Mouse65,1)=10; n_CA3int_Mouse65(i_Mouse65,1)=0;
Loc_Mouse65_A1(i_Mouse65,:)=[159.4372,78.6909]; Loc_Mouse65_A2(i_Mouse65,:)=[159.4372,98.7238];
Loc_Mouse65_A22=[139.4043,98.7238];

i_Mouse65=i_Mouse65+1;path_Mouse65{i_Mouse65}='C:\DATA\Novel object\Mouse65\2016-02-13-H';
scale_x= .357;
scale_y= .386;
ndirs_Mouse65(i_Mouse65)=3;
Loc_Mouse65_A1(i_Mouse65,:)=[150.9572,81.5557]; Loc_Mouse65_A2(i_Mouse65,:)=[150.9572,101.5816];
Loc_Mouse65_A3=[170.9831,101.5816]; Loc_Mouse65_A4=[170.9831,81.5557];

%% Mouse71


i_Mouse71=0;

i_Mouse71=i_Mouse71+1;path_mouse71{i_Mouse71}='C:\Novel Object\Mouse71\2016-03-17-F';
scale_x= .332;
scale_y= .37;
ndirs_Mouse71(i_Mouse71)=3;
% csclist_Mouse71_CA1{i_Mouse71}=[3,5,6];
% csclist_Mouse71_CA1_neighbor{i_Mouse71}=[5,6,5];
% csclist_alltt_Mouse71_CA1{i_Mouse71}=[3,5,6];
% csclist_alltt_Mouse71_CA1_neighbor{i_Mouse71}=[5,6,5];
% csclist_Mouse71_CA3{i_Mouse71}=[11,12];
% csclist_Mouse71_CA3_neighbor{i_Mouse71}=[12,11];
% csclist_alltt_Mouse71_CA3{i_Mouse71}=[11,12];
% csclist_alltt_Mouse71_CA3_neighbor{i_Mouse71}=[12,11];
% n_CA1pyr_Mouse71(i_Mouse71,1)=6; n_CA1int_Mouse71(i_Mouse71,1)=0;
% n_CA3pyr_Mouse71(i_Mouse71,1)=5; n_CA3int_Mouse71(i_Mouse71,1)=0;
Loc_Mouse71_A1(i_Mouse71,:)=[139.9374,98.0562]; Loc_Mouse71_A2(i_Mouse71,:)=[159.9651,98.0562];

i_Mouse71=i_Mouse71+1;path_mouse71{i_Mouse71}='C:\Novel Object\Mouse71\2016-03-16-NO';
scale_x= .327;
scale_y= .375;
ndirs_Mouse71(i_Mouse71)=3;
% csclist_Mouse71_CA1{i_Mouse71}=[3,5];
% csclist_Mouse71_CA1_neighbor{i_Mouse71}=[5,3];
% csclist_alltt_Mouse71_CA1{i_Mouse71}=[3,5];
% csclist_alltt_Mouse71_CA1_neighbor{i_Mouse71}=[5,3];
% csclist_Mouse71_CA3{i_Mouse71}=[11,12];
% csclist_Mouse71_CA3_neighbor{i_Mouse71}=[12,11];
% csclist_alltt_Mouse71_CA3{i_Mouse71}=[11,12];
% csclist_alltt_Mouse71_CA3_neighbor{i_Mouse71}=[12,11];
% n_CA1pyr_Mouse71(i_Mouse71,1)=7; n_CA1int_Mouse71(i_Mouse71,1)=0;
% n_CA3pyr_Mouse71(i_Mouse71,1)=7; n_CA3int_Mouse71(i_Mouse71,1)=0;
Loc_Mouse71_A2(i_Mouse71,:)=[137.8724,98.5154]; Loc_Mouse71_A1(i_Mouse71,:)=[157.8773,98.5154];
Loc_Mouse71_B=[137.8724,98.5154];

i_Mouse71=i_Mouse71+1;path_mouse71{i_Mouse71}='C:\Novel Object\Mouse71\2016-03-14-NO+NL';
scale_x= .355;
scale_y= .362;
ndirs_Mouse71(i_Mouse71)=3;
% csclist_Mouse71_CA1{i_Mouse71}=[3,5];
% csclist_Mouse71_CA1_neighbor{i_Mouse71}=[5,3];
% csclist_alltt_Mouse71_CA1{i_Mouse71}=[3,5];
% csclist_alltt_Mouse71_CA1_neighbor{i_Mouse71}=[5,3];
% csclist_Mouse71_CA3{i_Mouse71}=[11,12];
% csclist_Mouse71_CA3_neighbor{i_Mouse71}=[12,11];
% csclist_alltt_Mouse71_CA3{i_Mouse71}=[11,12];
% csclist_alltt_Mouse71_CA3_neighbor{i_Mouse71}=[12,11];
% n_CA1pyr_Mouse71(i_Mouse71,1)=6; n_CA1int_Mouse71(i_Mouse71,1)=1;
% n_CA3pyr_Mouse71(i_Mouse71,1)=8; n_CA3int_Mouse71(i_Mouse71,1)=0;
Loc_Mouse71_A1(i_Mouse71,:)=[150.4934,96.8680]; Loc_Mouse71_A2(i_Mouse71,:)=[170.4890,96.8680];
Loc_Mouse71_C=[170.4890,76.8722];

i_Mouse71=i_Mouse71+1;path_mouse71{i_Mouse71}='C:\Novel Object\Mouse71\2016-03-18-NL';
scale_x= .336;
scale_y= .369;
ndirs_Mouse71(i_Mouse71)=3;
% csclist_Mouse71_CA1{i_Mouse71}=[3,5];
% csclist_Mouse71_CA1_neighbor{i_Mouse71}=[5,3];
% csclist_alltt_Mouse71_CA1{i_Mouse71}=[3,5];
% csclist_alltt_Mouse71_CA1_neighbor{i_Mouse71}=[5,3];
% csclist_Mouse71_CA3{i_Mouse71}=[11,12];
% csclist_Mouse71_CA3_neighbor{i_Mouse71}=[12,11];
% csclist_alltt_Mouse71_CA3{i_Mouse71}=[11,12];
% csclist_alltt_Mouse71_CA3_neighbor{i_Mouse71}=[12,11];
% n_CA1pyr_Mouse71(i_Mouse71,1)=3; n_CA1int_Mouse71(i_Mouse71,1)=1;
% n_CA3pyr_Mouse71(i_Mouse71,1)=6; n_CA3int_Mouse71(i_Mouse71,1)=0;
Loc_Mouse71_A1(i_Mouse71,:)=[141.4441,97.6228]; Loc_Mouse71_A2(i_Mouse71,:)=[161.4496,97.6228];
Loc_Mouse71_A22=[141.4441,77.6173];

i_Mouse71=i_Mouse71+1;path_Mouse71{i_Mouse71}='C:\DATA\Novel object\Mouse71\2016-03-12-H';
scale_x= .357;
scale_y= .386;
ndirs_Mouse71(i_Mouse71)=3;
Loc_Mouse71_A1(i_Mouse71,:)=[150.9572,81.5557]; Loc_Mouse71_A2(i_Mouse71,:)=[150.9572,101.5816];
Loc_Mouse71_A3=[170.9831,101.5816]; Loc_Mouse71_A4=[170.9831,81.5557];

