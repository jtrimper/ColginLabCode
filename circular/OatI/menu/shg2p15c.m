[B,c,n,co]=circac(M); 
psi=-(co(5)-atan2(B(2),B(1)));
l1=cos(psi)*c*B(2)-sin(psi)*c*B(1);
l2=sin(psi)*c*B(2)+cos(psi)*c*B(1);
plot([0;l1/c],[0;l2/c],'w-.');
psi=-(co(4)-atan2(B(2),B(1)));
l1=cos(psi)*c*B(2)-sin(psi)*c*B(1);
l2=sin(psi)*c*B(2)+cos(psi)*c*B(1);
plot([0;l1/c],[0;l2/c],'w-.');
psi=-(co(6)-atan2(B(2),B(1))-pi);
l1=cos(psi)*c*B(2)-sin(psi)*c*B(1);
l2=sin(psi)*c*B(2)+cos(psi)*c*B(1);
plot([0;l1/c],[0;l2/c],'w-.');
psi=-(co(7)-atan2(B(2),B(1))-pi);
l1=cos(psi)*c*B(2)-sin(psi)*c*B(1);
l2=sin(psi)*c*B(2)+cos(psi)*c*B(1);
plot([0;l1/c],[0;l2/c],'w-.');
end
