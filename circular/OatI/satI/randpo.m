function [u]=randpo(m0,M,N)
%
% CALL x=randpo(m)
%      x=randpo(m,M)
%      x=randpo(m,M,N)
%
if (nargin<3), N=1; end
if (nargin<2), M=1; end
[a,b]=size(m0);
if a*b>1, 
 for j1=1:a,
 for j2=1:b,
      m=m0(j1,j2);   
   v=rand;
for k=0:10*m,
  if ((pocdf(k-1,m)<=v)&(v<pocdf(k,m))),
    u(j1,j2)=k;
  break;
  end
end
 end
 end

else
for j1=1:M,
for j2=1:N,
v=rand;
for k=0:10*m,
  if ((pocdf(k-1,m)<=v)&(v<pocdf(k,m))),
    u(j1,j2)=k;
  break;
  end
end
end
end
end
