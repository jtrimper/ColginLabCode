function o=iqr(x)
%
% CALL: r=iqr(x);
%
%      Returns the inter quartile range.

xs=sort(x);
n=length(x);
r=xs(floor(0.75*n))-xs(floor(0.25*n));
%end fcn
