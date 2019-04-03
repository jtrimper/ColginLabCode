function [test]=dotest(p)
%
% CALL : 
%        [test]=dotest(p)
%
%        where 
%               p    = the extreme probability of the test statstic
%               test = the significance.
%
if (p>0.05), test='NS'; end
if (p<0.05), test='*'; end
if (p<0.01), test='**'; end
if (p<0.001), test='***'; end
%end fcn

                                   
