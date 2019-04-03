function [T]=commut(p)
%function [Sut]=smat(p,r)
% 
% CALL [T]=commut(p)
%      T=T_{p,p}
%
sum=zeros(p^2,p^2);
%Perm=permut([1:r]);
Perm=permut([1:2]);
[rp,cp]=size(Perm);
Z=zr([1:p],2);
%Z=zr([1:p],r);
[rz,cz]=size(Z);
%for s=1:rp,
for s=rp:rp,
for j=1:rz,
  i=Z(j,:);
  A=permut(i);
  di=lexico(A(s,:),p);
  dj=lexico(i,p);
  sum(di,dj)=sum(di,dj)+1;
end
end
T=sum; %/fac(r);
end

