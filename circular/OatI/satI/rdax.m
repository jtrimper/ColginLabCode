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
G=[P(:,16),P(:,15)];
H=[D(16,16)*Q(:,16),D(15,15)*Q(:,15)];
plot(G(:,1),G(:,2),'*')
hold on;
plot(H(:,1),H(:,2),'o')




