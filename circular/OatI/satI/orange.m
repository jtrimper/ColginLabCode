function [f,r2,n,v]=orange(x)
%
%
M=[20,135,145,165,170,200,300,325,335,350,350,350,355]';
[A,r2,n,v]=circaxis(M);
[r,c]=size(x);
for j1=1;r,
  for j2=1:c,
   f(j1,j2)=sqrt(n)*r2*sin(2*(v-x(j1,j2)))/sqrt(0.5*(1-ones(1,n)*cos(4*(M*pi/180-x(j1,j2)))/n));
  end
end
end
