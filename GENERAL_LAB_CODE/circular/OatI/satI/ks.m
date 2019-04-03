function [Dn,Dnp,Dnm,P,test]=ks(x,y,s)
%
% CALL : [Dn,Dnp,Dnm,P,test]=ks(x,m,s)
%        [Dn,Dnp,Dnm,P,test]=ks(x,y)
%
%   where   
%           Dn    = the maximum absolute deviation,
%           Dnp   = the maximum positive deviation, 
%           Dnm   = the maximum negative deviation,
%           P     = the extreme probability for the actual absolute deviation,
%           test  = NS,*,**,*** depending on the extreme probability.
ny=length(y);
samp=2;
if (ny==1), 
  samp=1;
  m=y; 
end
n=length(x);
if (nargin<3), s=1; end
if (nargin<2), m=0; samp=1; end
if (samp==1),
  [Fn,IFn]=fnifn(x);
  Dn=max(abs(ecdf(IFn,x)-ncdf((IFn-m)/s)));
  Dnp=max(ecdf(IFn,y)-ncdf((IFn-m)/s));
  Dnm=max(-(ecdf(IFn,x)-ncdf((IFn-m)/s)));
  z=sqrt(n)*Dn; sum=0;
%  for k=0:n(1-u),
%    sum=sum+binom(n,k)(u+k/n)^(k-1)*u*(1-u-k/n)^(n-k);
%  end
  px=sum;
  sum=0;
  for k=1:30;
    sum=sum+2*(-1)^(k-1)*exp(-2*k^2*z^2);
  end
  pa=sum;
end
if (samp==2),
  [Fnxy,IFnxy]=fnifn([x;y])
  Dn=max(abs(ecdf(IFnxy,y)-ecdf(IFnxy,x)));
  Dnp=max(ecdf(IFnxy,y)-ecdf(IFnxy,x));
  Dnm=max(-(ecdf(IFnxy,y)-ecdf(IFnxy,x)));
  z=Dn;
  sum=0;
  for k=1:30;
    sum=sum+2*(-1)^(k-1)*exp(-2*k^2*z^2);
  end
end
P=sum;
test=dotest(P);
%if (P>0.05), test='NS'; end
%if (P<0.05), test='*'; end
%if (P<0.01), test='**'; end
%if (P<0.001), test='***'; end
end

                                   
