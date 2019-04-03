function [Rx,Ry,p,z,test]=wilcoxon(x,y)
%
% CALL : 
%          [Rn,Rp,p,z,test]=wilcoxon(x,m0)
%          [Rx,Ry,p,z]=wilcoxon(x,y)
%
%   where   
%           x    = vector of values from sample 1
%           y    = vector of values from sample 2
%           p    = the extreme probability for the actual configuration
%           test = NS,*,**,*** depending on the extreme probability
[r,c]=size(x);
if (r>c), x=x'; end
if nargin>1,
[r,c]=size(y);
if (r>c), y=y'; end
end
nx=length(x); 
if (nargin==1), 
  samp=1; 
  m=0; 
else
 ny=length(y);
 if (ny>1),
   samp=2;
 else 
   m=y;
   samp=1;
 end
end
samp
if (samp==2),
  z=[x,y];
  [a,i]=sort(z);
  jx=0; jy=0;
  for k=1:length(z),
    if (i(k)<=nx),
      jx=jx+1;
      Rx(jx)=k;
    end
    if (i(k)>nx),
      jy=jy+1;
      Ry(jy)=k;
    end
  end
  rx=sum(Rx); ry=sum(Ry);
  if (nx+ny<=6),
    Z=permut(1:nx+ny);
    [r,c]=size(Z);
    p=0;
    for k=1:r,
      a=sum(Z(k,1:nx));
      if (a<=rx), p=p+1; end
    end
    p=p/r;
    z=0;
  end
% p=0;
  Ux=rx-nx*(nx+1)/2;
%  z=(Ux+0.5-nx*ny/2)/sqrt(nx*ny*(nx+ny+1)/12);
  z=(Ux-nx*ny/2)/sqrt(nx*ny*(nx+ny+1)/12);
  p=1-ncdf(abs(z));
end
if (samp==1),
  u=x-m;
  [a,i]=sort(abs(u));
  rp=0; rn=0;
  for k=1:length(u);
    if (u(i(k))<0), rn=rn+i(k); end
    if (u(i(k))>0), rp=rp+i(k); end
  end
  Rx=rn; Ry=rp; 
  z=(Rx-nx*(nx+1)/4)/sqrt(nx*(nx+1)*(nx+nx+1)/24);
  p=1-ncdf(abs(z));
%  load wilcox
  load wilcoxon.tab
  if ((length(u)<=13)&(Rx<=18)), p=table2(wilcoxon,Rx,length(u)); end
end
test=dotest(p);
end

                                   
