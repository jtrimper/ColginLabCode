% B is the obj change
% C is the obj+loc change
% A' is the loc change

radius = 10;
starttime = 0;%minutes
endtime = 3;%minutes
time1 = 0;%seconds
time2 = 6;%seconds

%% Mouse30
scale_Mouse30_x = .35;
scale_Mouse30_y = .38;

i_Mouse30=0;

i_Mouse30=i_Mouse30+1;path_Rat13{i_Mouse30}='C:\Data\Novel Object\Mouse30\2014-12-20-F';
ndirs_Mouse30(i_Mouse30)=3; % number of sessions
csclist_Mouse30_CA1{i_Mouse30}=[1,3,4,5,6]; % only tetrodes used for power estimation
csclist_Mouse30_CA1_neighbor{i_Mouse30}=[3,4,3,6,5]; % neighbor tetrodes
csclist_alltt_Mouse30_CA1{i_Mouse30}=[1,3,4,5,6]; % all tetrode including tt and CSC
csclist_alltt_Mouse30_CA1_neighbor{i_Mouse30}=[3,4,3,6,5]; % neighbor tetrodes
csclist_Mouse30_CA3{i_Mouse30}=[9];
csclist_Mouse30_CA3_neighbor{i_Mouse30}=[9];
csclist_alltt_Mouse30_CA3{i_Mouse30}=[9];
csclist_alltt_Mouse30_CA3_neighbor{i_Mouse30}=[9];
n_CA1pyr_Rat13(i_Mouse30,1)=4; n_CA1int_Rat13(i_Mouse30,1)=0; % number of cells
n_CA3pyr_Rat13(i_Mouse30,1)=2; n_CA3int_Rat13(i_Mouse30,1)=0;
Loc_Mouse30_A1(i_Mouse30,:)=[191.3343,75.3801]; Loc_Mouse30_A2(i_Mouse30,:)=[190.8339,107.1930];

i_Mouse30=i_Mouse30+1;path_Rat13{i_Mouse30}='C:\Novel Object\Rat13\2012-02-02-NO';
ndirs_Mouse30(i_Mouse30)=3;
csclist_Mouse30_CA1{i_Mouse30}=[1,3,4,5,6];
csclist_Mouse30_CA1_neighbor{i_Mouse30}=[3,4,3,6,5]; % neighbor tetrodes
csclist_alltt_Mouse30_CA1{i_Mouse30}=[1,3,4,5,6];
csclist_alltt_Mouse30_CA1_neighbor{i_Mouse30}=[3,4,3,6,5]; % neighbor tetrodes
csclist_Mouse30_CA3{i_Mouse30}=[9];
csclist_Mouse30_CA3_neighbor{i_Mouse30}=[9];
csclist_alltt_Mouse30_CA3{i_Mouse30}=[9];
csclist_alltt_Mouse30_CA3_neighbor{i_Mouse30}=[9];
n_CA1pyr_Rat13(i_Mouse30,1)=5; n_CA1int_Rat13(i_Mouse30,1)=1;
n_CA3pyr_Rat13(i_Mouse30,1)=3; n_CA3int_Rat13(i_Mouse30,1)=0;
Loc_Mouse30_A1(i_Mouse30,:)=[189.8702,75.9527]; Loc_Mouse30_A2(i_Mouse30,:)=[190.3484,109.3521];
Loc_Rat13_B=[190.3484,109.3521];

i_Mouse30=i_Mouse30+1;path_Rat13{i_Mouse30}='C:\Novel Object\Mouse30\2014-12-25-NO+NL';
ndirs_Mouse30(i_Mouse30)=3;
csclist_Mouse30_CA1{i_Mouse30}=[1,4,5,6];
csclist_Mouse30_CA1_neighbor{i_Mouse30}=[3,3,6,5]; % neighbor tetrodes
csclist_alltt_Mouse30_CA1{i_Mouse30}=[1,3,4,5,6];
csclist_alltt_Mouse30_CA1_neighbor{i_Mouse30}=[3,4,3,6,5]; % neighbor tetrodes
csclist_Mouse30_CA3{i_Mouse30}=[9];
csclist_Mouse30_CA3_neighbor{i_Mouse30}=[9];
csclist_alltt_Mouse30_CA3{i_Mouse30}=[9];
csclist_alltt_Mouse30_CA3_neighbor{i_Mouse30}=[9];
n_CA1pyr_Rat13(i_Mouse30,1)=8; n_CA1int_Rat13(i_Mouse30,1)=0;
n_CA3pyr_Rat13(i_Mouse30,1)=2; n_CA3int_Rat13(i_Mouse30,1)=0;
Loc_Mouse30_A1(i_Mouse30,:)=[168.4406,172.1367]; Loc_Mouse30_A2(i_Mouse30,:)=[168.4406,151.2789];
Loc_Mouse30_C=[147.5829,151.2789];

%% Rat17
scale_Rat17_x = .37;
scale_Rat17_y = .40;

i_Rat17=0;

i_Rat17=i_Rat17+1;path_Rat17{i_Rat17}='C:\Novel Object\Rat17\2012-06-17-F';
ndirs_Rat17(i_Rat17)=3;
csclist_Rat17_CA1{i_Rat17}=[2,3,4,5];
csclist_Rat17_CA1_neighbor{i_Rat17}=[3,2,5,4];
csclist_alltt_Rat17_CA1{i_Rat17}=[2,3,4,5];
csclist_alltt_Rat17_CA1_neighbor{i_Rat17}=[3,2,5,4];
csclist_Rat17_CA3{i_Rat17}=[7,9];
csclist_Rat17_CA3_neighbor{i_Rat17}=[9,7];
csclist_alltt_Rat17_CA3{i_Rat17}=[7,9,11];
csclist_alltt_Rat17_CA3_neighbor{i_Rat17}=[9,7,9];
n_CA1pyr_Rat17(i_Rat17,1)=11; n_CA1int_Rat17(i_Rat17,1)=3;
n_CA3pyr_Rat17(i_Rat17,1)=2; n_CA3int_Rat17(i_Rat17,1)=1;
Loc_Rat17_A1(i_Rat17,:)=[155.4831,103.2791]; Loc_Rat17_A2(i_Rat17,:)=[155.6043,70.7978];

i_Rat17=i_Rat17+1;path_Rat17{i_Rat17}='C:\Novel Object\Rat17\2012-06-18-NO+NL';
ndirs_Rat17(i_Rat17)=3;
csclist_Rat17_CA1{i_Rat17}=[2,3,4,5];
csclist_Rat17_CA1_neighbor{i_Rat17}=[3,2,5,4];
csclist_alltt_Rat17_CA1{i_Rat17}=[2,3,4,5];
csclist_alltt_Rat17_CA1_neighbor{i_Rat17}=[3,2,5,4];
csclist_Rat17_CA3{i_Rat17}=[7,9];
csclist_Rat17_CA3_neighbor{i_Rat17}=[9,7];
csclist_alltt_Rat17_CA3{i_Rat17}=[7,9,11,12];
csclist_alltt_Rat17_CA3_neighbor{i_Rat17}=[9,7,12,11];
n_CA1pyr_Rat17(i_Rat17,1)=12; n_CA1int_Rat17(i_Rat17,1)=1;
n_CA3pyr_Rat17(i_Rat17,1)=3; n_CA3int_Rat17(i_Rat17,1)=4;
Loc_Rat17_A1(i_Rat17,:)=[150.5090,98.4322]; Loc_Rat17_A2(i_Rat17,:)=[150.5090,67.9224];
Loc_Rat17_C=[180.0553,98.2018];

i_Rat17=i_Rat17+1;path_Rat17{i_Rat17}='C:\Novel Object\Rat17\2012-06-19-NO';
ndirs_Rat17(i_Rat17)=3;
csclist_Rat17_CA1{i_Rat17}=[2,3,4,5];
csclist_Rat17_CA1_neighbor{i_Rat17}=[3,2,5,4];
csclist_alltt_Rat17_CA1{i_Rat17}=[2,3,4,5];
csclist_alltt_Rat17_CA1_neighbor{i_Rat17}=[3,2,5,4];
csclist_Rat17_CA3{i_Rat17}=[7,9];
csclist_Rat17_CA3_neighbor{i_Rat17}=[9,7];
csclist_alltt_Rat17_CA3{i_Rat17}=[7,9,10,11,12];
csclist_alltt_Rat17_CA3_neighbor{i_Rat17}=[9,7,11,12,11];
n_CA1pyr_Rat17(i_Rat17,1)=11; n_CA1int_Rat17(i_Rat17,1)=2;
n_CA3pyr_Rat17(i_Rat17,1)=4; n_CA3int_Rat17(i_Rat17,1)=2;
Loc_Rat17_A1(i_Rat17,:)=[150.6961,96.9689]; Loc_Rat17_A2(i_Rat17,:)=[150.6961,66.1708];
Loc_Rat17_B=[150.6961,66.1708];

