function [Sut]=smat2(p,r)
% 
% CALL [S]=smat2(p,r)    
%
sum=zeros(p^r,p^r);
Perm=permut([1:r]);
[rp,cp]=size(Perm);
Z=zr([1:p],r);
[rz,cz]=size(Z);
A=permut([1:r]);
for s=1:rp,
for j=1:rz,
  i1=Z(j,:);
%  A=permut(i);
  u=A(s,:);
  for k=1:r,
  for l=1:r,
    if (u(l)==k),
      v(l)=i1(k);
    end
%    v(l)=i1(u(l));
  end
  end
%  di=lexico(A(s,:),p);
  di=lexico(v,p);
  dj=lexico(i1,p);
  sum(di,dj)=sum(di,dj)+1;
end
end
Sut=sum/fac(r);
end

