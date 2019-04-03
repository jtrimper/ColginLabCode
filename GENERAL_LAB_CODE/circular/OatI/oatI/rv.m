function [r,v,d]=rV(X,U)
% Put in T the result of the boolean comparison of M and U. 
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., University of Lund.
  [p k]=size(U); %disp([' k= ',num2str(k)])
  ettk=ones(k,1);
  E=eye(k)-ettk*ettk'/k;
  r=trace(X'*U*E)/trace(U'*U*E);
  v=(X*ettk-r*U*ettk)/k;
  d=U*ettk;







U/k)*(z-U'*X*ettk/k);
  d=U*ettk;








