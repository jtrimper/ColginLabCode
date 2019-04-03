load klimenv.dat
X=klimenv;
load klimsynt.dat
Y=klimsynt;
I=eye(9);
S=Y'*(I-X*inv(X'*X)*X')*Y;
[Q,L]=eig(S);
lett=L(1,1);
ltwo=L(2,2);
D=sqrt(abs(L));
S=X'*X;
[U,M]=eig(S);
mett=M(5,5);
mtwo=M(4,4);
P=Y*Q;
c=0.4;
G=[exp(c*log(lett)/2)*P(:,1)/sqrt(lett),exp((1-c)*log(ltwo)/2)*P(:,2)/sqrt(ltwo)];
H=[exp((1-c)*log(lett)/2)*Q(:,1),exp((1-c)*log(ltwo)/2)*Q(:,2)];
A=[exp(c*log(lett/mett)/2)*P(:,1)/lett,exp((1-c)*log(ltwo/mtwo)/2)*P(:,2)/ltwo];
V=X'*A;
plot(G(:,1),G(:,2),'.','markersize',30)
hold on;
plot(V(:,1),V(:,2),'*','markersize',10)
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
for j=1:5
line([0,V(j,1)],[0,V(j,2)]);
end
text(1.05*V(1,1),1.05*V(1,2),'1')
text(1.05*V(2,1),1.05*V(2,2),'2')
text(1.05*V(3,1),1.05*V(3,2),'3')
text(1.05*V(4,1),1.05*V(4,2),'4')
text(1.05*V(5,1),1.05*V(5,2),'5')
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
text(1+H(12,1),1+H(12,2),'L')
text(1+H(13,1),1+H(13,2),'M')
text(1+H(14,1),1+H(14,2),'N')
text(1+H(15,1),1+H(15,2),'O')
text(1+H(16,1),1+H(16,2),'P')
hold off;



