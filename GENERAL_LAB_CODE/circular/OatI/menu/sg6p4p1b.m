plfig=figure('Name','Plot','NumberTitle','off','Position',[100 180 470 300]); 
eval(['plot(' datax ',' datay ',''o'')'])
hold on
u=eval(['sort(' datax ')']);
t=linspace(u(1),u(length(u)),30)';
plot(t,a+b*t)
