function [L]=raospace(x)
%
% CALL raospace(x)
%
% where   x  = a vector of angles (in degrees)
%
% Test of uniformity of ungrouped data against any alternative.
% Copyright: Björn Holmquist, Dept of Math Stat. Lund University 
%            1995
   y=sort(x)*pi/180;
   n=length(y);
   T=diff(y); T(n)=2*pi-y(n)+y(1);
   L=0.5*sum(abs(T-2*pi/n));
end



