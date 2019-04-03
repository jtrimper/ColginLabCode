function [Xmin,X10,X25,X50,X75,X90,Xmax]=boxplot(x,where,demo)
%
% CALL: boxplot(x)
%       boxplot(x,[],'horizontal')
%       [Xmin,X10,X25,X50,X75,X90,Xmax]=boxplot(x)
%
if nargin<3, demo='vert'; end
if nargin<2, where=[]; end
ori='vert';
if (demo(1:4)=='hori')
  ori='hori';
end
[n,p]=size(x);
%if (where==[]), %nargin==1),
if isempty(where), %nargin==1),
%  where=[0,0.5]'*ones(1,p);
  where=[[1:p];0.4*ones(1,p)];
end
Xmin=[];
X10=[];
X25=[];
X50=[];
X75=[];
X90=[];
Xmax=[];
for j=1:p,
w=where(:,j);
y=sort(x(:,j));
m=mean(y);
x90=y(fix(0.90*n));
x75=y(fix(0.75*n));
x25=y(fix(0.25*n));
x10=y(max(1,fix(0.10*n)));
x50=y(fix(0.50*n));
%x50=median(y);
xmax=y(n);
xmin=y(1);
if (ori=='vert'),
plot([w(1);w(1)],[x10;x25],'-');
hold on
plot([w(1)-0.25*w(2);w(1)+0.25*w(2)],[x10;x10],'-');
plot([w(1);w(1)],[x75;x90],'-');
plot([w(1)-0.25*w(2);w(1)+0.25*w(2)],[x90;x90],'-');
plot([w(1)-w(2);w(1)-w(2)],[x25;x75],'-');
plot([w(1)+w(2);w(1)+w(2)],[x25;x75],'-');
plot([w(1)-w(2);w(1)+w(2)],[x75;x75],'-');
plot([w(1)-w(2);w(1)+w(2)],[x25;x25],'-');
plot([w(1)-w(2);w(1)+w(2)],[x50;x50],'-');
for i=1:n,
  if (i<fix(0.10*n))|(i>fix(0.90*n)),
    plot(w(1),y(i),'o')
  end
end
end %vert
if (ori=='hori'),
plot([x10;x25],[w(1);w(1)],'-');
hold on
plot([x10;x10],[w(1)-0.25*w(2);w(1)+0.25*w(2)],'-');
plot([x75;x90],[w(1);w(1)],'-');
plot([x90;x90],[w(1)-0.25*w(2);w(1)+0.25*w(2)],'-');
plot([x25;x75],[w(1)-w(2);w(1)-w(2)],'-');
plot([x25;x75],[w(1)+w(2);w(1)+w(2)],'-');
plot([x75;x75],[w(1)-w(2);w(1)+w(2)],'-');
plot([x25;x25],[w(1)-w(2);w(1)+w(2)],'-');
plot([x50;x50],[w(1)-w(2);w(1)+w(2)],'-');
for i=1:n,
  if (i<fix(0.10*n))|(i>fix(0.90*n)),
    plot(y(i),w(1),'o')
  end
end
end %horizontal
if xmax>0, 
  ymax=1.1*xmax;
else
  ymax=-0.9*abs(xmax);
end
if xmin>0, 
  ymin=0.9*xmin;
else
  ymin=-1.1*abs(xmin);
end
%axis([w(1)-2*w(2),w(1)+2*w(2),ymin,ymax])
Xmin=[Xmin,xmin];
X10=[X10,x10];
X25=[X25,x25];
X50=[X50,x50];
X75=[X75,x75];
X90=[X90,x90];
Xmax=[Xmax,xmax];
end
%end;

YY=get(gca,'Ylim');
XX=get(gca,'Xlim');
axis([XX(1)-0.5,XX(2)+0.5,YY(1),YY(2)]);




