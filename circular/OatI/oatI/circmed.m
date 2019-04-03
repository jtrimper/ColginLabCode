function [med,d,n,thr,ths]=circmed(M,qnt)
%
% CALL: 
%
%     [med,d,n,thr,ths]=circmed(x,qnt)
%
%  where
%         med  = is a median direction
%         thr,
%         ths  = limits of a confidence set for the median direction
%         x    = vector of directions (in degrees)
%         qnt  = confidence 
%
% Copyright 1993, Björn Holmquist, Dept of Math. Stat., Lund University.
if (nargin<2),
  qnt=95;
end
if qnt<1,
   qnt=100*qnt;
end
[rm cm]=size(M);
j=0;
for i=1:rm,
  if (finite(M(i))),
     j=j+1;
     x(j)=M(i)*pi/180;;
  end
end;
n=length(x);
nh=zeros(n,1); nv=zeros(n,1);
for i=1:n,
  for j=1:n,
    if j~=i,
      if cos(x(i)+pi/2-x(j))>=0, nv(i,1)=nv(i,1)+1; % # obs in (x(i),x(i)+pi)
      end
      if cos(x(i)-pi/2-x(j))>=0, nh(i,1)=nh(i,1)+1; % # obs in (x(i)-pi,x(i))
      end
    end;
  end
end
 nn=nh-nv; ii=0;
 for i=1:n,
   if nn(i)==0,
    ii=i;
   end;
 end;
 if ii~=0, mm=x(ii); end
 if ii==0,
   for i=1:n,
     if nn(i)==1,
      ii1=i;
     end;
     if nn(i)==-1,
      ii2=i;
     end;
   end;
   med=(x(ii1)+x(ii2))/2; med=med*180/pi;
 end
for j=0:n,
  if (bincdf(j,n,0.5)<=(1-qnt/100)/2),
    r=j;
  end
end
s=n-r;
 [Y,I]=sort(nh);
for j=1:n,
  if (r>=Y(j)),
    j0=j;
  end;
end
for j=n:-1:1,
  if (s<=Y(j)),
    j1=j;
  end;
end
thr=x(I(j0))*180/pi;
ths=x(I(j1))*180/pi;
%end



