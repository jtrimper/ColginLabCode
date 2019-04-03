figure(f2)
text(0.05,0.4,'Mean:');
med=num2str(m)
hedit=uicontrol('Style','edit','String',med,'Position',[150 40 60 20])
text(0.05,0.2,'Std:');
std=num2str(s)
hedit=uicontrol('Style','edit','String',std,'Position',[150 20 60 20])
