function [r]=recur(k)
%
%
if k>1,
  r=k*recur(k-1);
else
  r=1;
end