%% Rat31
scale_Rat31_x = .28;
scale_Rat31_y = .36;

i_Rat31=0;

i_Rat31=i_Rat31+1;path_Rat31{i_Rat31}='C:\Novel Object\Rat31\2014-01-04-F';
ndirs_Rat31(i_Rat31)=3;
csclist_Rat31_CA1{i_Rat31}=[2,3,5];
csclist_Rat31_CA1_neighbor{i_Rat31}=[3,2,3];
csclist_alltt_Rat31_CA1{i_Rat31}=[2,3,5];
csclist_alltt_Rat31_CA1_neighbor{i_Rat31}=[3,2,3];
csclist_Rat31_CA3{i_Rat31}=[7,10];
csclist_Rat31_CA3_neighbor{i_Rat31}=[10,7];
csclist_alltt_Rat31_CA3{i_Rat31}=[7,10];
csclist_alltt_Rat31_CA3_neighbor{i_Rat31}=[10,7];
n_CA1pyr_Rat31(i_Rat31,1)=11; n_CA1int_Rat31(i_Rat31,1)=0;
n_CA3pyr_Rat31(i_Rat31,1)=0; n_CA3int_Rat31(i_Rat31,1)=1;
Loc_Rat31_A1(i_Rat31,:)=[88.1797,85.1312]; Loc_Rat31_A2(i_Rat31,:)=[87.9032,114.6939];

i_Rat31=i_Rat31+1;path_Rat31{i_Rat31}='C:\Novel Object\Rat31\2014-01-05-NO';
ndirs_Rat31(i_Rat31)=3;
csclist_Rat31_CA1{i_Rat31}=[2,3,5];
csclist_Rat31_CA1_neighbor{i_Rat31}=[3,2,3];
csclist_alltt_Rat31_CA1{i_Rat31}=[2,3,5];
csclist_alltt_Rat31_CA1_neighbor{i_Rat31}=[3,2,3];
csclist_Rat31_CA3{i_Rat31}=[7,10];
csclist_Rat31_CA3_neighbor{i_Rat31}=[10,7];
csclist_alltt_Rat31_CA3{i_Rat31}=[7,10];
csclist_alltt_Rat31_CA3_neighbor{i_Rat31}=[10,7];
n_CA1pyr_Rat31(i_Rat31,1)=13; n_CA1int_Rat31(i_Rat31,1)=0;
n_CA3pyr_Rat31(i_Rat31,1)=0; n_CA3int_Rat31(i_Rat31,1)=1;
Loc_Rat31_A1(i_Rat31,:)=[88.5646,84.7877]; Loc_Rat31_A2(i_Rat31,:)=[88.0967,112.9741];
Loc_Rat31_B=[89.4247,112.8130];

i_Rat31=i_Rat31+1;path_Rat31{i_Rat31}='C:\Novel Object\Rat31\2014-01-07-F';
ndirs_Rat31(i_Rat31)=3;
csclist_Rat31_CA1{i_Rat31}=[2,3,5];
csclist_Rat31_CA1_neighbor{i_Rat31}=[3,2,3];
csclist_alltt_Rat31_CA1{i_Rat31}=[2,3,5];
csclist_alltt_Rat31_CA1_neighbor{i_Rat31}=[3,2,3];
csclist_Rat31_CA3{i_Rat31}=[7,10];
csclist_Rat31_CA3_neighbor{i_Rat31}=[10,7];
csclist_alltt_Rat31_CA3{i_Rat31}=[7,10];
csclist_alltt_Rat31_CA3_neighbor{i_Rat31}=[10,7];
n_CA1pyr_Rat31(i_Rat31,1)=12; n_CA1int_Rat31(i_Rat31,1)=0;
n_CA3pyr_Rat31(i_Rat31,1)=1; n_CA3int_Rat31(i_Rat31,1)=1;
Loc_Rat31_A1(i_Rat31,:)=[86.5447,88.9679]; Loc_Rat31_A2(i_Rat31,:)=[86.5241,115.2952];

i_Rat31=i_Rat31+1;path_Rat31{i_Rat31}='C:\Novel Object\Rat31\2014-01-08-NO+NL';
ndirs_Rat31(i_Rat31)=3;
csclist_Rat31_CA1{i_Rat31}=[2,3,5];
csclist_Rat31_CA1_neighbor{i_Rat31}=[3,2,3];
csclist_alltt_Rat31_CA1{i_Rat31}=[2,3,5];
csclist_alltt_Rat31_CA1_neighbor{i_Rat31}=[3,2,3];
csclist_Rat31_CA3{i_Rat31}=[7,10];
csclist_Rat31_CA3_neighbor{i_Rat31}=[10,7];
csclist_alltt_Rat31_CA3{i_Rat31}=[7,10];
csclist_alltt_Rat31_CA3_neighbor{i_Rat31}=[10,7];
n_CA1pyr_Rat31(i_Rat31,1)=15; n_CA1int_Rat31(i_Rat31,1)=1;
n_CA3pyr_Rat31(i_Rat31,1)=1; n_CA3int_Rat31(i_Rat31,1)=0;
Loc_Rat31_A1(i_Rat31,:)=[86.1270,89.4738]; Loc_Rat31_A2(i_Rat31,:)=[86.6245,115.0210];
Loc_Rat31_C=[115.0259,114.5710];

i_Rat31=i_Rat31+1;path_Rat31{i_Rat31}='C:\Novel Object\Rat31\2014-01-09-NL';
ndirs_Rat31(i_Rat31)=3;
csclist_Rat31_CA1{i_Rat31}=[2,3,5];
csclist_Rat31_CA1_neighbor{i_Rat31}=[3,2,3];
csclist_alltt_Rat31_CA1{i_Rat31}=[2,3,5];
csclist_alltt_Rat31_CA1_neighbor{i_Rat31}=[3,2,3];
csclist_Rat31_CA3{i_Rat31}=[7,10];
csclist_Rat31_CA3_neighbor{i_Rat31}=[10,7];
csclist_alltt_Rat31_CA3{i_Rat31}=[7,10];
csclist_alltt_Rat31_CA3_neighbor{i_Rat31}=[10,7];
n_CA1pyr_Rat31(i_Rat31,1)=10; n_CA1int_Rat31(i_Rat31,1)=1;
n_CA3pyr_Rat31(i_Rat31,1)=2; n_CA3int_Rat31(i_Rat31,1)=0;
Loc_Rat31_A1(i_Rat31,:)=[86.2458,89.4085]; Loc_Rat31_A2(i_Rat31,:)=[87.3199,114.8284];
Loc_Rat31_A22=[113.0195,114.0380];

%% Rat44
scale_Rat44_x = .28;
scale_Rat44_y = .36;

i_Rat44=0;

i_Rat44=i_Rat44+1;path_Rat44{i_Rat44}='C:\Novel Object\Rat44\2014-05-07-F';
ndirs_Rat44(i_Rat44)=3;
% csclist_Rat44_CA1{i_Rat44}=[5];
% csclist_Rat44_CA1_neighbor{i_Rat44}=[6];
csclist_Rat44_CA1{i_Rat44}=[6];
csclist_Rat44_CA1_neighbor{i_Rat44}=[5];
csclist_alltt_Rat44_CA1{i_Rat44}=[5];
csclist_alltt_Rat44_CA1_neighbor{i_Rat44}=[6];
% csclist_Rat44_CA3{i_Rat44}=[1,4,7,9];
% csclist_Rat44_CA3_neighbor{i_Rat44}=[4,1,9,7];
csclist_Rat44_CA3{i_Rat44}=[1];
csclist_Rat44_CA3_neighbor{i_Rat44}=[4];
csclist_alltt_Rat44_CA3{i_Rat44}=[1,4,7,9];
csclist_alltt_Rat44_CA3_neighbor{i_Rat44}=[4,1,9,7];
n_CA1pyr_Rat44(i_Rat44,1)=3; n_CA1int_Rat44(i_Rat44,1)=0;
n_CA3pyr_Rat44(i_Rat44,1)=6; n_CA3int_Rat44(i_Rat44,1)=0;
Loc_Rat44_A1(i_Rat44,:)=[85.7707,111.1975]; Loc_Rat44_A2(i_Rat44,:)=[86.0560,85.8050];

