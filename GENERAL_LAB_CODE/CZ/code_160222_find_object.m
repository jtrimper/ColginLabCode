fieldSelection(1) = 1; % Timestamps
fieldSelection(2) = 1; % Extracted X
fieldSelection(3) = 1; % Extracted Y
fieldSelection(4) = 0; % Extracted Angel
fieldSelection(5) = 0;  % Targets
fieldSelection(6) = 0; % Points

% Do we return header 1 = Yes, 0 = No.
extractHeader = 0;
% 5 different extraction modes, see help file for Nlx2MatVT
extractMode = 1; % Extract all data

scale_x= .357;
scale_y= .386;
vfs=29.97;  % ======= the sample frequency of video ========
% file_session = strcat(sessions{ii},'vt1.nvt');
file = 'vt1.nvt';

% [t, x, y] = Nlx2MatVT(file,fieldSelection,extractHeader,extractMode);
% ind=find(x); t=t(ind); x=x(ind); y=y(ind);

[t,x,y] = loadPos_rescaled_cz(file,1,1,vfs);
% y = -y + max(y)-min(y) + 2*max(y); %reflects posisitons so they are consistent with orientation in recording room

t_session1=t; x_session1=x*scale_x; y_session1=y*scale_y;
t_session2=t; x_session2=x*scale_x; y_session2=y*scale_y;
t_session3=t; x_session3=x*scale_x; y_session3=y*scale_y;
t_session=[t_session1,t_session2,t_session3];
x_session=[x_session1,x_session2,x_session3];
y_session=[y_session1,y_session2,y_session3];

t_session=[t_session2];
x_session=[x_session2];
y_session=[y_session2];

minx=min(x_session2);
maxx=max(x_session2);
miny=min(y_session2);
maxy=max(y_session2);

diffx=maxx-minx;
diffy=maxy-miny;


vel0=speed2D(x_session1,y_session1,t_session1); %velocity in cm/s
timelimit=120;
vel0(vel0>=timelimit) = 0.5*(vel0(circshift((vel0>=timelimit),-3)) + vel0(circshift((vel0>=timelimit),3)));

[t,x,y] = loadPos_rescaled_cz(file,1,1,vfs);
t_A1=t; x_A1=x*scale_x; y_A1=y*scale_y;
t_A2=t; x_A2=x*scale_x; y_A2=y*scale_y;
t_A22=t; x_A22=x*scale_x; y_A22=y*scale_y;
t_C=t; x_C=x*scale_x; y_C=y*scale_y;
t_B=t; x_B=x*scale_x; y_B=y*scale_y;


%
minx=min(x_session1)
maxx=max(x_session1)
miny=min(y_session1)
maxy=max(y_session1)
maxx-minx
maxy-miny
figure;
hold on
plot(x_session1,y_session1,'k');
line([minx,minx],[miny,maxy]);
line([maxx,maxx],[miny,maxy]);
hold off

% track object based on object's video
figure;
hold on
plot(x_session1,y_session1,'k');
plot(x_A1,y_A1,'r.');
plot(x_A2,y_A2,'g.');
plot(x_B,y_B,'y.');
plot(x_A22,y_A22,'y.');
plot(x_C,y_C,'y.');
hold off
axis square

center_A1=[(max(x_A1)+min(x_A1))/2,(max(y_A1)+min(y_A1))/2]
center_A2=[(max(x_A2)+min(x_A2))/2,(max(y_A2)+min(y_A2))/2]
center_B=[(max(x_B)+min(x_B))/2,(max(y_B)+min(y_B))/2]
center_A22=[(max(x_A22)+min(x_A22))/2,(max(y_A22)+min(y_A22))/2]
center_C=[(max(x_C)+min(x_C))/2,(max(y_C)+min(y_C))/2]

% track objects from the map
[obj_x,obj_y] = ginput(2)


% track object based on center of the quatrant
figure;
subplot(1,3,1);plot(x_session1,y_session1,'k'); xlim([135,180]);ylim([140,185]);
subplot(1,3,2);plot(x_session2,y_session2,'k'); xlim([135,180]);ylim([140,185]);
subplot(1,3,3);plot(x_session3,y_session3,'k'); xlim([135,180]);ylim([140,185]);

center_A1=[min(x_session)+(max(x_session)-min(x_session))*(1/4), min(y_session)+(max(x_session)-min(x_session))*(1/4)]
center_A2=[min(x_session)+(max(x_session)-min(x_session))*(1/4), min(y_session)+(max(x_session)-min(x_session))*(3/4)]
center_C=[min(x_session)+(max(x_session)-min(x_session))*(3/4), min(y_session)+(max(x_session)-min(x_session))*(1/4)]
center_A22=[min(x_session)+(max(x_session)-min(x_session))*(3/4), min(y_session)+(max(x_session)-min(x_session))*(3/4)]

A1=center_A1;
A2=center_A2;
C=center_C;
A22=center_A22;

figure;
subplot(1,3,1);
hold on
plot(x_session1,y_session1,'k'); xlim([135,180]);ylim([140,185]);
scatter(A1(1),A1(2),'r');scatter(A2(1),A2(2),'g');
hold off

subplot(1,3,2);
hold on
plot(x_session2,y_session2,'k'); xlim([135,180]);ylim([140,185]);
scatter(A1(1),A1(2),'r');scatter(C(1),C(2),'y');
hold off

subplot(1,3,3);
hold on
plot(x_session3,y_session3,'k'); xlim([135,180]);ylim([140,185]);
scatter(A1(1),A1(2),'r');scatter(A2(1),A2(2),'g');
hold off