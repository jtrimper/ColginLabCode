load klimenv.dat
X=klimenv;
load klimsynt.dat
Y=klimsynt;
I=eye(9);
Onio=zeros(9,2);
Ostn=zeros(16,2);
S=Y'*Y;
[Q,L]=eig(S);
D1=eye(16);
D=sqrt(abs(L));
for j=1:16
  D1(j,j)=1.0/sqrt(abs(L(j,j)));
end
P=Y*Q;
G=[P(:,1)/sqrt(D(1,1)),P(:,2)/sqrt(D(2,2))];
H=[sqrt(D(1,1))*Q(:,1),sqrt(D(2,2))*Q(:,2)];
plot(G(:,1),G(:,2),'o','markersize',10)
hold on;
for j=1:9
line([0,G(j,1)],[0,G(j,2)]);
end
plot(H(:,1),H(:,2),'.','markersize',30)
for j=1:16
line([0,H(j,1)],[0,H(j,2)]);
end
hold off;