i_Rat44=i_Rat44+1;path_Rat44{i_Rat44}='C:\Novel Object\Rat44\2014-05-08-NL';
ndirs_Rat44(i_Rat44)=3;
% csclist_Rat44_CA1{i_Rat44}=[5,6];
% csclist_Rat44_CA1_neighbor{i_Rat44}=[6,5];
csclist_Rat44_CA1{i_Rat44}=[6];
csclist_Rat44_CA1_neighbor{i_Rat44}=[5];
csclist_alltt_Rat44_CA1{i_Rat44}=[5,6];
csclist_alltt_Rat44_CA1_neighbor{i_Rat44}=[6,5];
% csclist_Rat44_CA3{i_Rat44}=[1,4,7,9];
% csclist_Rat44_CA3_neighbor{i_Rat44}=[4,1,9,7];
csclist_Rat44_CA3{i_Rat44}=[1];
csclist_Rat44_CA3_neighbor{i_Rat44}=[4];
csclist_alltt_Rat44_CA3{i_Rat44}=[1,4,7,9];
csclist_alltt_Rat44_CA3_neighbor{i_Rat44}=[4,1,9,7];
n_CA1pyr_Rat44(i_Rat44,1)=4; n_CA1int_Rat44(i_Rat44,1)=0;
n_CA3pyr_Rat44(i_Rat44,1)=8; n_CA3int_Rat44(i_Rat44,1)=1;
Loc_Rat44_A1(i_Rat44,:)=[86.0891,109.9547]; Loc_Rat44_A2(i_Rat44,:)=[87.0480,86.5107];
Loc_Rat44_A22=[110.3297,110.2144];

i_Rat44=i_Rat44+1;path_Rat44{i_Rat44}='C:\Novel Object\Rat44\2014-05-09-F';
ndirs_Rat44(i_Rat44)=3;
% csclist_Rat44_CA1{i_Rat44}=[5,6];
% csclist_Rat44_CA1_neighbor{i_Rat44}=[6,5];
csclist_Rat44_CA1{i_Rat44}=[6];
csclist_Rat44_CA1_neighbor{i_Rat44}=[5];
csclist_alltt_Rat44_CA1{i_Rat44}=[5,6];
csclist_alltt_Rat44_CA1_neighbor{i_Rat44}=[6,5];
% csclist_Rat44_CA3{i_Rat44}=[1,4,7,9];
% csclist_Rat44_CA3_neighbor{i_Rat44}=[4,1,9,7];
csclist_Rat44_CA3{i_Rat44}=[1];
csclist_Rat44_CA3_neighbor{i_Rat44}=[4];
csclist_alltt_Rat44_CA3{i_Rat44}=[1,4,7,9];
csclist_alltt_Rat44_CA3_neighbor{i_Rat44}=[4,1,9,7];
n_CA1pyr_Rat44(i_Rat44,1)=4; n_CA1int_Rat44(i_Rat44,1)=0;
n_CA3pyr_Rat44(i_Rat44,1)=9; n_CA3int_Rat44(i_Rat44,1)=1;
Loc_Rat44_A1(i_Rat44,:)=[85.7925,109.8011]; Loc_Rat44_A2(i_Rat44,:)=[86.7563,85.9047];

i_Rat44=i_Rat44+1;path_Rat44{i_Rat44}='C:\Novel Object\Rat44\2014-05-10-NO+NL';
ndirs_Rat44(i_Rat44)=3;
% csclist_Rat44_CA1{i_Rat44}=[5,6];
% csclist_Rat44_CA1_neighbor{i_Rat44}=[6,5];
csclist_Rat44_CA1{i_Rat44}=[6];
csclist_Rat44_CA1_neighbor{i_Rat44}=[5];
csclist_alltt_Rat44_CA1{i_Rat44}=[5,6];
csclist_alltt_Rat44_CA1_neighbor{i_Rat44}=[6,5];
% csclist_Rat44_CA3{i_Rat44}=[1,4,7,9];
% csclist_Rat44_CA3_neighbor{i_Rat44}=[4,1,9,7];
csclist_Rat44_CA3{i_Rat44}=[1];
csclist_Rat44_CA3_neighbor{i_Rat44}=[4];
csclist_alltt_Rat44_CA3{i_Rat44}=[1,4,7,9];
csclist_alltt_Rat44_CA3_neighbor{i_Rat44}=[4,1,9,7];
n_CA1pyr_Rat44(i_Rat44,1)=6; n_CA1int_Rat44(i_Rat44,1)=1;
n_CA3pyr_Rat44(i_Rat44,1)=7; n_CA3int_Rat44(i_Rat44,1)=0;
Loc_Rat44_A1(i_Rat44,:)=[86.1411,110.3928]; Loc_Rat44_A2(i_Rat44,:)=[87.3721,86.3002];
Loc_Rat44_C=[109.2168,84.1095];

i_Rat44=i_Rat44+1;path_Rat44{i_Rat44}='C:\Novel Object\Rat44\2014-05-11-F';
ndirs_Rat44(i_Rat44)=3;
% csclist_Rat44_CA1{i_Rat44}=[5,6];
% csclist_Rat44_CA1_neighbor{i_Rat44}=[6,5];
csclist_Rat44_CA1{i_Rat44}=[6];
csclist_Rat44_CA1_neighbor{i_Rat44}=[5];
csclist_alltt_Rat44_CA1{i_Rat44}=[5,6];
csclist_alltt_Rat44_CA1_neighbor{i_Rat44}=[6,5];
% csclist_Rat44_CA3{i_Rat44}=[1,4,7,9];
% csclist_Rat44_CA3_neighbor{i_Rat44}=[4,1,9,7];
csclist_Rat44_CA3{i_Rat44}=[1];
csclist_Rat44_CA3_neighbor{i_Rat44}=[4];
csclist_alltt_Rat44_CA3{i_Rat44}=[1,4,7,9];
csclist_alltt_Rat44_CA3_neighbor{i_Rat44}=[4,1,9,7];
n_CA1pyr_Rat44(i_Rat44,1)=6; n_CA1int_Rat44(i_Rat44,1)=1;
n_CA3pyr_Rat44(i_Rat44,1)=7; n_CA3int_Rat44(i_Rat44,1)=0;
Loc_Rat44_A1(i_Rat44,:)=[86.5916  111.2992]; Loc_Rat44_A2(i_Rat44,:)=[87.4547   85.7981];

i_Rat44=i_Rat44+1;path_Rat44{i_Rat44}='C:\Novel Object\Rat44\2014-05-12-NO';
ndirs_Rat44(i_Rat44)=3;
% csclist_Rat44_CA1{i_Rat44}=[5,6];
% csclist_Rat44_CA1_neighbor{i_Rat44}=[6,5];
csclist_Rat44_CA1{i_Rat44}=[6];
csclist_Rat44_CA1_neighbor{i_Rat44}=[5];
csclist_alltt_Rat44_CA1{i_Rat44}=[5,6];
csclist_alltt_Rat44_CA1_neighbor{i_Rat44}=[6,5];
% csclist_Rat44_CA3{i_Rat44}=[1,4,7,9];
% csclist_Rat44_CA3_neighbor{i_Rat44}=[4,1,9,7];
csclist_Rat44_CA3{i_Rat44}=[1];
csclist_Rat44_CA3_neighbor{i_Rat44}=[4];
csclist_alltt_Rat44_CA3{i_Rat44}=[1,4,7,9];
csclist_alltt_Rat44_CA3_neighbor{i_Rat44}=[4,1,9,7];
n_CA1pyr_Rat44(i_Rat44,1)=4; n_CA1int_Rat44(i_Rat44,1)=1;
n_CA3pyr_Rat44(i_Rat44,1)=8; n_CA3int_Rat44(i_Rat44,1)=0;
Loc_Rat44_A1(i_Rat44,:)=[85.5784  111.3674]; Loc_Rat44_A2(i_Rat44,:)=[86.5615   85.8902];
Loc_Rat44_B=[86.5615   85.8902];

%% Rat45
scale_Rat45_x = .34;
scale_Rat45_y = .38;

i_Rat45=0;

