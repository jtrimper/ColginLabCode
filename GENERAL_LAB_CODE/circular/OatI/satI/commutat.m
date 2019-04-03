function [P]=commutat(A,B)
% 
% CALL [P]=commutat(A,B)   
[m1,n1]=size(A);
[m2,n2]=size(B);
D=[];
for l=1:m2,
C=[];
for k=1:n1,
  C=[C,A(:,k)*B(l,:)];
end
  D=[D;C];
end
P=D;
%end

