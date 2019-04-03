data=get(hedittest1,'String'); 
datatwo=get(hedittest2,'String'); 
%dirvar=str2num(str);
posstr=get(hedittest3,'String'); 
%m0=str2num(str);
close(f3p2)
figure(f1)
axis('off');
eval(['circplot(' data ',''deg'',' posstr ');']);
eval(['M=' data ';']);
[A,r2,n]=circaxis(M); 
[B,c,n]=circmean(M); 
if (r2<c),  % unimod 
[B,c,n]=circmean(M); 
plot([B(2);(1+c)*B(2)],[B(1);(1+c)*B(1)],'w');
psi=3*pi/4;
l1=cos(psi)*c*B(2)-sin(psi)*c*B(1);
l2=sin(psi)*c*B(2)+cos(psi)*c*B(1);
plot([(1+c)*B(2);(1+c)*B(2)+0.07*l1],[(1+c)*B(1);(1+c)*B(1)+0.07*l2],'w');
psi=-3*pi/4;
l1=cos(psi)*c*B(2)-sin(psi)*c*B(1);
l2=sin(psi)*c*B(2)+cos(psi)*c*B(1);
plot([(1+c)*B(2);(1+c)*B(2)+0.07*l1],[(1+c)*B(1);(1+c)*B(1)+0.07*l2],'w');
a=atan2(B(2),B(1));
if (a<0), a=a+2*pi;
end
% unimod
else
[A,r2,n]=circaxis(M); 
plot([A(2);(1+r2)*A(2)],[A(1);(1+r2)*A(1)],'w'); 
psi=3*pi/4;
l1=cos(psi)*r2*A(2)-sin(psi)*r2*A(1);
l2=sin(psi)*r2*A(2)+cos(psi)*r2*A(1);
plot([(1+r2)*A(2);(1+r2)*A(2)+0.07*l1],[(1+r2)*A(1);(1+r2)*A(1)+0.07*l2],'w');
psi=-3*pi/4;
l1=cos(psi)*r2*A(2)-sin(psi)*r2*A(1);
l2=sin(psi)*r2*A(2)+cos(psi)*r2*A(1);
plot([(1+r2)*A(2);(1+r2)*A(2)+0.07*l1],[(1+r2)*A(1);(1+r2)*A(1)+0.07*l2],'w');
plot([-A(2);-(1+r2)*A(2)],[-A(1);-(1+r2)*A(1)],'w');
psi=3*pi/4;
l1=-cos(psi)*r2*A(2)+sin(psi)*r2*A(1);
l2=-sin(psi)*r2*A(2)-cos(psi)*r2*A(1);
plot([-(1+r2)*A(2);-(1+r2)*A(2)+0.07*l1],[-(1+r2)*A(1);-(1+r2)*A(1)+0.07*l2],'w');
psi=-3*pi/4;
l1=-cos(psi)*r2*A(2)+sin(psi)*r2*A(1);
l2=-sin(psi)*r2*A(2)-cos(psi)*r2*A(1);
plot([-(1+r2)*A(2);-(1+r2)*A(2)+0.07*l1],[-(1+r2)*A(1);-(1+r2)*A(1)+0.07*l2],'w');
%A(1)=Cc/(n*r2); A(2)=Ss/(n*r2); 
a=atan2(A(2),A(1));
%a=a/2.0; 
A(1)=cos(a); A(2)=sin(a);   
if (a<0), a=a+2*pi;  
end
if (a>pi), a=a-pi;
end
end % bimod
eval(['circplsm(' datatwo ',''deg'',' posstr ');']);
eval(['Mtwo=' datatwo ';']);
[A,r2,n]=circaxis(Mtwo); 
[B,c,n]=circmean(Mtwo); 
if r2<c, % unimod
[B,c,n]=circmean(Mtwo); 
plot([0;0.5*c*B(2)],[0;0.5*c*B(1)],'w');
psi=3*pi/4;
l1=cos(psi)*c*B(2)-sin(psi)*c*B(1);
l2=sin(psi)*c*B(2)+cos(psi)*c*B(1);
plot([0.5*c*B(2);0.5*c*B(2)+0.07*l1],[0.5*c*B(1);0.5*c*B(1)+0.07*l2],'w');
psi=-3*pi/4;
l1=cos(psi)*c*B(2)-sin(psi)*c*B(1);
l2=sin(psi)*c*B(2)+cos(psi)*c*B(1);
plot([0.5*c*B(2);0.5*c*B(2)+0.07*l1],[0.5*c*B(1);0.5*c*B(1)+0.07*l2],'w');
a=atan2(B(2),B(1));
if (a<0), a=a+2*pi; end
else
[A,r2,n]=circaxis(Mtwo); 
a=atan2(A(2),A(1)); 
if (a<0), a=a+2*pi; end;
plot([0;0.5*r2*A(2)],[0;0.5*r2*A(1)],'w'); 
psi=3*pi/4;
l1=cos(psi)*r2*A(2)-sin(psi)*r2*A(1);
l2=sin(psi)*r2*A(2)+cos(psi)*r2*A(1);
plot([0.5*r2*A(2);0.5*r2*A(2)+0.07*l1],[0.5*r2*A(1);0.5*r2*A(1)+0.07*l2],'w');
psi=-3*pi/4;
l1=cos(psi)*r2*A(2)-sin(psi)*r2*A(1);
l2=sin(psi)*r2*A(2)+cos(psi)*r2*A(1);
plot([0.5*r2*A(2);0.5*r2*A(2)+0.07*l1],[0.5*r2*A(1);0.5*r2*A(1)+0.07*l2],'w');
plot([0;-0.5*r2*A(2)],[0;-0.5*r2*A(1)],'w');
psi=3*pi/4;
l1=-cos(psi)*r2*A(2)+sin(psi)*r2*A(1);
l2=-sin(psi)*r2*A(2)-cos(psi)*r2*A(1);
plot([-0.5*r2*A(2);-0.5*r2*A(2)+0.07*l1],[-0.5*r2*A(1);-0.5*r2*A(1)+0.07*l2],'w');
psi=-3*pi/4;
l1=-cos(psi)*r2*A(2)+sin(psi)*r2*A(1);
l2=-sin(psi)*r2*A(2)-cos(psi)*r2*A(1);
plot([-0.5*r2*A(2);-0.5*r2*A(2)+0.07*l1],[-0.5*r2*A(1);-0.5*r2*A(1)+0.07*l2],'w');
if (a>pi), a=a-pi; end
end
%pr=2*(1-tcdf(abs(t),df));
%ht(3)=text(0.02,0.5,'t quantity:');
%hedit3=uicontrol('Style','edit','String',num2str(t),'Position',[195 118 40 20]);
%ht(4)=text(0.02,0.3,'Probability:');
%hedit4=uicontrol('Style','edit','String',num2str(pr),'Position',[195 76 80 20]);
%set(ht,'FontName','Serif');
%set(ht,'FontSize',15);
%set(hedit3,'BackgroundColor',[1 1 1]);
%set(hedit4,'BackgroundColor',[1 1 1]);