i_Rat45=i_Rat45+1;path_Rat45{i_Rat45}='C:\Novel Object\Rat45\2014-05-23-F';
ndirs_Rat45(i_Rat45)=3;
csclist_Rat45_CA1{i_Rat45}=[1,2];
csclist_Rat45_CA1_neighbor{i_Rat45}=[2,1];
csclist_alltt_Rat45_CA1{i_Rat45}=[1,2];
csclist_alltt_Rat45_CA1_neighbor{i_Rat45}=[2,1];
csclist_Rat45_CA3{i_Rat45}=[7,11,12];
csclist_Rat45_CA3_neighbor{i_Rat45}=[6,12,11];
csclist_alltt_Rat45_CA3{i_Rat45}=[7,11,12];
csclist_alltt_Rat45_CA3_neighbor{i_Rat45}=[6,12,11];
n_CA1pyr_Rat45(i_Rat45,1)=1; n_CA1int_Rat45(i_Rat45,1)=1;
n_CA3pyr_Rat45(i_Rat45,1)=8; n_CA3int_Rat45(i_Rat45,1)=1;
Loc_Rat45_A1(i_Rat45,:)=[119.4027   97.4074]; Loc_Rat45_A2(i_Rat45,:)=[119.4027   66.7228];

i_Rat45=i_Rat45+1;path_Rat45{i_Rat45}='C:\Novel Object\Rat45\2014-05-24-NO+NL';
ndirs_Rat45(i_Rat45)=3;
csclist_Rat45_CA1{i_Rat45}=[1,2];
csclist_Rat45_CA1_neighbor{i_Rat45}=[2,1];
csclist_alltt_Rat45_CA1{i_Rat45}=[1,2];
csclist_alltt_Rat45_CA1_neighbor{i_Rat45}=[2,1];
csclist_Rat45_CA3{i_Rat45}=[6,7,11,12];
csclist_Rat45_CA3_neighbor{i_Rat45}=[7,6,12,11];
csclist_alltt_Rat45_CA3{i_Rat45}=[6,7,11,12];
csclist_alltt_Rat45_CA3_neighbor{i_Rat45}=[7,6,12,11];
n_CA1pyr_Rat45(i_Rat45,1)=3; n_CA1int_Rat45(i_Rat45,1)=1;
n_CA3pyr_Rat45(i_Rat45,1)=9; n_CA3int_Rat45(i_Rat45,1)=1;
% Loc_Rat45_A1(i_Rat45,:)=[119.0890   93.9282]; Loc_Rat45_A2(i_Rat45,:)=[118.1996   66.2162];
Loc_Rat45_A2(i_Rat45,:)=[119.0890   93.9282]; Loc_Rat45_A1(i_Rat45,:)=[118.1996   66.2162];
Loc_Rat45_C=[90.0393   96.1261];

i_Rat45=i_Rat45+1;path_Rat45{i_Rat45}='C:\Novel Object\Rat45\2014-05-25-F';
ndirs_Rat45(i_Rat45)=3;
csclist_Rat45_CA1{i_Rat45}=[1,2];
csclist_Rat45_CA1_neighbor{i_Rat45}=[2,1];
csclist_alltt_Rat45_CA1{i_Rat45}=[1,2];
csclist_alltt_Rat45_CA1_neighbor{i_Rat45}=[2,1];
csclist_Rat45_CA3{i_Rat45}=[6,7,11,12];
csclist_Rat45_CA3_neighbor{i_Rat45}=[7,6,12,11];
csclist_alltt_Rat45_CA3{i_Rat45}=[6,7,11,12];
csclist_alltt_Rat45_CA3_neighbor{i_Rat45}=[7,6,12,11];
n_CA1pyr_Rat45(i_Rat45,1)=1; n_CA1int_Rat45(i_Rat45,1)=1;
n_CA3pyr_Rat45(i_Rat45,1)=12; n_CA3int_Rat45(i_Rat45,1)=1;
Loc_Rat45_A1(i_Rat45,:)=[120.0811   96.7489]; Loc_Rat45_A2(i_Rat45,:)=[120.0811   65.9952];

i_Rat45=i_Rat45+1;path_Rat45{i_Rat45}='C:\Novel Object\Rat45\2014-05-26-NO';
ndirs_Rat45(i_Rat45)=3;
csclist_Rat45_CA1{i_Rat45}=[1,2];
csclist_Rat45_CA1_neighbor{i_Rat45}=[2,1];
csclist_alltt_Rat45_CA1{i_Rat45}=[1,2];
csclist_alltt_Rat45_CA1_neighbor{i_Rat45}=[2,1];
csclist_Rat45_CA3{i_Rat45}=[6,7,11,12];
csclist_Rat45_CA3_neighbor{i_Rat45}=[7,6,12,11];
csclist_alltt_Rat45_CA3{i_Rat45}=[6,7,11,12];
csclist_alltt_Rat45_CA3_neighbor{i_Rat45}=[7,6,12,11];
n_CA1pyr_Rat45(i_Rat45,1)=1; n_CA1int_Rat45(i_Rat45,1)=1;
n_CA3pyr_Rat45(i_Rat45,1)=10; n_CA3int_Rat45(i_Rat45,1)=0;
Loc_Rat45_A1(i_Rat45,:)=[119.8300   94.6847]; Loc_Rat45_A2(i_Rat45,:)=[119.5335   64.9549];
Loc_Rat45_B=[119.5335   64.9549];

i_Rat45=i_Rat45+1;path_Rat45{i_Rat45}='C:\Novel Object\Rat45\2014-05-27-F';
ndirs_Rat45(i_Rat45)=3;
csclist_Rat45_CA1{i_Rat45}=[1,2];
csclist_Rat45_CA1_neighbor{i_Rat45}=[2,1];
csclist_alltt_Rat45_CA1{i_Rat45}=[1,2];
csclist_alltt_Rat45_CA1_neighbor{i_Rat45}=[2,1];
csclist_Rat45_CA3{i_Rat45}=[6,7,11,12];
csclist_Rat45_CA3_neighbor{i_Rat45}=[7,6,12,11];
csclist_alltt_Rat45_CA3{i_Rat45}=[6,7,11,12];
csclist_alltt_Rat45_CA3_neighbor{i_Rat45}=[7,6,12,11];
n_CA1pyr_Rat45(i_Rat45,1)=1; n_CA1int_Rat45(i_Rat45,1)=1;
n_CA3pyr_Rat45(i_Rat45,1)=9; n_CA3int_Rat45(i_Rat45,1)=0;
Loc_Rat45_A1(i_Rat45,:)=[119.7519   95.8635]; Loc_Rat45_A2(i_Rat45,:)=[119.7519   65.5660];

i_Rat45=i_Rat45+1;path_Rat45{i_Rat45}='C:\Novel Object\Rat45\2014-05-28-NL';
ndirs_Rat45(i_Rat45)=3;
csclist_Rat45_CA1{i_Rat45}=[1,2];
csclist_Rat45_CA1_neighbor{i_Rat45}=[2,1];
csclist_alltt_Rat45_CA1{i_Rat45}=[1,2];
csclist_alltt_Rat45_CA1_neighbor{i_Rat45}=[2,1];
csclist_Rat45_CA3{i_Rat45}=[6,7,11,12];
csclist_Rat45_CA3_neighbor{i_Rat45}=[7,6,12,11];
csclist_alltt_Rat45_CA3{i_Rat45}=[6,7,11,12];
csclist_alltt_Rat45_CA3_neighbor{i_Rat45}=[7,6,12,11];
n_CA1pyr_Rat45(i_Rat45,1)=1; n_CA1int_Rat45(i_Rat45,1)=1;
n_CA3pyr_Rat45(i_Rat45,1)=10; n_CA3int_Rat45(i_Rat45,1)=0;
Loc_Rat45_A1(i_Rat45,:)=[118.0514   91.4265]; Loc_Rat45_A2(i_Rat45,:)=[118.9407   65.8687];
Loc_Rat45_A22=[90.0393   65.5705];

%% Rat47
scale_Rat47_x = .28;
scale_Rat47_y = .36;

i_Rat47=0;

