function misessim2(tabfil)
N=20000;
T0=T([0:0.01:0.99]);
L=length(T0)-1;
mu=0; kappa=1; n=10;
for n=10:10:20,
n
for mu=0:20:100,
mu
ant2=0;
%titel=['T3p1o: mu=',num2str(mu),', kappa=',num2str(kappa),', n=',int2str(n)];
%titel=['TM   : mu=',num2str(mu),', kappa=',num2str(kappa),', n=',int2str(n)];
titel=['TS   : mu=',num2str(mu),', kappa=',num2str(kappa),', n=',int2str(n)];
for k=1:N,
%k
x=vm(kappa,mu,n,'deg');
[A,r,n]=circmean(x);
z=r*A(1); y=r*A(2);
%TM=n*(t(r)-max(0,t(z)));
if (z>0),
 % TM=n*(t(r)-t(z))
%TM=n*(T0(1+floor(r*L))-T0(1+floor(z*L)));
TS=n*(T0(1+floor(r*L))-T0(1+floor(z*L)));
else
 % TM=n*t(r);
%TM=n*T0(1+floor(r*L));
TS=n*(T0(1+floor(r*L))-T0(1+floor(-z*L)));
end
%T3p1o=n*1.126*(0.912*z+2)^(0.574+0.584*abs(y))*abs(y)^(2-0.144*z);
%TM-T3p1o
%if TM>3.841, ant2=ant2+1; end
if TS>3.841, ant2=ant2+1; end
%if T3p1o>3.841, ant2=ant2+1; end
end
if ((n==10)&(mu==0)),
  fp=fopen(tabfil,'w');
else
  fp=fopen(tabfil,'a');
end
fprintf(fp,'\n');
fprintf(fp,[titel '  : ']);
fprintf(fp,[int2str(ant2) '  ' num2str(N) '  ' num2str(ant2/N) '   ']);
stat=fclose(fp);
end %for mu
end %for n
%end fcn

