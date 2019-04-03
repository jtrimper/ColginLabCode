function [Tmax]=maxspace(x)
%
% CALL maxspace(x)
%
% where   x  = a vector of angles (in degrees)
%
% Test of uniformity of ungrouped data against any alternative.
% Copyright: Björn Holmquist, Dept of Math Stat. Lund University 
%            1995
   y=sort(x)*pi/180;
   n=length(y);
   T=diff(y); T(n)=2*pi-y(n)+y(1);
   Tmax=max(T); w=2*pi-Tmax;
end



