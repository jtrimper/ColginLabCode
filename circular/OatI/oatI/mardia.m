function [t,case]=mardia(x,y);
%
% CALL: [t,c]=mardia(x,y)
%
% where       x = vector of directions
%             y = another vector of directions
%
t=[];
%datax=get(hedittest1,'String'); 
%datay=get(hedittest2,'String'); 
%%mardia=figure
%%axis('off');
%eval(['[A1,r1,n1]=circmean(' datax ');']);
%eval(['[A2,r2,n2]=circmean(' datay ');']);
[A1,r1,n1]=circmean(x);
[A2,r2,n2]=circmean(y);
r=(n1*r1+n2*r2)/(n1+n2);
t1=(2/sqrt(3))*(asin(2*sqrt(3/8)*r1)-asin(2*sqrt(3/8)*r2))/sqrt(1/(n1-4)+1/(n2-4));
t2=(asinh((r1-1.0894)/0.25789)-asinh((r2-1.0894)/0.25789))/(0.89325*sqrt(1/(n1-3)+1/(n2-3)));
t3=n1*(1-r1)*(n2-1)/(n2*(1-r2)*(n1-1));
if (r<0.45),
  t=t1;
  case='I';
%%hedit4=uicontrol('Style','edit','String',num2str(t),'Position',[270 80 140 20]);
%%set(hedit4,'BackgroundColor',[1 1 1]);
%%ht(1)=text(0.02,0.3,'Case I: Test quantity =');
elseif (r<0.70),
  t=t2;
  case='II';
%%hedit4=uicontrol('Style','edit','String',num2str(t),'Position',[270 80 140 20]);
%%set(hedit4,'BackgroundColor',[1 1 1]);
%%ht(2)=text(0.02,0.3,'Case II: Test quantity =');
else
  t=t3;
  case='III';
%%hedit4=uicontrol('Style','edit','String',num2str(t),'Position',[270 80 140 20]);
%%set(hedit4,'BackgroundColor',[1 1 1]);
%%ht(3)=text(0.02,0.3,'Case III: Test quantity =');
end
%%set(ht,'FontName','Serif');
%%set(ht,'FontSize',15);
%end fcn