i_Rat47=i_Rat47+1;path_Rat47{i_Rat47}='C:\Novel Object\Rat47\2014-09-24-F';
ndirs_Rat47(i_Rat47)=3;
csclist_Rat47_CA1{i_Rat47}=[3,5,6];
csclist_Rat47_CA1_neighbor{i_Rat47}=[5,6,5];
csclist_alltt_Rat47_CA1{i_Rat47}=[3,5,6];
csclist_alltt_Rat47_CA1_neighbor{i_Rat47}=[5,6,5];
csclist_Rat47_CA3{i_Rat47}=[11,12];
csclist_Rat47_CA3_neighbor{i_Rat47}=[12,11];
csclist_alltt_Rat47_CA3{i_Rat47}=[11,12];
csclist_alltt_Rat47_CA3_neighbor{i_Rat47}=[12,11];
n_CA1pyr_Rat47(i_Rat47,1)=6; n_CA1int_Rat47(i_Rat47,1)=0;
n_CA3pyr_Rat47(i_Rat47,1)=5; n_CA3int_Rat47(i_Rat47,1)=0;
Loc_Rat47_A1(i_Rat47,:)=[86.7862  111.7715]; Loc_Rat47_A2(i_Rat47,:)=[87.4842   87.3133];

i_Rat47=i_Rat47+1;path_Rat47{i_Rat47}='C:\Novel Object\Rat47\2014-09-25-NO';
ndirs_Rat47(i_Rat47)=3;
csclist_Rat47_CA1{i_Rat47}=[3,5];
csclist_Rat47_CA1_neighbor{i_Rat47}=[5,3];
csclist_alltt_Rat47_CA1{i_Rat47}=[3,5];
csclist_alltt_Rat47_CA1_neighbor{i_Rat47}=[5,3];
csclist_Rat47_CA3{i_Rat47}=[11,12];
csclist_Rat47_CA3_neighbor{i_Rat47}=[12,11];
csclist_alltt_Rat47_CA3{i_Rat47}=[11,12];
csclist_alltt_Rat47_CA3_neighbor{i_Rat47}=[12,11];
n_CA1pyr_Rat47(i_Rat47,1)=7; n_CA1int_Rat47(i_Rat47,1)=0;
n_CA3pyr_Rat47(i_Rat47,1)=7; n_CA3int_Rat47(i_Rat47,1)=0;
Loc_Rat47_A1(i_Rat47,:)=[86.8429  111.7815]; Loc_Rat47_A2(i_Rat47,:)=[87.5799   87.1049];
Loc_Rat47_B=[87.4016   85.5404];

i_Rat47=i_Rat47+1;path_Rat47{i_Rat47}='C:\Novel Object\Rat47\2014-09-26-F';
ndirs_Rat47(i_Rat47)=3;
csclist_Rat47_CA1{i_Rat47}=[3,5];
csclist_Rat47_CA1_neighbor{i_Rat47}=[5,3];
csclist_alltt_Rat47_CA1{i_Rat47}=[3,5];
csclist_alltt_Rat47_CA1_neighbor{i_Rat47}=[5,3];
csclist_Rat47_CA3{i_Rat47}=[11,12];
csclist_Rat47_CA3_neighbor{i_Rat47}=[12,11];
csclist_alltt_Rat47_CA3{i_Rat47}=[11,12];
csclist_alltt_Rat47_CA3_neighbor{i_Rat47}=[12,11];
n_CA1pyr_Rat47(i_Rat47,1)=4; n_CA1int_Rat47(i_Rat47,1)=1;
n_CA3pyr_Rat47(i_Rat47,1)=5; n_CA3int_Rat47(i_Rat47,1)=0;
Loc_Rat47_A1(i_Rat47,:)=[86.7536  112.8053]; Loc_Rat47_A2(i_Rat47,:)=[87.4853   86.8953];

i_Rat47=i_Rat47+1;path_Rat47{i_Rat47}='C:\Novel Object\Rat47\2014-09-27-NO+NL';
ndirs_Rat47(i_Rat47)=3;
csclist_Rat47_CA1{i_Rat47}=[3,5];
csclist_Rat47_CA1_neighbor{i_Rat47}=[5,3];
csclist_alltt_Rat47_CA1{i_Rat47}=[3,5];
csclist_alltt_Rat47_CA1_neighbor{i_Rat47}=[5,3];
csclist_Rat47_CA3{i_Rat47}=[11,12];
csclist_Rat47_CA3_neighbor{i_Rat47}=[12,11];
csclist_alltt_Rat47_CA3{i_Rat47}=[11,12];
csclist_alltt_Rat47_CA3_neighbor{i_Rat47}=[12,11];
n_CA1pyr_Rat47(i_Rat47,1)=6; n_CA1int_Rat47(i_Rat47,1)=1;
n_CA3pyr_Rat47(i_Rat47,1)=8; n_CA3int_Rat47(i_Rat47,1)=0;
Loc_Rat47_A1(i_Rat47,:)=[86.6781  111.8353]; Loc_Rat47_A2(i_Rat47,:)=[86.9609   86.8726];
Loc_Rat47_C=[110.3825   86.7310];

i_Rat47=i_Rat47+1;path_Rat47{i_Rat47}='C:\Novel Object\Rat47\2014-09-28-F';
ndirs_Rat47(i_Rat47)=3;
csclist_Rat47_CA1{i_Rat47}=[3,5];
csclist_Rat47_CA1_neighbor{i_Rat47}=[5,3];
csclist_alltt_Rat47_CA1{i_Rat47}=[3,5];
csclist_alltt_Rat47_CA1_neighbor{i_Rat47}=[5,3];
csclist_Rat47_CA3{i_Rat47}=[11,12];
csclist_Rat47_CA3_neighbor{i_Rat47}=[12,11];
csclist_alltt_Rat47_CA3{i_Rat47}=[11,12];
csclist_alltt_Rat47_CA3_neighbor{i_Rat47}=[12,11];
n_CA1pyr_Rat47(i_Rat47,1)=4; n_CA1int_Rat47(i_Rat47,1)=1;
n_CA3pyr_Rat47(i_Rat47,1)=5; n_CA3int_Rat47(i_Rat47,1)=0;
Loc_Rat47_A1(i_Rat47,:)=[86.9640  111.4841]; Loc_Rat47_A2(i_Rat47,:)=[86.7736   86.5465];

i_Rat47=i_Rat47+1;path_Rat47{i_Rat47}='C:\Novel Object\Rat47\2014-09-29-NL';
ndirs_Rat47(i_Rat47)=3;
csclist_Rat47_CA1{i_Rat47}=[3,5];
csclist_Rat47_CA1_neighbor{i_Rat47}=[5,3];
csclist_alltt_Rat47_CA1{i_Rat47}=[3,5];
csclist_alltt_Rat47_CA1_neighbor{i_Rat47}=[5,3];
csclist_Rat47_CA3{i_Rat47}=[11,12];
csclist_Rat47_CA3_neighbor{i_Rat47}=[12,11];
csclist_alltt_Rat47_CA3{i_Rat47}=[11,12];
csclist_alltt_Rat47_CA3_neighbor{i_Rat47}=[12,11];
n_CA1pyr_Rat47(i_Rat47,1)=3; n_CA1int_Rat47(i_Rat47,1)=1;
n_CA3pyr_Rat47(i_Rat47,1)=6; n_CA3int_Rat47(i_Rat47,1)=0;
Loc_Rat47_A1(i_Rat47,:)=[86.5941  111.6491]; Loc_Rat47_A2(i_Rat47,:)=[87.4518   86.0414];
Loc_Rat47_A22=[109.7645  110.6577];

%% Rat68
scale_Rat68_x = .28;
scale_Rat68_y = .35;

i_Rat68=0;

i_Rat68=i_Rat68+1;path_Rat68{i_Rat68}='C:\Novel Object\Rat68\2015-03-19-F';
ndirs_Rat68(i_Rat68)=3;
csclist_Rat68_CA1{i_Rat68}=[2,3,4,5,11,12];
csclist_Rat68_CA1_neighbor{i_Rat68}=[3,2,5,4,12,11];
csclist_alltt_Rat68_CA1{i_Rat68}=[1,2,3,4,5,6,7,8,10,11,12];
csclist_alltt_Rat68_CA1_neighbor{i_Rat68}=[3,1,2,5,4,7,8,6,12,10,11];
n_CA1pyr_Rat68(i_Rat68,1)=0; n_CA1int_Rat68(i_Rat68,1)=0;
Loc_Rat68_A1(i_Rat68,:)=[83.4400  109.0250]; Loc_Rat68_A2(i_Rat68,:)=[84.5600   83.3000];

