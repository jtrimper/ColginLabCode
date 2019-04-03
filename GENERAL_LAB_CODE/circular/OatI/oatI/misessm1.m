ant1=0;
ant2=0;
N=200000;
mu=0;
for k=1:N,
%k
x=vm(1,mu,10,'deg');
[A,r,n]=circmean(x);
z=r*A(1); y=r*A(2);
%TM=n*(t(r)-max(0,t(z)));
T3p1o=n*1.126*(0.912*z+2)^(0.574+0.584*abs(y))*abs(y)^(2-0.144*z);
%TM-T3p1o
%if TM>3.841, ant1=ant1+1; end
if T3p1o>3.841, ant2=ant2+1; end
%disp([ant1/k '  ' ant2/k])
end %for k
ant2
