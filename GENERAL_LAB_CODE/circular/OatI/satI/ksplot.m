function [Dn,Dnp,Dnm,P,test]=ksplot(y,m,s)
%
% CALL : [Dn,Dnp,Dnm,P,test]=ks(y,m,s)
%
%   where   
%           Dn    = the maximum absolute deviation,
%           Dnp   = the maximum positive deviation, 
%           Dnm   = the maximum negative deviation,
%           P     = the extreme probability for the actual absolute deviation,
%           test  = NS,*,**,*** depending on the extreme probability.
n=length(y);
if (nargin<3), s=1; end
if (nargin<2), m=0; end
[Fn,IFn]=fnifn(y);
Dn=max(abs(ecdf(IFn,y)-ncdf((IFn-m)/s)));
Dnp=max(ecdf(IFn,y)-ncdf((IFn-m)/s));
Dnm=max(-(ecdf(IFn,y)-ncdf((IFn-m)/s)));
z=sqrt(n)*Dn; sum=0;
for k=1:100;
  sum=sum+2*(-1)^(k-1)*exp(-2*k^2*z^2);
end
P=sum;
stairs(IFn,Fn); hold on 
%plot(IFn,ncdf(IFn,m,s));
xmi=min(IFn); xma=max(IFn); stp=(xma-xmi)/100;
plot([xmi:stp:xma],ncdf([xmi:stp:xma],m,s));
if (P>0.05), test='NS'; end
if (P<0.05), test='*'; end
if (P<0.01), test='**'; end
if (P<0.001), test='***'; end
%end

                                   


