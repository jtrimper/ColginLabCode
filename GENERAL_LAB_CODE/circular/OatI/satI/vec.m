function [x]=vec(X)
%
%
% CALL:
%
%   [x]=vec(X)
%
[n,p]=size(X);
x=[];
for j=1:p,
  x=[x;X(:,j)];
end
%end
