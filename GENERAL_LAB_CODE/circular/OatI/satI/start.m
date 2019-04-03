load unfam.dat
A=unfam;
M=A(:,1);
S=A(:,2);
[rm cm]=size(M);
I=ones(size(M));
for i=1:rm
  if (S(i)==5)
   G(i)=1; %0
  else
   G(i)=1;
  end
end
[T]=select(A,G',I);
circle(T,'degrees')
torad=pi/180;
B=[cos(torad*T(:,3)) sin(torad*T(:,3))];
U=B';
 B=[cos(torad*T(:,1)) sin(torad*T(:,1))];
X=B';
[rows cols]=size(X);
[R,v,d]=RV(X,U);
plot([0;v(2)],[0;v(1)])
hold on
plot([0;d(2)/cols],[0;d(1)/cols])
for i=1:cols
plot([0,U(2,i)],[0,U(1,i)])
% plot([(1-r)*U(2,i),U(2,i)],[(1-r)*U(1,i),U(1,i)])
plot([-1.1*U(2,i),(-1.1+R(i))*U(2,i)],[-1.1*U(1,i),(-1.1+R(i))*U(1,i)])
V=atan2(v(2),v(1));
if (V<0), V=V+2*pi;
end
for i=1:cols
if (S(i)==1)
  text(-1.2,-0.8,'r1 =','HorizontalAlignment','left')
  text(-1,-0.8,num2str(R(i)),'HorizontalAlignment','left')
end
if (S(i)==2)
  text(-1.2,-0.9,'r2 =','HorizontalAlignment','left')
  text(-1,-0.9,num2str(R(i)),'HorizontalAlignment','left')
end
if (S(i)==3)
  text(-1.2,-1.0,'r3 =','HorizontalAlignment','left')
  text(-1,-1.0,num2str(R(i)),'HorizontalAlignment','left')
end
if (S(i)==4)
  text(-1.2,-1.1,'r4 =','HorizontalAlignment','left')
  text(-1,-1.1,num2str(R(i)),'HorizontalAlignment','left')
end
if (S(i)==5)
  text(-1.2,-1.2,'r5 =','HorizontalAlignment','left')
  text(-1,-1.2,num2str(R(i)),'HorizontalAlignment','left')
end
end

text(1.0,-0.9,'/v/ =','HorizontalAlignment','left')
text(1.2,-0.9,num2str(sqrt(v(1)*v(1)+v(2)*v(2))),'HorizontalAlignment','left')
text(1.0,-1.0,'av =','HorizontalAlignment','left')
text(1.2,-1.0,num2str(180*V/pi),'HorizontalAlignment','left')
text(1.0,-1.1,'n =','HorizontalAlignment','left')
text(1.2,-1.1,num2str(cols),'HorizontalAlignment','left')
[B,c]=circmean(T);
plot([0;c*B(2)],[0;c*B(1)])
end


