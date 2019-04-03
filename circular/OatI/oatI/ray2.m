load windtwo.dat
X=windtwo;
S=8;
for T=1:60
Q0=0.0
for j=1:S
 Z(j)=X(T,j+1);
end
for K=1:4
C0=0.0;
S0=0.0;
N=0
for j=1:S
 C0=C0+Z(j)*cos(K*(j-1)*2*pi/S);
 S0=S0+Z(j)*sin(K*(j-1)*2*pi/S);
 N=N+Z(j)
end
R=sqrt(C0*C0+S0*S0)/N;
Q0=Q0+R;
Rk(K)=R;
Xk(K)=K;
Nu(K)=2*N*Rk(K)*Rk(K)
end
hold on;
plot(Xk,Rk/Q0,'-')
hold off;
end;


