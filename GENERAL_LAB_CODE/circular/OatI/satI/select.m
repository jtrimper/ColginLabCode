function [R,S]=select(M,U)
% Put in R the rows of M for which U>0.5. Put in S the row numbers of 
% the selected rows.
%
% CALL: [R,S]=select(M,U);
%
% where 
%     
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., University of Lund.

if (nargin == 2)
  [rows cols]=size(M); j=0;
%  disp(['  Included: '])
  for i=1:rows,
    if (U(i)>0.5)
      j=j+1;
     for k=1:cols,
      R(j,k)=M(i,k); 
     end
      S(j,1)=i;
    end
  end
  else
  disp(['  2 parameters needed!'])
end







