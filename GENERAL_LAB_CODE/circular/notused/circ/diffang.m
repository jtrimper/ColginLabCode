function DAng=diffang(Angle1,Angle2)
% diffang: just subtracts to angle2 from angle 1 and reifies it between 
%				-180 and 180
% DAng=diffang(Angle1,Angle2)
DAng=Angle1-Angle2;
x=find(DAng<-180);
DAng(x)=DAng(x)+360;
x=find(DAng>180);
DAng(x)=DAng(x)-360;