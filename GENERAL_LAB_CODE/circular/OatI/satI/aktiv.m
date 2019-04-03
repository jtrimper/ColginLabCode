%function [akt]=aktiv(sample,cage)
%global X
%global loaded
%
%
%loaded
[X,loaded]=chkld(cage,X,loaded);
akt=sum(X(sample,vnrld(cage,loaded))')';
%end
