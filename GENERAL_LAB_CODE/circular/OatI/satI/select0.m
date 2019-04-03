function [T]=select(M,U,V)
% Put in T the result of the boolean comparison of M and U. 
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., University of Lund.

if (nargin == 3)
  [rows cols]=size(M); j=0;
  disp(['  Included: '])
  for i=1:rows
    if (U(i)==V(i))
      j=j+1;
      for k=1:cols
        T(j,k)=M(i,k); %1;
      end 
      disp([i])
    end
  end
  else
  disp(['  3 parameters needed!'])
end







