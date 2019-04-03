Y=[H(1,:),H(2,:),H(3,:)];
Y=[Y,H(4,:),H(5,:),H(6,:)];
Y=[Y,H(7,:),H(8,:),H(9,:),H(10,:)];
eps=0.001;
X=[ones(nz*ny,1),kron(ones(nz,1),log(eps+y')),kron(log(eps+z'),ones(ny,1))];
%X=[X,kron(ones(nz,1),y'.*y'),kron(z'.*z',ones(ny,1)),kron(z',y')];
[b,s]=multreg(X,log(eps+Y'))
haty=X*b;
hatH=[haty(1:10)';haty(11:20)';haty(21:30)';haty(31:40)';haty(41:50)';haty(51:60)'];
hatH=[hatH;haty(61:70)';haty(71:80)';haty(81:90)';haty(91:100)'];
mesh(z',y',exp(hatH))
%print fighathfunc
%print
%mesh(z',y',H)
