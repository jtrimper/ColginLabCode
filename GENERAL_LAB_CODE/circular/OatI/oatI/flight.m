function [pos]=flight(r,dir,len,step,stlat,stlon)
%
% CALL: [pos]=flight(conc,dir,len,step,stlat,stlon)
%
% where dir   = direction in degrees 
%       r  = concentration
%       len   = length 
%       step  = number of steps
%       stlat = start latitude
%       stlon = start longitude
%
jordrad=6360;
latradie=jordrad*cos(stlat*pi/180);
niter=step;
if (r<0.99999999999), conc=ainv(r); 
else conc=3000000000;
end
slumptal=vm(conc,dir,niter,'deg');
c=cos(pi*(90-slumptal)/180); s=sin(pi*(90-slumptal)/180);
x=[0;cumsum(len*c)]; y=[0;cumsum(len*s)];
plot(x,y,'-');
%text(x(1),y(1),'start');
text(x(niter+1),y(niter+1),'stop');
%pos=[x(niter+1),y(niter+1)];
lat=stlat+90*y(niter+1)/(jordrad*2*pi/4);
long=stlon+360*x(niter+1)/(latradie*2*pi);
latmin=(lat-floor(lat))*60;
longmin=(long-floor(long))*60;
pos=[floor(lat),latmin,floor(long),longmin];
%end fcn