i_Rat68=i_Rat68+1;path_Rat68{i_Rat68}='C:\Novel Object\Rat68\2015-03-20-NO+NL';
ndirs_Rat68(i_Rat68)=3;
csclist_Rat68_CA1{i_Rat68}=[2,3,4,5,11,12];
csclist_Rat68_CA1_neighbor{i_Rat68}=[3,2,5,4,12,11];
csclist_alltt_Rat68_CA1{i_Rat68}=[1,2,3,4,5,6,7,8,10,11,12];
csclist_alltt_Rat68_CA1_neighbor{i_Rat68}=[3,1,2,5,4,7,8,6,12,10,11];
n_CA1pyr_Rat68(i_Rat68,1)=33; n_CA1int_Rat68(i_Rat68,1)=4;
Loc_Rat68_A1(i_Rat68,:)=[84.8400  109.0105]; Loc_Rat68_A2(i_Rat68,:)=[85.6800   82.9500];
Loc_Rat68_C=[110.1800   84.0000];

i_Rat68=i_Rat68+1;path_Rat68{i_Rat68}='C:\Novel Object\Rat68\2015-03-21-F';
ndirs_Rat68(i_Rat68)=3;
csclist_Rat68_CA1{i_Rat68}=[2,3,4,5,11,12];
csclist_Rat68_CA1_neighbor{i_Rat68}=[3,2,5,4,12,11];
csclist_alltt_Rat68_CA1{i_Rat68}=[1,2,3,4,5,6,7,8,10,11,12];
csclist_alltt_Rat68_CA1_neighbor{i_Rat68}=[3,1,2,5,4,7,8,6,12,10,11];
n_CA1pyr_Rat68(i_Rat68,1)=14; n_CA1int_Rat68(i_Rat68,1)=3;
Loc_Rat68_A1(i_Rat68,:)=[83.7200  109.9000]; Loc_Rat68_A2(i_Rat68,:)=[84.8400   82.6000];

i_Rat68=i_Rat68+1;path_Rat68{i_Rat68}='C:\Novel Object\Rat68\2015-03-22-NO';
ndirs_Rat68(i_Rat68)=3;
csclist_Rat68_CA1{i_Rat68}=[2,3,4,5,11,12];
csclist_Rat68_CA1_neighbor{i_Rat68}=[3,2,5,4,12,11];
csclist_alltt_Rat68_CA1{i_Rat68}=[1,2,3,4,5,6,7,8,10,11,12];
csclist_alltt_Rat68_CA1_neighbor{i_Rat68}=[3,1,2,5,4,7,8,6,12,10,11];
n_CA1pyr_Rat68(i_Rat68,1)=15; n_CA1int_Rat68(i_Rat68,1)=3;
Loc_Rat68_A1(i_Rat68,:)=[83.4251  109.5500]; Loc_Rat68_A2(i_Rat68,:)=[84.7000   84.5250];
Loc_Rat68_B=[84.7000   84.5250];

i_Rat68=i_Rat68+1;path_Rat68{i_Rat68}='C:\Novel Object\Rat68\2015-03-23-F';
ndirs_Rat68(i_Rat68)=3;
csclist_Rat68_CA1{i_Rat68}=[2,3,4,5,11,12];
csclist_Rat68_CA1_neighbor{i_Rat68}=[3,2,5,4,12,11];
csclist_alltt_Rat68_CA1{i_Rat68}=[1,2,3,4,5,6,7,8,10,11,12];
csclist_alltt_Rat68_CA1_neighbor{i_Rat68}=[3,1,2,5,4,7,8,6,12,10,11];
n_CA1pyr_Rat68(i_Rat68,1)=0; n_CA1int_Rat68(i_Rat68,1)=0;
Loc_Rat68_A1(i_Rat68,:)=[83.8600  110.2500]; Loc_Rat68_A2(i_Rat68,:)=[84.7000   82.9500];

i_Rat68=i_Rat68+1;path_Rat68{i_Rat68}='C:\Novel Object\Rat68\2015-03-24-NL';
ndirs_Rat68(i_Rat68)=3;
csclist_Rat68_CA1{i_Rat68}=[2,3,4,5,11,12];
csclist_Rat68_CA1_neighbor{i_Rat68}=[3,2,5,4,12,11];
csclist_alltt_Rat68_CA1{i_Rat68}=[1,2,3,4,5,6,7,8,10,11,12];
csclist_alltt_Rat68_CA1_neighbor{i_Rat68}=[3,1,2,5,4,7,8,6,12,10,11];
n_CA1pyr_Rat68(i_Rat68,1)=17; n_CA1int_Rat68(i_Rat68,1)=3;
Loc_Rat68_A1(i_Rat68,:)=[84.2800  110.2500]; Loc_Rat68_A2(i_Rat68,:)=[85.1200   82.9500];
Loc_Rat68_A22=[109.2000  110.9500];

%% Rat79
scale_Rat79_x = .35;
scale_Rat79_y = .35;

i_Rat79=0;

i_Rat79=i_Rat79+1;path_Rat79{i_Rat79}='C:\Novel Object\Rat79\2015-09-17-F';
ndirs_Rat79(i_Rat79)=3;
csclist_Rat79_CA1{i_Rat79}=[6,18,20];
csclist_Rat79_CA1_neighbor{i_Rat79}=[2,20,18];
csclist_alltt_Rat79_CA1{i_Rat79}=[2,6,18,20,22];
csclist_alltt_Rat79_CA1_neighbor{i_Rat79}=[6,2,20,22,18];
csclist_Rat79_CA3{i_Rat79}=[];
csclist_alltt_Rat79_CA3{i_Rat79}=[];
n_CA1pyr_Rat79(i_Rat79,1)=8; n_CA1int_Rat79(i_Rat79,1)=0;
n_CA3pyr_Rat79(i_Rat79,1)=0; n_CA3int_Rat79(i_Rat79,1)=0;
Loc_Rat79_A1(i_Rat79,:)=[176.3309   88.6527]; Loc_Rat79_A2(i_Rat79,:)=[176.5517  119.3028];

i_Rat79=i_Rat79+1;path_Rat79{i_Rat79}='C:\Novel Object\Rat79\2015-09-18-NO';
ndirs_Rat79(i_Rat79)=3;
csclist_Rat79_CA1{i_Rat79}=[2,18];
csclist_Rat79_CA1_neighbor{i_Rat79}=[6,20];
csclist_alltt_Rat79_CA1{i_Rat79}=[2,6,18,20];
csclist_alltt_Rat79_CA1_neighbor{i_Rat79}=[6,2,20,18];
csclist_Rat79_CA3{i_Rat79}=[];
csclist_alltt_Rat79_CA3{i_Rat79}=[];
n_CA1pyr_Rat79(i_Rat79,1)=4; n_CA1int_Rat79(i_Rat79,1)=0;
n_CA3pyr_Rat79(i_Rat79,1)=0; n_CA3int_Rat79(i_Rat79,1)=0;
Loc_Rat79_A1(i_Rat79,:)=[177.1314   89.5369]; Loc_Rat79_A2(i_Rat79,:)=[178.4776  119.4952];
Loc_Rat79_B=[177.6264  118.6340];

i_Rat79=i_Rat79+1;path_Rat79{i_Rat79}='C:\Novel Object\Rat79\2015-09-19-F';
ndirs_Rat79(i_Rat79)=3;
csclist_Rat79_CA1{i_Rat79}=[2,6,18,20];
csclist_Rat79_CA1_neighbor{i_Rat79}=[6,2,20,18];
csclist_alltt_Rat79_CA1{i_Rat79}=[2,6,18,20];
csclist_alltt_Rat79_CA1_neighbor{i_Rat79}=[6,2,20,18];
csclist_Rat79_CA3{i_Rat79}=[];
csclist_alltt_Rat79_CA3{i_Rat79}=[];
n_CA1pyr_Rat79(i_Rat79,1)=10; n_CA1int_Rat79(i_Rat79,1)=0;
n_CA3pyr_Rat79(i_Rat79,1)=0; n_CA3int_Rat79(i_Rat79,1)=0;
Loc_Rat79_A1(i_Rat79,:)=[176.6255   89.4218]; Loc_Rat79_A2(i_Rat79,:)=[176.7862  117.0801];

i_Rat79=i_Rat79+1;path_Rat79{i_Rat79}='C:\Novel Object\Rat79\2015-09-20-NL';
ndirs_Rat79(i_Rat79)=3;
csclist_Rat79_CA1{i_Rat79}=[18];
csclist_Rat79_CA1_neighbor{i_Rat79}=[20];
csclist_alltt_Rat79_CA1{i_Rat79}=[2,18,20];
csclist_alltt_Rat79_CA1_neighbor{i_Rat79}=[6,20,18];
csclist_Rat79_CA3{i_Rat79}=[];
csclist_alltt_Rat79_CA3{i_Rat79}=[];
n_CA1pyr_Rat79(i_Rat79,1)=3; n_CA1int_Rat79(i_Rat79,1)=0;
n_CA3pyr_Rat79(i_Rat79,1)=0; n_CA3int_Rat79(i_Rat79,1)=0;
Loc_Rat79_A1(i_Rat79,:)=[175.6404   89.7836]; Loc_Rat79_A2(i_Rat79,:)=[176.2577  118.4233];
Loc_Rat79_A22=[145.1987  119.5063];

