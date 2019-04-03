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
plot(G(:,1),G(:,2),'.','markersize',30)
hold on;
for j=1:9
line([0,G(j,1)],[0,G(j,2)]);
end
text(1.05*G(1,1),1.05*G(1,2),'1')
text(1.05*G(2,1),1.05*G(2,2),'2')
text(1.05*G(3,1),1.05*G(3,2),'3')
text(1.05*G(4,1),1.05*G(4,2),'4')
text(1.05*G(5,1),1.05*G(5,2),'5')
text(1.05*G(6,1),1.05*G(6,2),'6')
text(1.05*G(7,1),1.05*G(7,2),'7')
text(1.05*G(8,1),1.05*G(8,2),'8')
text(1.05*G(9,1),1.05*G(9,2),'9')
plot(H(:,1),H(:,2),'o','markersize',10)
for j=1:16
line([0,H(j,1)],[0,H(j,2)]);
end
text(1+H(1,1),1+H(1,2),'A')
text(1+H(2,1),1+H(2,2),'B')
text(1+H(3,1),1+H(3,2),'C')
text(1+H(4,1),1+H(4,2),'D')
text(1+H(5,1),1+H(5,2),'E')
text(1+H(6,1),1+H(6,2),'F')
text(1+H(7,1),1+H(7,2),'G')
text(1+H(8,1),1+H(8,2),'H')
text(1+H(9,1),1+H(9,2),'I')
text(1+H(10,1),1+H(10,2),'J')
text(1+H(11,1),1+H(11,2),'K')
text(1+H(12,1),1+H(12,2),'M')
text(1+H(13,1),1+H(13,2),'N')
text(1+H(14,1),1+H(14,2),'O')
text(1+H(15,1),1+H(15,2),'P')
text(1+H(16,1),1+H(16,2),'Q')
hold off;



