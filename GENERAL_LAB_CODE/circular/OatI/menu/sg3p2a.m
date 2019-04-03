% file sg3p2a.m
% toolbox MENU
data=get(hedittest1,'String'); 
%dirvar=str2num(str);
posstr=get(hedittest2,'String'); 
close(f3p2)
figure(f1)
axis('off');
tot=1;
if finite(circ), eval(['circplot(' data ',''deg'',' posstr ',tot,circ);']);
else 
  eval(['circplot(' data ',''deg'',' posstr ');']);
end
eval(['M=' data ';']);
%pr=2*(1-tcdf(abs(t),df));
%ht(3)=text(0.02,0.5,'t quantity:');
%hedit3=uicontrol('Style','edit','String',num2str(t),'Position',[195 118 40 20]);
%set(hedit3,'BackgroundColor',[1 1 1]);
%set(hedit4,'BackgroundColor',[1 1 1]);