i_Rat79=i_Rat79+1;path_Rat79{i_Rat79}='C:\Novel Object\Rat79\2015-09-21-F';
ndirs_Rat79(i_Rat79)=3;
csclist_Rat79_CA1{i_Rat79}=[2,18,20,24];
csclist_Rat79_CA1_neighbor{i_Rat79}=[6,20,18,20];
csclist_alltt_Rat79_CA1{i_Rat79}=[2,18,20,24];
csclist_alltt_Rat79_CA1_neighbor{i_Rat79}=[6,20,18,20];
csclist_Rat79_CA3{i_Rat79}=[];
csclist_alltt_Rat79_CA3{i_Rat79}=[];
n_CA1pyr_Rat79(i_Rat79,1)=5; n_CA1int_Rat79(i_Rat79,1)=1;
n_CA3pyr_Rat79(i_Rat79,1)=0; n_CA3int_Rat79(i_Rat79,1)=0;
Loc_Rat79_A1(i_Rat79,:)=[177.0175   88.8761]; Loc_Rat79_A2(i_Rat79,:)=[177.9961  119.3858];

i_Rat79=i_Rat79+1;path_Rat79{i_Rat79}='C:\Novel Object\Rat79\2015-09-22-NO+NL';
ndirs_Rat79(i_Rat79)=3;
csclist_Rat79_CA1{i_Rat79}=[22];
csclist_Rat79_CA1_neighbor{i_Rat79}=[20];
csclist_alltt_Rat79_CA1{i_Rat79}=[2,18,20,22];
csclist_alltt_Rat79_CA1_neighbor{i_Rat79}=[6,20,18,20];
csclist_Rat79_CA3{i_Rat79}=[];
csclist_alltt_Rat79_CA3{i_Rat79}=[];
n_CA1pyr_Rat79(i_Rat79,1)=3; n_CA1int_Rat79(i_Rat79,1)=1;
n_CA3pyr_Rat79(i_Rat79,1)=0; n_CA3int_Rat79(i_Rat79,1)=0;
Loc_Rat79_A1(i_Rat79,:)=[176.4400   89.1322]; Loc_Rat79_A2(i_Rat79,:)=[176.7221  119.6203];
Loc_Rat79_C=[143.8029  120.0024];


%% Rat80
scale_Rat80_x = .35;
scale_Rat80_y = .35;

i_Rat80=0;

i_Rat80=i_Rat80+1;path_Rat80{i_Rat80}='C:\Novel Object\Rat80\2015-08-10-F';
ndirs_Rat80(i_Rat80)=3;
csclist_Rat80_CA1{i_Rat80}=[11,15];
csclist_Rat80_CA1_neighbor{i_Rat80}=[15,11];
csclist_alltt_Rat80_CA1{i_Rat80}=[8,11,15];
csclist_alltt_Rat80_CA1_neighbor{i_Rat80}=[11,8,11];
csclist_Rat80_CA3{i_Rat80}=[];
csclist_alltt_Rat80_CA3{i_Rat80}=[];
n_CA1pyr_Rat80(i_Rat80,1)=3; n_CA1int_Rat80(i_Rat80,1)=0;
n_CA3pyr_Rat80(i_Rat80,1)=0; n_CA3int_Rat80(i_Rat80,1)=0;
Loc_Rat80_A1(i_Rat80,:)=[174.2447   89.4619]; Loc_Rat80_A2(i_Rat80,:)=[176.9859  118.1335];

i_Rat80=i_Rat80+1;path_Rat80{i_Rat80}='C:\Novel Object\Rat80\2015-08-11-NO+NL';
ndirs_Rat80(i_Rat80)=3;
csclist_Rat80_CA1{i_Rat80}=[11];
csclist_Rat80_CA1_neighbor{i_Rat80}=[15];
csclist_alltt_Rat80_CA1{i_Rat80}=[8,11,15];
csclist_alltt_Rat80_CA1_neighbor{i_Rat80}=[11,8,11];
csclist_Rat80_CA3{i_Rat80}=[];
csclist_alltt_Rat80_CA3{i_Rat80}=[];
n_CA1pyr_Rat80(i_Rat80,1)=1; n_CA1int_Rat80(i_Rat80,1)=0;
n_CA3pyr_Rat80(i_Rat80,1)=0; n_CA3int_Rat80(i_Rat80,1)=0;
Loc_Rat80_A1(i_Rat80,:)=[178.2294   89.9000]; Loc_Rat80_A2(i_Rat80,:)=[177.9821  119.8098];
Loc_Rat80_C=[145.8854  120.7038];

i_Rat80=i_Rat80+1;path_Rat80{i_Rat80}='C:\Novel Object\Rat80\2015-08-12-F';
ndirs_Rat80(i_Rat80)=3;
csclist_Rat80_CA1{i_Rat80}=[8];
csclist_Rat80_CA1_neighbor{i_Rat80}=[11];
csclist_alltt_Rat80_CA1{i_Rat80}=[8,11,15];
csclist_alltt_Rat80_CA1_neighbor{i_Rat80}=[11,8,11];
csclist_Rat80_CA3{i_Rat80}=[];
csclist_alltt_Rat80_CA3{i_Rat80}=[];
n_CA1pyr_Rat80(i_Rat80,1)=1; n_CA1int_Rat80(i_Rat80,1)=0;
n_CA3pyr_Rat80(i_Rat80,1)=0; n_CA3int_Rat80(i_Rat80,1)=0;
Loc_Rat80_A1(i_Rat80,:)=[176.8296   88.3061]; Loc_Rat80_A2(i_Rat80,:)=[176.7045  118.9822];

i_Rat80=i_Rat80+1;path_Rat80{i_Rat80}='C:\Novel Object\Rat80\2015-08-13-NL';
ndirs_Rat80(i_Rat80)=3;
csclist_Rat80_CA1{i_Rat80}=[8,11];
csclist_Rat80_CA1_neighbor{i_Rat80}=[11,8];
csclist_alltt_Rat80_CA1{i_Rat80}=[8,11,15];
csclist_alltt_Rat80_CA1_neighbor{i_Rat80}=[11,8,11];
csclist_Rat80_CA3{i_Rat80}=[];
csclist_alltt_Rat80_CA3{i_Rat80}=[];
n_CA1pyr_Rat80(i_Rat80,1)=6; n_CA1int_Rat80(i_Rat80,1)=0;
n_CA3pyr_Rat80(i_Rat80,1)=0; n_CA3int_Rat80(i_Rat80,1)=0;
Loc_Rat80_A1(i_Rat80,:)=[175.2777   90.2508]; Loc_Rat80_A2(i_Rat80,:)=[177.5775  118.7383];
Loc_Rat80_A22=[144.5454   90.6933];

i_Rat80=i_Rat80+1;path_Rat80{i_Rat80}='C:\Novel Object\Rat80\2015-08-14-F';
ndirs_Rat80(i_Rat80)=3;
csclist_Rat80_CA1{i_Rat80}=[15];
csclist_Rat80_CA1_neighbor{i_Rat80}=[11];
csclist_alltt_Rat80_CA1{i_Rat80}=[8,15];
csclist_alltt_Rat80_CA1_neighbor{i_Rat80}=[15,8];
csclist_Rat80_CA3{i_Rat80}=[];
csclist_alltt_Rat80_CA3{i_Rat80}=[];
n_CA1pyr_Rat80(i_Rat80,1)=3; n_CA1int_Rat80(i_Rat80,1)=0;
n_CA3pyr_Rat80(i_Rat80,1)=0; n_CA3int_Rat80(i_Rat80,1)=0;
Loc_Rat80_A1(i_Rat80,:)=[176.4128   89.0306]; Loc_Rat80_A2(i_Rat80,:)=[176.9521  119.8687];

