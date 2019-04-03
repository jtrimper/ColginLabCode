function [Put]=pmat(p,r,perm)
% 
% CALL [P]=pmat(p,r,perm)    
% Ej klar
sum=zeros(p^r,p^r);
Z=zr([1:p],r);
[rz,cz]=size(Z);
for j=1:rz,
  i=Z(j,:);
  A=permut(i);
  di=lexico(A(s,:),p);
  dj=lexico(i,p);
  sum(di,dj)=sum(di,dj)+1;
end
Put=sum;
%end

