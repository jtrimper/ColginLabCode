load klimenv.dat
X=klimenv;
load klimsynt.dat
Y=klimsynt;
I=eye(9);
ett=ones(9,1);
S=Y'*(I-ett*inv(ett'*ett)*ett')*Y;
[Q,L]=eig(S);
D=sqrt(abs(L));
P=Y*Q;
G=[P(:,1)/sqrt(D(1,1)),P(:,2)/sqrt(D(2,2))];
H=[sqrt(D(1,1))*Q(:,1),sqrt(D(2,2))*Q(:,2)];
plot(G(:,1),G(:,2),'-');
hold on;
plot(G(1,1),G(1,2),'o','markersize',10)
plot(H(:,1),H(:,2),':')
plot(H(1,1),H(1,2),'.','markersize',30)
hold off;



