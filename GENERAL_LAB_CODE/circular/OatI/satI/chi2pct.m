function [cp]=chi2pct(p,nu);
%
% CALL: chi2pct(p,nu)
%
% Not very accurate for small nu!
xp=npct(p);
cp=nu*(1-2/(9*nu)+xp*sqrt(2/(9*nu)))^3;


