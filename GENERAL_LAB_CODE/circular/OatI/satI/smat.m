function [Sut]=smat(p,r)
% 
% CALL [S]=smat(p,r)    
%
sum=zeros(p^r,p^r);
Perm=permut([1:r]);
[rp,cp]=size(Perm);
Z=zr([1:p],r);
[rz,cz]=size(Z);
for s=1:rp,
for j=1:rz,
  i=Z(j,:);
  A=permut(i);
  di=lexico(A(s,:),p);
  dj=lexico(i,p);
  sum(di,dj)=sum(di,dj)+1;
end
end
Sut=sum/fac(r);
end

