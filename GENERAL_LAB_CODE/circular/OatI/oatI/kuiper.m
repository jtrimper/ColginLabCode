function [Vn,K,V]=kuiper(x)
%
% CALL kuiper(x)
%
% where   x  = a vector of angles (in degrees)
%
% Test of uniformity of ungrouped data against any alternative.
% Copyright: Björn Holmquist, Dept of Math Stat. Lund University 
%            1995
   y=sort(x);
   n=length(y);
   x=y/(2*pi);
   Dnp=max(x-[0:n-1]'/n);
   Dnm=max([1:n]'/n-x);
   Vn=Dnp+Dnm;
   K=sqrt(n)*Vn;
   V=Vn*(sqrt(n)+0.155+0.24/sqrt(n));
end
