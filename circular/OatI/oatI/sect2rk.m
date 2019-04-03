function [R,N,A1,A2,A]=sect2rk(Z,D)
%
% CALL [R,N,A1,A2,A]=sect2rk(Z,D)
% 
%   where  Z  = row vector of counts
%          D  = row vector of directions for the sectors
%          R  = vector length
%          N  = activity
%          A1 = cos mean direction, axis etc.
%          A2 = sin       - " -
%          A  = mean direction, axis etc.
%         
%   If Z ond D are matrices, the procedure is repeated for each row.
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., University of Lund.
[rm cm]=size(Z);
[rd,cd]=size(D);
if (rd==1), D=ones(rm,1)*D;
end
for i=1:rm,
 for k=1:cm,
  Cc=0.0; Ss=0.0; n=0;
  for j=1:cm,
    if (finite(Z(i,j))),
      Cc=Cc+Z(i,j)*cos(k*pi*D(i,j)/180.0);
      Ss=Ss+Z(i,j)*sin(k*pi*D(i,j)/180.0);  
      n=n+Z(i,j);
    end
  end % j
  N(i)=n;
  R(i,k)=sqrt(Cc*Cc+Ss*Ss)/n;
  r=R(i,k);
  if (nargout>2),
    A1(i,k)=Cc/(n*r); A2(i,k)=Ss/(n*r); a=atan2(A2(i,k),A1(i,k));
    if (a<0), a=a+2*pi; end
%    A(i,k)=180*a/pi;
   A(i,k)=180*a/pi/k;
  end
 end % k
i
end  % i
end
