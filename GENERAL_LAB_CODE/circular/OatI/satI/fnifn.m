function [Fn,InvFn]=FNIFN(x)
%
% CALL: [Fn,InvFn]=FNIFN(x)
%
InvFn=sort(x);
n=length(x);
Fn=[1:n]'/n;
end
