[A,r2,n,co]=circac(M); 
for k=1:1,
psi=co(k);
l1=cos(psi)*r2*A(2)-sin(psi)*r2*A(1);
l2=sin(psi)*r2*A(2)+cos(psi)*r2*A(1);
if (k==1),
  plot([0;l1/r2],[0;l2/r2],'w:');
else
  plot([0;l1/r2],[0;l2/r2],'w--');
end
psi=-co(k);
l1=cos(psi)*r2*A(2)-sin(psi)*r2*A(1);
l2=sin(psi)*r2*A(2)+cos(psi)*r2*A(1);
%plot([0;l1/r2],[0;l2/r2],'w:');
if (k==1),
  plot([0;l1/r2],[0;l2/r2],'w:');
else
  plot([0;l1/r2],[0;l2/r2],'w--');
end
psi=co(k);
l1=-cos(psi)*r2*A(2)+sin(psi)*r2*A(1);
l2=-sin(psi)*r2*A(2)-cos(psi)*r2*A(1);
%plot([0;l1/r2],[0;l2/r2],'w:');
if (k==1),
  plot([0;l1/r2],[0;l2/r2],'w:');
else
  plot([0;l1/r2],[0;l2/r2],'w-.');
end
psi=-co(k);
l1=-cos(psi)*r2*A(2)+sin(psi)*r2*A(1);
l2=-sin(psi)*r2*A(2)-cos(psi)*r2*A(1);
%plot([0;l1/r2],[0;l2/r2],'w:');
if (k==1),
  plot([0;l1/r2],[0;l2/r2],'w:');
else
  plot([0;l1/r2],[0;l2/r2],'w-.');
end
end
