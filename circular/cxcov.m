% CXCOV Circular Cross Covariance function estimates. 
% CXCOV(a,b), where a and b represent samples taken over time interval T, 
% which is assumed to be a common period of two corresponded periodic signals. 
% a and b are supposed to be length M row vectors, either real or complex.
% 
% [x,c]=CXCOV(a,b) returns the length M-1 circular cross covariance sequence c
% with corresponded lags x.
%   
% The circular cross covariance is the normalized circular cross correlation function of
% two vectors with their means removed:
%         c(k) = sum[a(n)-mean(a))*conj(b(n+k)-mean(b))]/[norm(a-mean(a))*norm(b-mean(b))]; 
% where vector b is shifted CIRCULARLY by k samples.
%
% The function doesn't check the format of input vectors a and b!
%
% For circular correlation between a and b look for CXCORR(a,b) in
% http://www.mathworks.com/matlabcentral/fileexchange/loadAuthor.do?objectType=author&objectId=1093734
%
% Reference:
% A. V. Oppenheim, R. W. Schafer and J. R. Buck, Discrete-Time Signal Processing, 
% Upper Saddler River, NJ : Prentice Hall, 1999.
%
% Author: G. Levin, Apr. 26, 2004.

function [x,c]=CXCOV(a,b)
ma=mean(a);
mb=mean(b);
sa=std(a)*sqrt(length(a)-1);
sb=std(b)*sqrt(length(b)-1);
a=(a-ma)/sa; %normalization
b=(b-mb)/sb; %normalization
for k=1:length(b)
    c(k)=a*b';
    b=[b(end),b(1:end-1)]; %circular shift
end
x=[0:length(b)-1]; %lags