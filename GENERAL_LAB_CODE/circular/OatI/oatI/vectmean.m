function [a,r]=vectmean(x)
%
% vectmean([l,M])
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., University of Lund.
[rx,cx]=size(x);
l=x(:,1); 
if cx==1,
  M=ones(length(l),1);
else
  M=x(:,2);
end
[rm cm]=size(M);
Cc=0.0; Ss=0.0;  n=0;
for i=1:rm,
  if (finite(M(i,1))&finite(l(i,1))),
    Cc=Cc+l(i,1)*cos(pi*M(i,1)/180.0); Ss=Ss+l(i,1)*sin(pi*M(i,1)/180.0);  
    n=n+1.0;
  end
end;
 r=sqrt(Cc*Cc+Ss*Ss)/n;
 A(1)=Cc/(n*r); A(2)=Ss/(n*r); a=atan2(A(2),A(1));
 if (a<0), 
   a=a+2*pi; 
 end
 a=a*180/pi;
%end
