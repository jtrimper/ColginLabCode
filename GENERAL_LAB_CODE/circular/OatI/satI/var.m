function [s2,N]=var(x)
%
% CALL:
%    
%   [v]=var(x)
%   [v,n]=var(x)
%
%   var(x) returns the variance of the elements of x
%   [v,n]=var(x) returns the variance of x in v and the number of elements
%   of x in n
%
n=length(x);
C=sum(x);
C2=sum(x.^2);
s2=(C2-C.^2/n)/(n-1);
%end fcn