i_Rat80=i_Rat80+1;path_Rat80{i_Rat80}='C:\Novel Object\Rat80\2015-08-15-NO';
ndirs_Rat80(i_Rat80)=3;
csclist_Rat80_CA1{i_Rat80}=[8];
csclist_Rat80_CA1_neighbor{i_Rat80}=[11];
csclist_alltt_Rat80_CA1{i_Rat80}=[8,15];
csclist_alltt_Rat80_CA1_neighbor{i_Rat80}=[15,8];
csclist_Rat80_CA3{i_Rat80}=[];
csclist_alltt_Rat80_CA3{i_Rat80}=[];
n_CA1pyr_Rat80(i_Rat80,1)=2; n_CA1int_Rat80(i_Rat80,1)=0;
n_CA3pyr_Rat80(i_Rat80,1)=0; n_CA3int_Rat80(i_Rat80,1)=0;
Loc_Rat80_A1(i_Rat80,:)=[176.0749   89.7767]; Loc_Rat80_A2(i_Rat80,:)=[179.1333  118.9084];
Loc_Rat80_B=[177.7677  118.2838];


%% Rat97
scale_Rat97_x = .28;
scale_Rat97_y = .35;

i_Rat97=0;

i_Rat97=i_Rat97+1;path_Rat97{i_Rat97}='C:\Novel Object\Rat97\2016-03-20-F';
ndirs_Rat97(i_Rat97)=3;
csclist_Rat97_CA1{i_Rat97}=[8,11];
csclist_Rat97_CA1_neighbor{i_Rat97}=[11,8];
csclist_alltt_Rat97_CA1{i_Rat97}=[8,11,12];
csclist_alltt_Rat97_CA1_neighbor{i_Rat97}=[11,8,11];
csclist_Rat97_CA3{i_Rat97}=[1];
csclist_Rat97_CA3_neighbor{i_Rat97}=[3];
csclist_alltt_Rat97_CA3{i_Rat97}=[1];
csclist_alltt_Rat97_CA3_neighbor{i_Rat97}=[3];
n_CA1pyr_Rat97(i_Rat97,1)=4; n_CA1int_Rat97(i_Rat97,1)=0;
n_CA3pyr_Rat97(i_Rat97,1)=2; n_CA3int_Rat97(i_Rat97,1)=3;
Loc_Rat97_A1(i_Rat97,:)=[84.9969  113.2250]; Loc_Rat97_A2(i_Rat97,:)=[85.1200   82.2500];

i_Rat97=i_Rat97+1;path_Rat97{i_Rat97}='C:\Novel Object\Rat97\2016-03-21-NO+NL';
ndirs_Rat97(i_Rat97)=3;
csclist_Rat97_CA1{i_Rat97}=[8,11];
csclist_Rat97_CA1_neighbor{i_Rat97}=[11,8];
csclist_alltt_Rat97_CA1{i_Rat97}=[8,11,12];
csclist_alltt_Rat97_CA1_neighbor{i_Rat97}=[11,8,11];
csclist_Rat97_CA3{i_Rat97}=[1];
csclist_Rat97_CA3_neighbor{i_Rat97}=[3];
csclist_alltt_Rat97_CA3{i_Rat97}=[1];
csclist_alltt_Rat97_CA3_neighbor{i_Rat97}=[3];
n_CA1pyr_Rat97(i_Rat97,1)=6; n_CA1int_Rat97(i_Rat97,1)=2;
n_CA3pyr_Rat97(i_Rat97,1)=3; n_CA3int_Rat97(i_Rat97,1)=4;
Loc_Rat97_A1(i_Rat97,:)=[85.4000  110.6000]; Loc_Rat97_A2(i_Rat97,:)=[85.5400   82.9500];
Loc_Rat97_C=[110.3200   84.0000];

i_Rat97=i_Rat97+1;path_Rat97{i_Rat97}='C:\Novel Object\Rat97\2016-03-22-F';
ndirs_Rat97(i_Rat97)=3;
csclist_Rat97_CA1{i_Rat97}=[8,11];
csclist_Rat97_CA1_neighbor{i_Rat97}=[11,8];
csclist_alltt_Rat97_CA1{i_Rat97}=[8,11,12];
csclist_alltt_Rat97_CA1_neighbor{i_Rat97}=[11,8,11];
csclist_Rat97_CA3{i_Rat97}=[1];
csclist_Rat97_CA3_neighbor{i_Rat97}=[3];
csclist_alltt_Rat97_CA3{i_Rat97}=[1];
csclist_alltt_Rat97_CA3_neighbor{i_Rat97}=[3];
n_CA1pyr_Rat97(i_Rat97,1)=9; n_CA1int_Rat97(i_Rat97,1)=1;
n_CA3pyr_Rat97(i_Rat97,1)=5; n_CA3int_Rat97(i_Rat97,1)=3;
Loc_Rat97_A1(i_Rat97,:)=[84.3553  111.7442]; Loc_Rat97_A2(i_Rat97,:)=[84.5600   82.2500];

i_Rat97=i_Rat97+1;path_Rat97{i_Rat97}='C:\Novel Object\Rat97\2016-03-23-NL';
ndirs_Rat97(i_Rat97)=3;
csclist_Rat97_CA1{i_Rat97}=[8,11];
csclist_Rat97_CA1_neighbor{i_Rat97}=[11,8];
csclist_alltt_Rat97_CA1{i_Rat97}=[8,11,12];
csclist_alltt_Rat97_CA1_neighbor{i_Rat97}=[11,8,11];
csclist_Rat97_CA3{i_Rat97}=[1];
csclist_Rat97_CA3_neighbor{i_Rat97}=[3];
csclist_alltt_Rat97_CA3{i_Rat97}=[1];
csclist_alltt_Rat97_CA3_neighbor{i_Rat97}=[3];
n_CA1pyr_Rat97(i_Rat97,1)=15; n_CA1int_Rat97(i_Rat97,1)=2;
n_CA3pyr_Rat97(i_Rat97,1)=6; n_CA3int_Rat97(i_Rat97,1)=3;
Loc_Rat97_A1(i_Rat97,:)=[84.5600  111.3000]; Loc_Rat97_A2(i_Rat97,:)=[84.5600   82.6000];
Loc_Rat97_A22=[108.3600  111.4750];

i_Rat97=i_Rat97+1;path_Rat97{i_Rat97}='C:\Novel Object\Rat97\2016-03-24-F';
ndirs_Rat97(i_Rat97)=3;
csclist_Rat97_CA1{i_Rat97}=[8,11];
csclist_Rat97_CA1_neighbor{i_Rat97}=[11,8];
csclist_alltt_Rat97_CA1{i_Rat97}=[8,11,12];
csclist_alltt_Rat97_CA1_neighbor{i_Rat97}=[11,8,11];
csclist_Rat97_CA3{i_Rat97}=[1];
csclist_Rat97_CA3_neighbor{i_Rat97}=[3];
csclist_alltt_Rat97_CA3{i_Rat97}=[1];
csclist_alltt_Rat97_CA3_neighbor{i_Rat97}=[3];
n_CA1pyr_Rat97(i_Rat97,1)=16; n_CA1int_Rat97(i_Rat97,1)=0;
n_CA3pyr_Rat97(i_Rat97,1)=5; n_CA3int_Rat97(i_Rat97,1)=4;
Loc_Rat97_A1(i_Rat97,:)=[84.7000  111.4750]; Loc_Rat97_A2(i_Rat97,:)=[84.8400   82.9500];

i_Rat97=i_Rat97+1;path_Rat97{i_Rat97}='C:\Novel Object\Rat97\2016-03-25-NO';
ndirs_Rat97(i_Rat97)=3;
csclist_Rat97_CA1{i_Rat97}=[8,11];
csclist_Rat97_CA1_neighbor{i_Rat97}=[11,8];
csclist_alltt_Rat97_CA1{i_Rat97}=[8,11,12];
csclist_alltt_Rat97_CA1_neighbor{i_Rat97}=[11,8,11];
csclist_Rat97_CA3{i_Rat97}=[1];
csclist_Rat97_CA3_neighbor{i_Rat97}=[3];
csclist_alltt_Rat97_CA3{i_Rat97}=[1];
csclist_alltt_Rat97_CA3_neighbor{i_Rat97}=[3];
n_CA1pyr_Rat97(i_Rat97,1)=16; n_CA1int_Rat97(i_Rat97,1)=0;
n_CA3pyr_Rat97(i_Rat97,1)=0; n_CA3int_Rat97(i_Rat97,1)=4;
Loc_Rat97_A1(i_Rat97,:)=[85.1200  111.6500]; Loc_Rat97_A2(i_Rat97,:)=[84.8400   83.1477];
Loc_Rat97_B=[84.8400   83.1477];