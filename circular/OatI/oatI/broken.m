function [rmax,kst,n,a1,a2,a,ak]=broken(x,l)
%
% CALL: broken(x)
%       [r,k,a1,a2,n]=broken(x,l)
%
% where   x  = is a column vector of angles (in degrees) 
%
%
% 1999-02-15
MAXk=20;
if (nargin>1),
  [rk,n,a1,a2,a]=dir2rk(x,l);
else
  l=[0:0.05:MAXk];
%  rk=dir2rk(x);
  [rk,n,a1,a2,a]=dir2rk(x,l);
end
if nargout==0,
if (nargin>1),
  ant=length(l);
  plot(l,rk([1:ant]));
else
%  plot([0:5],rk([1:6]));
%  plot([0:MAXk],rk([1:MAXk+1]));
  plot(l,rk);
end
end
u=sum((l<1));
[rmax,k]=max(rk([u+1:length(rk)]));
k=k+u;
kst=l(k);
y=sort(kst*x)
%y=sort(mod(kst*x,360)); %1999-02-15
ak=a(1,k)
m1=mean(y(1:n/2))
m2=mean(y(n/2+1:n))
amax=100000;
for ell=-20:20,
     if abs(ak+ell*360-m1)<amax,
       n1=ell;
       amax=abs(ak+ell*360-m1);
     end
end
amax=100000;
for ell=-10:10,
  if abs(ak+ell*360-m2)<amax,
     n2=ell;
     amax=abs(ak+ell*360-m2);
  end
%  ell
%  amax=abs(ak+ell*360-m2)
end
if ak+n1*n1*360>m1, am1=(ak+n1*360)/kst;
else
  am1=(ak+(n1+1)*360)/kst;
  end
if ak+n2*360>m2, am2=(ak+n2*360)/kst;
else
  am2=(ak-(n2+1)*360)/kst;
  end

if nargout==0,
  hold on
  %plot([u;u],[0;r],'--');
%  barplot(l(u+k-1),r);
end
n=length(x);
a1=[cos(pi*am1/180),sin(pi*am1/180)]';
a2=[cos(pi*am2/180),sin(pi*am2/180)]';
a=[am1,am2];
%end


