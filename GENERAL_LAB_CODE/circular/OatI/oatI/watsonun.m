function [Un,n]=watsonun(x)
%
% CALL: [Un]=watsonun(x)
%
z=sort(x);
n=length(z);
c=2*[1:n]-1;
v=z/360;
Un=sum(v.^2)-sum(c.*v)/n+n*(1/3-(mean(v)-0.5)^2);
end
