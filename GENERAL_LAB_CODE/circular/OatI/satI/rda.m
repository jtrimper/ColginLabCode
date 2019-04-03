load klimenv.dat
X=klimenv;
load klimsynt.dat
Y=klimsynt;
I=eye(9);
S=Y'*Y;
[Q,L]=eig(S);
D1=eye(16);
D=sqrt(abs(L));
for j=1:16
  D1(j,j)=1.0/sqrt(abs(L(j,j)));
end
P=Y*Q;
G=[P(:,1),P(:,2)];
H=[D(1,1)*Q(:,1),D(2,2)*Q(:,2)];
plot(G(:,1),G(:,2),'*')
hold on;
plot(H(:,1),H(:,2),'o')




