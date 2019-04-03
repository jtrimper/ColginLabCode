function [P]=chi2sim(x,p,sim)
%
%
%
L=length(x);
if (L==2),
X0=chi2(x,p);
ant=0; n=sum(x);
if (nargin<3), 
  s=100; 
else 
  s=sim;
end
for k=1:s,
 x(1)=randbin(n,p(1)); x(2)=n-x(1);
 X=chi2(x,p);
 if (X>X0), ant=ant+1; end
end
P=ant/sim;
%x=randbin(n,p(1),s,1); x=[x,n-x];
%X=chi2(x,p);
%ant=sum(X>X0);
end
end
